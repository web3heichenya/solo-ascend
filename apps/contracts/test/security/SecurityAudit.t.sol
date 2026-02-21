// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {ForgeCoordinator} from "../../src/core/ForgeCoordinator.sol";
import {SoloAscendHero} from "../../src/core/SoloAscendHero.sol";
import {Treasury} from "../../src/core/Treasury.sol";
import {HeroClassRegistry} from "../../src/core/registries/HeroClassRegistry.sol";
import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {OracleRegistry} from "../../src/core/registries/OracleRegistry.sol";
import {HookRegistry} from "../../src/core/registries/HookRegistry.sol";
import {ForgeItemRegistry} from "../../src/core/registries/ForgeItemRegistry.sol";
import {HeroMetadataRenderer} from "../../src/utils/HeroMetadataRenderer.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {TestHelpers} from "../helpers/TestHelpers.sol";
import {ForgeEffectSetup} from "../helpers/ForgeEffectSetup.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";
import {TraitSetup} from "../helpers/TraitSetup.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title SecurityAuditTest
/// @notice Comprehensive security tests for Solo Ascend contracts
contract SecurityAuditTest is TestHelpers {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      STATE VARIABLES                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    ForgeCoordinator public forgeCoordinator;
    SoloAscendHero public heroContract;
    Treasury public treasury;
    HeroClassRegistry public heroClassRegistry;
    ForgeEffectRegistry public forgeEffectRegistry;
    OracleRegistry public oracleRegistry;
    HookRegistry public hookRegistry;
    ForgeItemRegistry public forgeItemRegistry;
    HeroMetadataRenderer public metadataRenderer;
    HeroTraitRegistry public traitRegistry;
    MockERC6551Registry public erc6551Registry;
    MockOracle public mockOracle;
    MockHook public mockHook;

    address public admin;
    address public erc6551Implementation;
    uint256 public oracleId;
    address public attacker;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         SETUP                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        admin = address(this);
        attacker = address(0xDEADBEEF);
        erc6551Implementation = address(0x1234);

        // Deploy mock contracts
        erc6551Registry = new MockERC6551Registry();
        mockOracle = new MockOracle();
        mockHook = new MockHook();

        // Deploy registries
        heroClassRegistry = new HeroClassRegistry(admin);
        forgeEffectRegistry = new ForgeEffectRegistry(admin);
        oracleRegistry = new OracleRegistry(admin);
        hookRegistry = new HookRegistry(admin);
        forgeItemRegistry = new ForgeItemRegistry(admin);

        // Deploy treasury
        treasury = new Treasury(admin);

        // Deploy HeroAvatarLib
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

        // Set hero contract in coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Setup forge effects
        ForgeEffectSetup.setupDefaultForgeEffects(forgeEffectRegistry);

        // Setup forge item contracts
        ForgeItemSetup.setupDefaultForgeItemContracts(
            forgeItemRegistry,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Setup oracle
        _setupOracle();

        // Setup basic traits for testing
        TraitSetup.setupBasicTraits(traitRegistry);

        // Fund test accounts
        fundAccount(ALICE, 10 ether);
        fundAccount(BOB, 10 ether);
        fundAccount(CHARLIE, 10 ether);
        fundAccount(attacker, 10 ether);
    }

    function _setupOracle() internal {
        oracleId = 1;

        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory distributionWeights = new uint256[](4);
        distributionWeights[0] = 7000;
        distributionWeights[1] = 2000;
        distributionWeights[2] = 900;
        distributionWeights[3] = 100;

        oracleRegistry.registerOracle(
            oracleId,
            "MockOracle",
            "Mock oracle for testing",
            address(mockOracle),
            10_000,
            supportedQualities,
            distributionWeights
        );

        mockOracle.setFixedRandomSeed(12_345);
        mockOracle.setAutoFulfill(false);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   REENTRANCY TESTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testReentrancyProtection_Mint() public {
        // Since there's no refund mechanism, reentrancy during mint won't be triggered
        // This test should pass without reverting because no ETH is sent back
        ReentrancyAttacker attackContract = new ReentrancyAttacker(address(heroContract));
        fundAccount(address(attackContract), 5 ether);

        vm.prank(address(attackContract));
        // Should succeed without reentrancy attempt since no refund triggers receive()
        attackContract.attackMint();

        // Verify the attack didn't succeed (only one token minted)
        assertEq(heroContract.balanceOf(address(attackContract)), 1, "Should only mint one token");
        assertFalse(attackContract.attacked(), "Reentrancy should not have been triggered");
    }

    function testReentrancyProtection_Forge() public {
        // Mint hero first
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Since there's no refund in forge operations, reentrancy won't be triggered
        // This test should pass without reverting
        ReentrancyAttacker attackContract = new ReentrancyAttacker(address(heroContract));
        fundAccount(address(attackContract), 5 ether);

        // Transfer hero to attacker
        vm.prank(ALICE);
        heroContract.transferFrom(ALICE, address(attackContract), tokenId);

        advanceTime(1 days);
        vm.prank(address(attackContract));
        // Should succeed without reentrancy attempt since no refund triggers receive()
        attackContract.attackForge(tokenId, oracleId);

        // Verify forge was initiated successfully
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Forge should be pending");
        assertFalse(attackContract.attacked(), "Reentrancy should not have been triggered");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   ACCESS CONTROL TESTS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testUnauthorizedForgeCoordinatorAccess() public {
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with UnauthorizedCaller
        forgeCoordinator.setHeroContract(address(0x999));
    }

    function testUnauthorizedOracleAccess() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Try to directly call coordinator functions
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with UnauthorizedCaller
        forgeCoordinator.initiateForgeAndRequestAuto(tokenId, attacker, oracleId, 100_000);
    }

    function testUnauthorizedHeroOperations() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Try to set hero name without ownership
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with NotOwner
        heroContract.setHeroName(tokenId, "Hacked");

        // Try to forge without ownership
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(attacker);
        vm.expectRevert(); // Should revert with NotOwner
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);
    }

    function testRegistryAccessControl() public {
        // Try to register hero class without admin rights
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with OwnableUnauthorizedAccount
        heroClassRegistry.registerHeroClass(
            GameConstants.HeroClass.WARRIOR,
            "EvilWarrior",
            "Hacked class",
            GameConstants.HeroAttributes(1000, 10, 100, 50, 100, 50, 100, 50, 100, 100, 15, 50, 30, 500, 20, 75)
        );

        // Try to register oracle without admin rights
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with OwnableUnauthorizedAccount
        GameConstants.ForgeQuality[] memory qualities = new GameConstants.ForgeQuality[](1);
        qualities[0] = GameConstants.ForgeQuality.SILVER;
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10_000;
        oracleRegistry.registerOracle(999, "Evil", "Evil oracle", attacker, 0, qualities, weights);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   ECONOMIC ATTACK TESTS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testInsufficientPaymentAttacks() public {
        // Try to mint with insufficient payment
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with InsufficientPayment
        heroContract.mint{value: MINT_PRICE - 1}();

        // Mint hero properly first
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // setHeroName is free, so it should succeed without payment
        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, "Free Name");
        // Verify name was set
        assertEq(heroContract.getHeroName(tokenId), "Free Name", "Name should be set successfully");

        // Try to forge with insufficient payment
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with InsufficientPayment
        heroContract.performDailyForge{value: forgeCost - 1}(tokenId, oracleId, gasLimit);
    }

    function testExcessPaymentHandling() public {
        uint256 initialBalance = ALICE.balance;

        // Mint with excess payment - no refund expected, excess is kept by contract
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE + 1 ether}();

        uint256 balanceAfterMint = ALICE.balance;
        // Should have deducted the full amount (including excess)
        assertEq(initialBalance - balanceAfterMint, MINT_PRICE + 1 ether, "Should keep excess payment");

        // Test excess payment in forge - no refund expected
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        uint256 balanceBeforeForge = ALICE.balance;
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost + 0.5 ether}(tokenId, oracleId, gasLimit);

        uint256 balanceAfterForge = ALICE.balance;
        // Should have deducted the full amount (including excess)
        assertEq(balanceBeforeForge - balanceAfterForge, forgeCost + 0.5 ether, "Should keep excess forge payment");
    }

    function testDrainAttacks() public {
        // Try to drain treasury (should fail)
        uint256 treasuryBalance = address(treasury).balance;

        // Mint some heroes to put funds in treasury
        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();
        vm.prank(BOB);
        heroContract.mint{value: MINT_PRICE}();

        assertTrue(address(treasury).balance > treasuryBalance, "Treasury should have funds");

        // Treasury doesn't have a direct withdraw function - funds are distributed via distributeReward
        // Try to distribute as unauthorized address
        vm.prank(attacker);
        vm.expectRevert(); // Should revert with UnauthorizedDistributor
        treasury.distributeReward(attacker, 10_000); // 100% reward (should fail)
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   ORACLE MANIPULATION TESTS                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testOracleManipulation() public {
        // Try to fulfill randomness from unauthorized address
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Try to fulfill from unauthorized address
        vm.prank(attacker);
        vm.expectRevert(); // Should revert - only registered oracle can fulfill
        forgeCoordinator.fulfillForge(requestId, 12_345);
    }

    function testInvalidOracleRequests() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;

        // Try to use non-existent oracle
        uint256 fakeOracleId = 999;
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with OracleNotFound or similar
        heroContract.performDailyForge{value: 1 ether}(tokenId, fakeOracleId, gasLimit);
    }

    function testDoubleSpendingPrevention() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // First forge request
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Try to make another request while first is pending
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with RequestAlreadyPending
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   INTEGER OVERFLOW TESTS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testIntegerOverflowProtection() public {
        // Test extreme gas limit values
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);

        // Test with maximum uint32 gas limit
        uint32 maxGasLimit = type(uint32).max;
        uint256 cost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, maxGasLimit);

        // Should not overflow
        assertTrue(cost > 0, "Cost calculation should handle max gas limit");
        assertTrue(cost < type(uint256).max, "Cost should not overflow");
    }

    function testTokenIdLimits() public {
        // Test behavior with multiple token IDs (each address can only mint once)
        // This tests internal calculations don't overflow

        address[] memory accounts = new address[](5);
        accounts[0] = ALICE;
        accounts[1] = BOB;
        accounts[2] = CHARLIE;
        accounts[3] = address(0x1001);
        accounts[4] = address(0x1002);

        // Fund additional accounts
        fundAccount(accounts[3], 1 ether);
        fundAccount(accounts[4], 1 ether);

        // Mint tokens from different accounts (each can only mint once)
        for (uint256 i = 0; i < 5; i++) {
            vm.prank(accounts[i]);
            heroContract.mint{value: MINT_PRICE}();
        }

        // All tokens should have sequential IDs starting from 1
        for (uint256 i = 1; i <= 5; i++) {
            assertEq(heroContract.ownerOf(i), accounts[i - 1], "Token should be owned by correct account");
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   EDGE CASE TESTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testZeroAddressProtection() public {
        // Test zero address inputs are handled properly
        vm.expectRevert(); // Should fail at deployment or initialization
        new SoloAscendHero(
            address(0), // admin is zero
            address(heroClassRegistry),
            address(forgeCoordinator),
            address(forgeEffectRegistry),
            address(hookRegistry),
            address(treasury),
            address(erc6551Registry),
            erc6551Implementation,
            address(metadataRenderer)
        );
    }

    function testInvalidTokenOperations() public {
        // Try operations on non-existent token
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with ERC721NonexistentToken
        heroContract.setHeroName(999, "Ghost");

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with ERC721NonexistentToken
        heroContract.getHero(999).stage;

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(999, oracleId, gasLimit);

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with TokenNotFound or similar
        heroContract.performDailyForge{value: forgeCost}(999, oracleId, gasLimit);
    }

    function testCooldownBypass() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // First forge should succeed immediately (no cooldown for new heroes)
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 firstRequestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(firstRequestId, 5000, address(forgeCoordinator));

        // Second forge attempt should fail due to cooldown
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with CooldownNotMet
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Wait exactly the cooldown period
        advanceTime(1 days);

        // Should work now after cooldown
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Second forge should be pending");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   GAS GRIEFING TESTS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGasGriefingProtection() public {
        // Test with very high gas limit
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);

        // Use maximum reasonable gas limit
        uint32 highGasLimit = 5_000_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, highGasLimit);

        // Should calculate cost without issues
        assertTrue(forgeCost > 0, "Should calculate cost for high gas limit");

        // Test if transaction would succeed (may need high gas limit to actually execute)
        vm.prank(ALICE);
        // This should not revert due to gas issues in cost calculation
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, highGasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "High gas forge should work");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   FRONT-RUNNING TESTS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFrontRunningProtection() public {
        // Test that transactions can't be easily front-run
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Alice initiates forge
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // In MockOracle, anyone can fulfill (no access control for testing)
        // But the first fulfillment should succeed and clear the request
        vm.prank(attacker);
        mockOracle.fulfillRandomnessWithSeed(requestId, 9999, address(forgeCoordinator));

        // Verify forge was completed by the attacker's fulfillment
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Forge should be completed");

        // Second attempt should fail because request is already fulfilled
        vm.expectRevert("Request not found");
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   HELPER CONTRACTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
}

/// @title ReentrancyAttacker
/// @notice Contract to test reentrancy protection
contract ReentrancyAttacker {
    SoloAscendHero public heroContract;
    bool public attacked = false;

    constructor(address _heroContract) {
        heroContract = SoloAscendHero(_heroContract);
    }

    receive() external payable {
        if (!attacked && address(this).balance > 0.01 ether) {
            attacked = true;
            // Try to reenter
            heroContract.mint{value: 0.01 ether}();
        }
    }

    function attackMint() external {
        heroContract.mint{value: 0.01 ether}();
    }

    function attackForge(uint256 tokenId, uint256 oracleId) external {
        heroContract.performDailyForge{value: 1 ether}(tokenId, oracleId, 100_000);
    }
}
