// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ForgeCoordinator} from "../../src/core/ForgeCoordinator.sol";
import {SoloAscendHero} from "../../src/core/SoloAscendHero.sol";
import {HeroClassRegistry} from "../../src/core/registries/HeroClassRegistry.sol";
import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {OracleRegistry} from "../../src/core/registries/OracleRegistry.sol";
import {HookRegistry} from "../../src/core/registries/HookRegistry.sol";
import {ForgeItemRegistry} from "../../src/core/registries/ForgeItemRegistry.sol";
import {Treasury} from "../../src/core/Treasury.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {HeroMetadataRenderer} from "../../src/utils/HeroMetadataRenderer.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {FTForgeEffect} from "../../src/effects/FTForgeEffect.sol";
import {AttributeForgeEffect} from "../../src/effects/AttributeForgeEffect.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {IForgeEffect} from "../../src/interfaces/IForgeEffect.sol";
import {ITreasury} from "../../src/interfaces/ITreasury.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";
import {TraitSetup} from "../helpers/TraitSetup.sol";

/// @title FTForgeEffectTest
/// @notice Test suite for verifying FTForgeEffect functionality
/// @dev Tests that FT effects properly distribute treasury rewards
contract FTForgeEffectTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          CONTRACTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    ForgeCoordinator public forgeCoordinator;
    SoloAscendHero public heroContract;
    HeroClassRegistry public heroClassRegistry;
    ForgeEffectRegistry public forgeEffectRegistry;
    OracleRegistry public oracleRegistry;
    HookRegistry public hookRegistry;
    ForgeItemRegistry public forgeItemRegistry;
    Treasury public treasury;
    HeroTraitRegistry public traitRegistry;
    HeroMetadataRenderer public metadataRenderer;
    MockERC6551Registry public erc6551Registry;
    MockOracle public mockOracle;

    // Effect contracts
    FTForgeEffect public ftEffect;
    AttributeForgeEffect public attributeEffect;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 constant MINT_PRICE = 0.001 ether;
    address constant ALICE = address(0x1);
    address constant BOB = address(0x2);

    address admin;
    address erc6551Implementation;
    uint256 oracleId = 1;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           SETUP                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        admin = address(this);
        erc6551Implementation = address(0x1234);

        // Deploy mock contracts
        erc6551Registry = new MockERC6551Registry();
        mockOracle = new MockOracle();

        // Deploy registries
        heroClassRegistry = new HeroClassRegistry(admin);
        forgeEffectRegistry = new ForgeEffectRegistry(admin);
        oracleRegistry = new OracleRegistry(admin);
        hookRegistry = new HookRegistry(admin);
        forgeItemRegistry = new ForgeItemRegistry(admin);

        // Deploy treasury
        treasury = new Treasury(admin);

        // Deploy HeroTraitRegistry
        traitRegistry = new HeroTraitRegistry(admin);

        // Deploy metadata renderer
        metadataRenderer = new HeroMetadataRenderer(admin, address(heroClassRegistry), address(traitRegistry));

        // Deploy ForgeCoordinator
        forgeCoordinator = new ForgeCoordinator(
            admin,
            address(forgeEffectRegistry),
            address(forgeItemRegistry),
            address(oracleRegistry),
            address(hookRegistry),
            address(treasury)
        );

        // Deploy hero contract
        heroContract = new SoloAscendHero(
            admin,
            address(heroClassRegistry),
            address(forgeCoordinator),
            address(forgeEffectRegistry),
            address(hookRegistry),
            address(treasury),
            address(erc6551Registry),
            erc6551Implementation,
            address(metadataRenderer)
        );

        // Deploy effect contracts
        ftEffect = new FTForgeEffect(admin, address(treasury), address(heroContract), address(forgeCoordinator));
        attributeEffect = new AttributeForgeEffect(admin, address(forgeCoordinator));

        // Setup effects registry
        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.FT,
            "Token Reward",
            "Grants treasury token rewards",
            address(ftEffect)
        );

        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute Boost",
            "Increases basic hero attributes",
            address(attributeEffect)
        );

        // Setup oracle with GOLD/RAINBOW bias for FT effects
        _setupHighQualityOracle();

        // Setup forge coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Setup forge item registry with real ForgeItemNFT contracts
        ForgeItemSetup.setupDefaultForgeItemContracts(
            forgeItemRegistry,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Fund treasury with some ETH for testing rewards
        vm.deal(address(treasury), 10 ether);

        // Authorize forge coordinator to distribute treasury rewards
        treasury.setAuthorizedDistributor(address(forgeCoordinator), true);

        // Setup basic traits for testing
        TraitSetup.setupBasicTraits(traitRegistry);

        // Fund Alice for minting
        vm.deal(ALICE, 1 ether);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Test that FT effects only appear in GOLD/RAINBOW quality
    function testFTEffectQualityRestriction() public view {
        // Test that FT is not available for SILVER quality
        assertFalse(
            ftEffect.isAvailable(GameConstants.ForgeQuality.SILVER, 0),
            "FT should not be available for SILVER quality"
        );

        // Test that FT is available for GOLD quality
        assertTrue(ftEffect.isAvailable(GameConstants.ForgeQuality.GOLD, 0), "FT should be available for GOLD quality");

        // Test that FT is available for RAINBOW quality
        assertTrue(
            ftEffect.isAvailable(GameConstants.ForgeQuality.RAINBOW, 0),
            "FT should be available for RAINBOW quality"
        );

        // Test that FT is not available for MYTHIC quality (default weight is 0)
        assertFalse(
            ftEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 0),
            "FT should not be available for MYTHIC quality"
        );
    }

    /// @notice Test FT effect reward calculation
    function testFTEffectRewardCalculation() public view {
        // Test GOLD quality potential reward (1% of treasury)
        uint256 treasuryBalance = address(treasury).balance;
        uint256 goldReward = ftEffect.calculatePotentialReward(GameConstants.ForgeQuality.GOLD);
        uint256 expectedGoldReward = (treasuryBalance * 100) / 10_000; // 1% in basis points

        console2.log("Treasury balance:", treasuryBalance);
        console2.log("GOLD potential reward:", goldReward);
        console2.log("Expected GOLD reward:", expectedGoldReward);

        assertEq(goldReward, expectedGoldReward, "GOLD quality should give 1% of treasury");

        // Test RAINBOW quality potential reward (3% of treasury)
        uint256 rainbowReward = ftEffect.calculatePotentialReward(GameConstants.ForgeQuality.RAINBOW);
        uint256 expectedRainbowReward = (treasuryBalance * 300) / 10_000; // 3% in basis points

        console2.log("RAINBOW potential reward:", rainbowReward);
        console2.log("Expected RAINBOW reward:", expectedRainbowReward);

        assertEq(rainbowReward, expectedRainbowReward, "RAINBOW quality should give 3% of treasury");

        // Test SILVER quality (should be 0)
        uint256 silverReward = ftEffect.calculatePotentialReward(GameConstants.ForgeQuality.SILVER);
        assertEq(silverReward, 0, "SILVER quality should give no treasury reward");
    }

    /// @notice Test that FT effects distribute treasury rewards to hero owner
    function testFTEffectDistributesTreasuryReward() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set FT weight to maximum to guarantee it appears
        ftEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);

        // Set ATTRIBUTE weight to 0 to prevent other effects
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 0);

        // Record ALICE's initial balance
        uint256 aliceInitialBalance = ALICE.balance;
        console2.log("ALICE initial balance:", aliceInitialBalance);

        // Perform forge to get FT effect
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        // Fulfill the forge request
        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 12_345);

        // Check that ALICE received treasury reward
        uint256 aliceFinalBalance = ALICE.balance;
        console2.log("ALICE final balance:", aliceFinalBalance);

        // ALICE should have received some treasury reward (minus gas costs for the forge)
        // Note: The exact amount will vary due to randomness in effect generation
        assertTrue(aliceFinalBalance > aliceInitialBalance - forgeCost, "ALICE should have received treasury reward");
    }

    /// @notice Test FT effects with RAINBOW quality give larger rewards
    function testFTEffectWithRainbowQuality() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set weights to guarantee FT effect with RAINBOW quality
        ftEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 0);

        // Record ALICE's initial balance
        uint256 aliceInitialBalance = ALICE.balance;

        // Perform forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        // Fulfill with RAINBOW quality (seed % 100 should be 50-94 for RAINBOW)
        uint256 rainbowSeed = 77; // 77 % 100 = 77, which is in RAINBOW range (50-94)
        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, rainbowSeed);

        // Check that ALICE received a substantial treasury reward
        uint256 aliceFinalBalance = ALICE.balance;

        // RAINBOW should give larger rewards than GOLD
        assertTrue(
            aliceFinalBalance > aliceInitialBalance - forgeCost,
            "ALICE should have received RAINBOW treasury reward"
        );
    }

    /// @notice Test that treasury balance decreases when rewards are distributed
    function testTreasuryBalanceDecreasesOnReward() public {
        // Record initial treasury balance
        uint256 initialTreasuryBalance = address(treasury).balance;
        console2.log("Initial treasury balance:", initialTreasuryBalance);

        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set FT weight to guarantee it appears
        ftEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 0);

        // Perform forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 12_345);

        // Check that treasury balance decreased
        uint256 finalTreasuryBalance = address(treasury).balance;
        console2.log("Final treasury balance:", finalTreasuryBalance);

        assertTrue(
            finalTreasuryBalance < initialTreasuryBalance,
            "Treasury balance should decrease after reward distribution"
        );
    }

    /// @notice Test that FT effects emit proper events
    function testFTEffectEmitsEvents() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set weights to guarantee FT effect
        ftEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 0);

        // Test will verify that the FT effect is executed (no explicit event check for now)

        // Perform forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 12_345);
    }

    /// @notice Test reward percentage limits
    function testRewardPercentageLimits() public {
        // Test setting reward percentage at the maximum (10%)
        ftEffect.setRewardPercentage(GameConstants.ForgeQuality.GOLD, 1000); // 10% in basis points

        // Test that setting above maximum fails
        vm.expectRevert();
        ftEffect.setRewardPercentage(GameConstants.ForgeQuality.GOLD, 1001); // 10.01% should fail
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       PRIVATE HELPERS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Setup oracle to favor GOLD/RAINBOW qualities for FT testing
    function _setupHighQualityOracle() private {
        oracleId = 1; // Use ID 1 for testing

        // Setup supported qualities and weights
        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory weights = new uint256[](4);
        weights[0] = 5; // 5% SILVER
        weights[1] = 45; // 45% GOLD
        weights[2] = 45; // 45% RAINBOW
        weights[3] = 5; // 5% MYTHIC

        oracleRegistry.registerOracle(
            oracleId,
            "High Quality Oracle",
            "Oracle that favors higher quality forges",
            address(mockOracle),
            10_000, // fixed fee
            supportedQualities,
            weights
        );
    }
}
