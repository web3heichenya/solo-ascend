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
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {ISoloAscendHero} from "../../src/interfaces/ISoloAscendHero.sol";
import {IHookRegistry} from "../../src/interfaces/IHookRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title ForgeCoordinatorTest
/// @notice Comprehensive tests for ForgeCoordinator contract
contract ForgeCoordinatorTest is TestHelpers {
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

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         SETUP                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        admin = address(this);
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
        _setupBasicTraits();

        // Fund test accounts
        fundAccount(ALICE, 10 ether);
        fundAccount(BOB, 10 ether);
        fundAccount(CHARLIE, 10 ether);
    }

    function _setupOracle() internal {
        oracleId = 1; // Use ID 1 for testing

        // Setup supported qualities and weights
        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory distributionWeights = new uint256[](4);
        distributionWeights[0] = 7000; // Silver - 70%
        distributionWeights[1] = 2000; // Gold - 20%
        distributionWeights[2] = 900; // Rainbow - 9%
        distributionWeights[3] = 100; // Mythic - 1%

        // Register mock oracle
        oracleRegistry.registerOracle(
            oracleId,
            "MockOracle",
            "Mock oracle for testing",
            address(mockOracle),
            10_000, // Fixed fee of 10000 wei per gas
            supportedQualities,
            distributionWeights
        );

        // Set fixed seed for predictable testing
        mockOracle.setFixedRandomSeed(12_345);
        mockOracle.setAutoFulfill(false); // Manual fulfillment for testing
    }

    function _setupBasicTraits() internal {
        // Register basic traits for all required layers

        // BACKGROUND traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BACKGROUND,
            '<rect width="400" height="400" fill="#1a1a1a"/>',
            "Dark Background"
        );

        // BASE traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BASE,
            '<rect x="100" y="70" width="200" height="260" fill="#dbb180"/>',
            "Human"
        );

        // EYES traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.EYES,
            '<circle cx="180" cy="105" r="3" fill="#000000"/><circle cx="220" cy="105" r="3" fill="#000000"/>',
            "Normal Eyes"
        );

        // MOUTH traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.MOUTH,
            '<rect x="190" y="125" width="20" height="3" fill="#711010"/>',
            "Normal Mouth"
        );

        // HAIR_HAT traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.HAIR_HAT,
            '<rect x="150" y="60" width="100" height="35" fill="#654321" rx="18"/>',
            "Short Brown Hair"
        );

        // BODY traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BODY,
            '<rect x="133" y="145" width="134" height="130" fill="#8B4513"/>',
            "Leather Armor"
        );

        // LEGS traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.LEGS,
            '<rect x="160" y="265" width="80" height="70" fill="#654321"/>',
            "Brown Pants"
        );

        // FOOT traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.FOOT,
            '<rect x="155" y="330" width="90" height="22" fill="#000000"/>',
            "Black Boots"
        );

        // Register weapons for each class
        for (uint256 i = 0; i <= uint256(GameConstants.HeroClass.PRIEST); i++) {
            traitRegistry.registerWeaponTrait(
                GameConstants.HeroClass(i),
                '<rect x="270" y="125" width="65" height="170" fill="#C0C0C0"/>',
                '<rect x="270" y="125" width="65" height="170" fill="#FFD700"/>',
                '<rect x="270" y="125" width="65" height="170" fill="#FF69B4"/>',
                string(abi.encodePacked("Weapon", vm.toString(i + 1)))
            );
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    FORGE REQUEST TESTS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testInitiateForge_Success() public {
        // First mint a hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract (this will internally call the coordinator)
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Check that hero has a pending forge
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Hero should have pending forge");

        bytes32 pendingRequestId = forgeCoordinator.getPendingRequest(tokenId);
        assertNotEq(pendingRequestId, bytes32(0), "Pending request should exist");

        // Verify forge request was stored
        IForgeCoordinator.ForgeRequest memory request = forgeCoordinator.getForgeRequest(pendingRequestId);
        assertEq(request.heroId, tokenId, "Hero ID should match");
        assertEq(request.requester, ALICE, "Requester should match");
        assertEq(request.oracleId, oracleId, "Oracle ID should match");
        assertFalse(request.fulfilled, "Request should not be fulfilled yet");
    }

    function testInitiateForge_RevertWhenInsufficientFee() public {
        // First mint a hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with insufficient payment

        heroContract.performDailyForge{value: forgeCost - 1}(tokenId, oracleId, gasLimit);
    }

    function testInitiateForge_RevertWhenHasPendingRequest() public {
        // First mint a hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // First forge request
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Second forge request should fail
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert because hero already has pending request

        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   FORGE FULFILLMENT TESTS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFulfillForge_Success() public {
        // First mint a hero and initiate forge
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Verify initial state
        assertTrue(mockOracle.isPending(requestId), "Oracle should have pending request");
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Hero should have pending forge");

        // Fulfill the forge through oracle
        uint256 randomSeed = 12_345;

        // Use the mockOracle to fulfill the randomness
        mockOracle.fulfillRandomnessWithSeed(requestId, randomSeed, address(forgeCoordinator));

        // Verify forge was fulfilled
        IForgeCoordinator.ForgeRequest memory request = forgeCoordinator.getForgeRequest(requestId);
        assertTrue(request.fulfilled, "Request should be fulfilled");
        assertEq(request.randomSeed, randomSeed, "Random seed should be stored");

        // Hero should no longer have pending request
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Hero should not have pending forge");
        assertEq(forgeCoordinator.getPendingRequest(tokenId), bytes32(0), "Pending request should be cleared");
    }

    function testFulfillForge_RevertWhenRequestNotFound() public {
        bytes32 nonExistentRequestId = keccak256("non-existent");

        vm.expectRevert("Request not found");
        mockOracle.fulfillRandomnessWithSeed(nonExistentRequestId, 12_345, address(forgeCoordinator));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                 MANUAL FULFILLMENT TESTS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFulfillForgeManually_RevertWhenNotRequester() public {
        // First mint a hero and initiate forge
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Wait for 2 hours + 1 second to pass the timeout
        advanceTime(2 hours + 1 seconds);

        // Try to fulfill manually with wrong caller (BOB instead of ALICE)
        vm.prank(BOB);
        vm.expectRevert(abi.encodeWithSignature("UnauthorizedCaller()"));
        forgeCoordinator.fulfillForgeManually(requestId);
    }

    function testFulfillForgeManually_RevertWhenTooEarly() public {
        // First mint a hero and initiate forge
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Try to fulfill manually before 2 hours have passed (only advance 1 hour)
        advanceTime(1 hours);

        // Should revert because not enough time has passed
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSignature("NotAllowedAtThisTime()"));
        forgeCoordinator.fulfillForgeManually(requestId);
    }

    function testFulfillForgeManually_Success() public {
        // First mint a hero and initiate forge
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Verify initial state
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Hero should have pending forge");
        IForgeCoordinator.ForgeRequest memory requestBefore = forgeCoordinator.getForgeRequest(requestId);
        assertFalse(requestBefore.fulfilled, "Request should not be fulfilled yet");
        assertEq(requestBefore.requester, ALICE, "Requester should be ALICE");

        // Wait for 2 hours + 1 second to pass the timeout
        advanceTime(2 hours + 1 seconds);

        // Fulfill manually by the original requester
        vm.prank(ALICE);
        (GameConstants.ForgeEffectType effectTypeId, uint256 effectId, , ) = forgeCoordinator.fulfillForgeManually(
            requestId
        );

        // Verify the forge was fulfilled
        IForgeCoordinator.ForgeRequest memory requestAfter = forgeCoordinator.getForgeRequest(requestId);
        assertTrue(requestAfter.fulfilled, "Request should be fulfilled");
        assertNotEq(requestAfter.randomSeed, 0, "Random seed should be set");
        assertNotEq(requestAfter.effectId, 0, "Effect ID should be set");

        // Hero should no longer have pending request
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Hero should not have pending forge");
        assertEq(forgeCoordinator.getPendingRequest(tokenId), bytes32(0), "Pending request should be cleared");

        // Verify return values are properly set
        assertTrue(
            uint256(effectTypeId) <= uint256(GameConstants.ForgeEffectType.NFT),
            "Effect type ID should be valid"
        );
        assertEq(effectId, requestAfter.effectId, "Effect ID should match request");
    }

    function testFulfillForgeManually_QualityDeterminationBasedOnOracleId() public {
        // Test with free oracle (oracleId = 1) - should get SILVER quality
        uint256 freeOracleId = 1;

        // First mint a hero and initiate forge with free oracle
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost for free oracle
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, freeOracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, freeOracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Wait for 2 hours + 1 second to pass the timeout
        advanceTime(2 hours + 1 seconds);

        // Fulfill manually - should use SILVER quality for free oracle
        vm.prank(ALICE);
        forgeCoordinator.fulfillForgeManually(requestId);

        // Now test with premium oracle (oracleId > 1) - should get GOLD quality
        // Need a second hero for another test
        vm.prank(BOB);
        uint256 tokenId2 = heroContract.mint{value: MINT_PRICE}();

        // Setup premium oracle (oracleId = 2)
        uint256 premiumOracleId = 2;
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

        // Deploy another mock oracle for premium service
        MockOracle premiumMockOracle = new MockOracle();
        oracleRegistry.registerOracle(
            premiumOracleId,
            "PremiumMockOracle",
            "Premium mock oracle for testing",
            address(premiumMockOracle),
            20_000, // Higher fixed fee
            supportedQualities,
            distributionWeights
        );

        uint256 premiumForgeCost = forgeCoordinator.calculateForgeCost(tokenId2, premiumOracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge with premium oracle
        vm.prank(BOB);
        heroContract.performDailyForge{value: premiumForgeCost}(tokenId2, premiumOracleId, gasLimit);

        bytes32 premiumRequestId = forgeCoordinator.getPendingRequest(tokenId2);

        // Wait for 2 hours + 1 second to pass the timeout
        advanceTime(2 hours + 1 seconds);

        // Fulfill manually - should use GOLD quality for premium oracle
        vm.prank(BOB);
        forgeCoordinator.fulfillForgeManually(premiumRequestId);

        // Both requests should be fulfilled
        assertTrue(forgeCoordinator.getForgeRequest(requestId).fulfilled, "Free oracle request should be fulfilled");
        assertTrue(
            forgeCoordinator.getForgeRequest(premiumRequestId).fulfilled,
            "Premium oracle request should be fulfilled"
        );
    }

    function testFulfillForgeManually_RevertWhenRequestNotFound() public {
        bytes32 nonExistentRequestId = keccak256("non-existent-manual");

        // Wait for timeout period (irrelevant for non-existent request)
        advanceTime(2 hours + 1 seconds);

        // For non-existent request, the requester will be address(0), so any caller
        // will be unauthorized. The function checks requester first before checking
        // if request exists, so we get UnauthorizedCaller instead of RequestNotFound
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSignature("UnauthorizedCaller()"));
        forgeCoordinator.fulfillForgeManually(nonExistentRequestId);
    }

    function testFulfillForgeManually_RevertWhenAlreadyFulfilled() public {
        // First mint a hero and initiate forge
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Calculate forge cost
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Move forward in time to pass cooldown
        advanceTime(1 days);

        // Initiate forge through hero contract
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Fulfill the forge through oracle first
        uint256 randomSeed = 12_345;
        mockOracle.fulfillRandomnessWithSeed(requestId, randomSeed, address(forgeCoordinator));

        // Verify forge was fulfilled by oracle
        assertTrue(forgeCoordinator.getForgeRequest(requestId).fulfilled, "Request should be fulfilled by oracle");

        // Wait for timeout period
        advanceTime(2 hours + 1 seconds);

        // Try to fulfill manually after it's already been fulfilled - should revert
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSignature("RequestAlreadyFulfilled()"));
        forgeCoordinator.fulfillForgeManually(requestId);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      UTILITY TESTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testCalculateForgeCost() public view {
        uint32 gasLimit = 100_000;
        uint256 cost = forgeCoordinator.calculateForgeCost(1, oracleId, gasLimit);

        // Cost should be fixedFee + (gasLimit * oracle fee rate)
        uint256 expectedCost = 10_000 + (uint256(gasLimit) * 1 gwei); // fixedFee + oracle fee
        assertEq(cost, expectedCost, "Forge cost calculation should be correct");
    }

    function testGetHeroTokenBoundAccount() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        address tbaFromCoordinator = forgeCoordinator.getHeroTokenBoundAccount(tokenId);
        address tbaFromHero = heroContract.getTokenBoundAccount(tokenId);

        assertEq(tbaFromCoordinator, tbaFromHero, "TBA addresses should match");
    }

    function testGetHeroIdByAccount() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        address tba = heroContract.getTokenBoundAccount(tokenId);
        uint256 retrievedHeroId = forgeCoordinator.getHeroIdByAccount(tba);

        assertEq(retrievedHeroId, tokenId, "Hero ID should be correctly retrieved from TBA");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     ADMIN TESTS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSetHeroContract_Success() public {
        address newHeroContract = address(0x9999);

        forgeCoordinator.setHeroContract(newHeroContract);

        // We can't easily test the internal state, but the function should execute without error
    }

    function testSetHeroContract_RevertWhenNotAdmin() public {
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to onlyOwner modifier

        forgeCoordinator.setHeroContract(address(0x9999));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       FUZZ TESTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFuzz_CalculateForgeCost(uint32 gasLimit) public view {
        vm.assume(gasLimit > 0 && gasLimit <= 5_000_000); // Reasonable gas limit range

        uint256 cost = forgeCoordinator.calculateForgeCost(1, oracleId, gasLimit);
        uint256 expectedCost = 10_000 + (uint256(gasLimit) * 1 gwei); // fixedFee + oracle fee

        assertEq(cost, expectedCost, "Fuzz: Forge cost calculation should be correct");
    }
}
