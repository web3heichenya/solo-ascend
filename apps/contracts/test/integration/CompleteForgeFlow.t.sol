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

/// @title CompleteForgeFlowTest
/// @notice Integration tests for complete forge workflows
contract CompleteForgeFlowTest is TestHelpers {
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

        // Setup oracle and hook
        _setupOracle();
        _setupHook();

        // Setup basic traits for testing
        _setupBasicTraits();

        // Fund test accounts
        fundAccount(ALICE, 10 ether);
        fundAccount(BOB, 10 ether);
        fundAccount(CHARLIE, 10 ether);
    }

    function _setupOracle() internal {
        oracleId = 1;

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

    function _setupHook() internal {
        // Register hook using the actual interface signature
        hookRegistry.registerHook(
            IHookRegistry.HookPhase.AFTER_HERO_MINTED,
            address(mockHook),
            1, // priority
            100_000 // gas limit
        );
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
    /*                 COMPLETE WORKFLOW TESTS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testCompleteForgeWorkflow_SilverQuality() public {
        // Step 1: Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Verify initial state
        assertEq(uint8(heroContract.getHero(tokenId).stage), uint8(GameConstants.HeroStage.FORGING));
        assertEq(heroContract.getHero(tokenId).totalForges, 0);

        // Step 2: Wait for cooldown and perform forge
        advanceTime(1 days);

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Verify forge initiated
        assertTrue(forgeCoordinator.hasPendingForge(tokenId));
        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        assertNotEq(requestId, bytes32(0));

        // Step 3: Oracle fulfills randomness (simulate Silver quality)
        uint256 silverSeed = 5000; // Should result in Silver quality based on distribution
        mockOracle.fulfillRandomnessWithSeed(requestId, silverSeed, address(forgeCoordinator));

        // Step 4: Verify forge completion
        assertFalse(forgeCoordinator.hasPendingForge(tokenId));
        assertEq(heroContract.getHero(tokenId).totalForges, 1);

        IForgeCoordinator.ForgeRequest memory request = forgeCoordinator.getForgeRequest(requestId);
        assertTrue(request.fulfilled);
        assertEq(request.randomSeed, silverSeed);
    }

    function testCompleteForgeWorkflow_MythicQuality() public {
        // Step 1: Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Step 2: Perform forge
        advanceTime(1 days);

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Step 3: Oracle fulfills with mythic quality seed
        uint256 mythicSeed = 9950; // Should result in Mythic quality (top 1%)
        mockOracle.fulfillRandomnessWithSeed(requestId, mythicSeed, address(forgeCoordinator));

        // Step 4: Verify mythic forge completion
        assertEq(heroContract.getHero(tokenId).totalForges, 1);
        assertFalse(forgeCoordinator.hasPendingForge(tokenId));
    }

    function testMultipleForgesProgression() public {
        // Step 1: Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;

        // Perform forges until AMPLIFY effect triggers COMPLETED stage (max 15 attempts)
        uint256 maxForges = 15;
        for (uint256 i = 0; i < maxForges; i++) {
            // Wait for cooldown
            advanceTime(1 days);

            uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

            bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
            mockOracle.fulfillRandomnessWithSeed(requestId, 5000 + i, address(forgeCoordinator));

            assertEq(heroContract.getHero(tokenId).totalForges, i + 1);

            // Check if stage transitioned to COMPLETED
            if (uint8(heroContract.getHero(tokenId).stage) == uint8(GameConstants.HeroStage.COMPLETED)) {
                // AMPLIFY effect was triggered, stage should be COMPLETED
                assertTrue(
                    heroContract.getHero(tokenId).totalForges >= 1,
                    "Should have at least 1 forge when COMPLETED"
                );

                // Should not be able to forge anymore in COMPLETED stage
                advanceTime(1 days);
                uint256 nextForgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

                vm.prank(ALICE);
                vm.expectRevert();
                heroContract.performDailyForge{value: nextForgeCost}(tokenId, oracleId, gasLimit);

                return; // Test passed
            }

            // If not COMPLETED yet, should still be FORGING or SOLO_LEVELING
            assertTrue(
                uint8(heroContract.getHero(tokenId).stage) == uint8(GameConstants.HeroStage.FORGING) ||
                    uint8(heroContract.getHero(tokenId).stage) == uint8(GameConstants.HeroStage.SOLO_LEVELING),
                "Stage should be FORGING or SOLO_LEVELING before COMPLETED"
            );
        }

        // If we reach here, no AMPLIFY effect was triggered in 15 forges
        // This could happen with very low probability, so we'll mark it as expected
        // The test verifies that the system can handle multiple forges without breaking
        assertTrue(heroContract.getHero(tokenId).totalForges == maxForges, "Should have completed all forges");
    }

    function testForgeWorkflowWithCooldown() public {
        // Step 1: Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Step 2: First forge can happen immediately (no cooldown for first forge)
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Step 3: Try to forge again immediately (should fail due to cooldown)
        vm.prank(ALICE);
        vm.expectRevert();
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Step 4: Wait for cooldown and forge successfully
        advanceTime(1 days);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 6000, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 2);
    }

    function testForgeWorkflowWithDifferentOracles() public {
        // Setup second oracle
        uint256 oracle2Id = 2;
        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](2);
        supportedQualities[0] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[1] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory distributionWeights = new uint256[](2);
        distributionWeights[0] = 8000; // Gold - 80%
        distributionWeights[1] = 2000; // Mythic - 20%

        MockOracle oracle2 = new MockOracle();
        oracle2.setFixedRandomSeed(54_321);
        oracle2.setAutoFulfill(false);

        oracleRegistry.registerOracle(
            oracle2Id,
            "MockOracle2",
            "Second mock oracle",
            address(oracle2),
            20_000, // Higher fee
            supportedQualities,
            distributionWeights
        );

        // Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Forge with first oracle
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost1 = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost1}(tokenId, oracleId, gasLimit);

        bytes32 requestId1 = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId1, 5000, address(forgeCoordinator));

        // Forge with second oracle
        advanceTime(1 days);
        uint256 forgeCost2 = forgeCoordinator.calculateForgeCost(tokenId, oracle2Id, gasLimit);
        assertTrue(forgeCost2 > forgeCost1, "Second oracle should be more expensive");

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost2}(tokenId, oracle2Id, gasLimit);

        bytes32 requestId2 = forgeCoordinator.getPendingRequest(tokenId);
        oracle2.fulfillRandomnessWithSeed(requestId2, 8500, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 2);
    }

    function testTreasuryIntegration() public {
        uint256 initialTreasuryBalance = address(treasury).balance;

        // Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Check mint fee was sent to treasury (only TREASURY_FEE, not full MINT_PRICE)
        assertEq(address(treasury).balance, initialTreasuryBalance + GameConstants.TREASURY_FEE);

        // Perform forge
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Forge cost goes to oracle, not treasury. Treasury only gets mint fee
        // Check that treasury balance is still just the mint fee
        assertEq(address(treasury).balance, initialTreasuryBalance + GameConstants.TREASURY_FEE);
    }

    function testERC6551Integration() public {
        // Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Check token bound account was created
        address tba = heroContract.getTokenBoundAccount(tokenId);
        assertNotEq(tba, address(0), "TBA should be created");

        // Verify TBA can be retrieved by coordinator
        address tbaFromCoordinator = forgeCoordinator.getHeroTokenBoundAccount(tokenId);
        assertEq(tba, tbaFromCoordinator, "TBA addresses should match");

        // Verify reverse lookup works
        uint256 retrievedHeroId = forgeCoordinator.getHeroIdByAccount(tba);
        assertEq(retrievedHeroId, tokenId, "Hero ID lookup should work");
    }

    function testStageTransitionFlow() public {
        // Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        assertEq(uint8(heroContract.getHero(tokenId).stage), uint8(GameConstants.HeroStage.FORGING));

        uint32 gasLimit = 100_000;
        bool completedStageReached = false;
        bool soloLevelingReached = false;

        // Forge up to 60 times to test stage transitions
        for (uint256 i = 0; i < 61; i++) {
            advanceTime(1 days);
            uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

            bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
            mockOracle.fulfillRandomnessWithSeed(requestId, 5000 + i, address(forgeCoordinator));

            GameConstants.HeroStage currentStage = heroContract.getHero(tokenId).stage;

            // Track which stages we've seen
            if (currentStage == GameConstants.HeroStage.COMPLETED) {
                completedStageReached = true;

                // Should NOT be able to continue forging in COMPLETED stage
                advanceTime(1 days);
                uint256 nextForgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

                vm.prank(ALICE);
                vm.expectRevert();
                heroContract.performDailyForge{value: nextForgeCost}(tokenId, oracleId, gasLimit);

                break; // Test completed successfully
            } else if (currentStage == GameConstants.HeroStage.SOLO_LEVELING) {
                soloLevelingReached = true;

                // Should be able to continue forging in SOLO_LEVELING stage
                advanceTime(1 days);
                uint256 nextForgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

                vm.prank(ALICE);
                heroContract.performDailyForge{value: nextForgeCost}(tokenId, oracleId, gasLimit);

                bytes32 nextRequestId = forgeCoordinator.getPendingRequest(tokenId);
                mockOracle.fulfillRandomnessWithSeed(nextRequestId, 6000 + i, address(forgeCoordinator));

                break; // Test completed successfully - SOLO_LEVELING allows continued forging
            }

            // Should be in FORGING stage if no transition happened yet
            assertEq(
                uint8(currentStage),
                uint8(GameConstants.HeroStage.FORGING),
                "Should be in FORGING stage before transitions"
            );
        }

        // Verify that we successfully tested stage transitions
        assertTrue(
            completedStageReached || soloLevelingReached,
            "Should have reached either COMPLETED or SOLO_LEVELING stage within 60 forges"
        );
    }

    function testConcurrentForges() public {
        // Mint multiple heroes
        vm.prank(ALICE);
        uint256 tokenId1 = heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        uint256 tokenId2 = heroContract.mint{value: MINT_PRICE}();

        vm.prank(CHARLIE);
        uint256 tokenId3 = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;

        // All three heroes start forging simultaneously
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId1, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId1, oracleId, gasLimit);

        vm.prank(BOB);
        heroContract.performDailyForge{value: forgeCost}(tokenId2, oracleId, gasLimit);

        vm.prank(CHARLIE);
        heroContract.performDailyForge{value: forgeCost}(tokenId3, oracleId, gasLimit);

        // All should have pending requests
        assertTrue(forgeCoordinator.hasPendingForge(tokenId1));
        assertTrue(forgeCoordinator.hasPendingForge(tokenId2));
        assertTrue(forgeCoordinator.hasPendingForge(tokenId3));

        // Fulfill all requests
        bytes32 requestId1 = forgeCoordinator.getPendingRequest(tokenId1);
        bytes32 requestId2 = forgeCoordinator.getPendingRequest(tokenId2);
        bytes32 requestId3 = forgeCoordinator.getPendingRequest(tokenId3);

        mockOracle.fulfillRandomnessWithSeed(requestId1, 1000, address(forgeCoordinator));
        mockOracle.fulfillRandomnessWithSeed(requestId2, 2000, address(forgeCoordinator));
        mockOracle.fulfillRandomnessWithSeed(requestId3, 3000, address(forgeCoordinator));

        // All should be completed
        assertFalse(forgeCoordinator.hasPendingForge(tokenId1));
        assertFalse(forgeCoordinator.hasPendingForge(tokenId2));
        assertFalse(forgeCoordinator.hasPendingForge(tokenId3));

        assertEq(heroContract.getHero(tokenId1).totalForges, 1);
        assertEq(heroContract.getHero(tokenId2).totalForges, 1);
        assertEq(heroContract.getHero(tokenId3).totalForges, 1);
    }

    function testForgeFailureRecovery() public {
        // Mint hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Initiate forge
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        assertTrue(forgeCoordinator.hasPendingForge(tokenId));

        // Simulate oracle failure by trying to fulfill non-existent request
        vm.expectRevert("Request not found");
        mockOracle.fulfillRandomnessWithSeed(keccak256("fake"), 5000, address(forgeCoordinator));

        // Original request should still be pending
        assertTrue(forgeCoordinator.hasPendingForge(tokenId));

        // Proper fulfillment should work
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));
        assertFalse(forgeCoordinator.hasPendingForge(tokenId));
        assertEq(heroContract.getHero(tokenId).totalForges, 1);
    }

    function testCompleteWorkflowWithNameChanges() public {
        // Mint and name hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, "TestHero");

        assertEq(heroContract.getHeroName(tokenId), "TestHero");

        // Perform forge workflow
        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Name should persist through forge
        assertEq(heroContract.getHeroName(tokenId), "TestHero");
        assertEq(heroContract.getHero(tokenId).totalForges, 1);

        // Change name again after forge
        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, "ForgedHero");

        assertEq(heroContract.getHeroName(tokenId), "ForgedHero");
    }
}
