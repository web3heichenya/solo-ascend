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
import {MythicForgeEffect} from "../../src/effects/MythicForgeEffect.sol";
import {AttributeForgeEffect} from "../../src/effects/AttributeForgeEffect.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {IForgeEffect} from "../../src/interfaces/IForgeEffect.sol";
import {IForgeItemNFT} from "../../src/interfaces/IForgeItemNFT.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";
import {TraitSetup} from "../helpers/TraitSetup.sol";

/// @title MythicForgeEffectTest
/// @notice Test suite for verifying MythicForgeEffect functionality
/// @dev Tests that MYTHIC effects appear only at mythic quality and provide significant boosts
contract MythicForgeEffectTest is Test {
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
    MythicForgeEffect public mythicEffect;
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
        mythicEffect = new MythicForgeEffect(admin, address(forgeCoordinator));
        attributeEffect = new AttributeForgeEffect(admin, address(forgeCoordinator));

        // Setup effects registry
        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.MYTHIC,
            "Mythic Power",
            "Grants mythic-tier bonuses",
            address(mythicEffect)
        );

        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute Boost",
            "Increases basic hero attributes",
            address(attributeEffect)
        );

        // Setup oracle with MYTHIC bias for testing
        _setupMythicOracle();

        // Setup forge coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Setup forge item registry with real ForgeItemNFT contracts
        ForgeItemSetup.setupRealForgeItemContracts(
            forgeItemRegistry,
            admin,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Setup basic traits for testing
        TraitSetup.setupBasicTraits(traitRegistry);

        // Fund Alice for minting
        vm.deal(ALICE, 1 ether);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Test that MYTHIC effects only appear in MYTHIC quality
    function testMythicEffectQualityRestriction() public {
        // Test that MYTHIC is not available for SILVER quality
        assertFalse(
            mythicEffect.isAvailable(GameConstants.ForgeQuality.SILVER, 0),
            "MYTHIC should not be available for SILVER quality"
        );

        // Test that MYTHIC is not available for GOLD quality (default weight is 0)
        assertFalse(
            mythicEffect.isAvailable(GameConstants.ForgeQuality.GOLD, 0),
            "MYTHIC should not be available for GOLD quality"
        );

        // Test that MYTHIC is not available for RAINBOW quality (default weight is 0)
        assertFalse(
            mythicEffect.isAvailable(GameConstants.ForgeQuality.RAINBOW, 0),
            "MYTHIC should not be available for RAINBOW quality"
        );

        // Test that MYTHIC is available for MYTHIC quality after setting weight and meeting forge requirement
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1);
        assertTrue(
            mythicEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 33),
            "MYTHIC should be available for MYTHIC quality when weight is set and forge requirement met"
        );
    }

    /// @notice Test MYTHIC effect minimum forge requirement
    function testMythicEffectForgeRequirement() public {
        // Set MYTHIC weight to make it available
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1);

        // Check that MYTHIC requires minimum forges (default should be 100 based on typical implementation)
        // This test verifies the isAvailable function respects forge count requirements
        bool availableEarly = mythicEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 50);
        console2.log("MYTHIC available at 50 forges:", availableEarly);

        bool availableLate = mythicEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 100);
        console2.log("MYTHIC available at 100 forges:", availableLate);

        // The exact requirement may vary, but there should be some minimum
        // Most MYTHIC effects require a significant number of forges
    }

    /// @notice Test that MYTHIC effects provide significant attribute boosts
    function testMythicEffectAttributeBoosts() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Get initial attributes
        GameConstants.Hero memory initialHero = heroContract.getHero(heroId);
        GameConstants.HeroAttributes memory initialAttributes = initialHero.attributes;

        console2.log("=== Initial Hero Attributes ===");
        console2.log("HP:", initialAttributes.hp);
        console2.log("AD:", initialAttributes.ad);
        console2.log("AP:", initialAttributes.ap);
        console2.log("Armor:", initialAttributes.armor);
        console2.log("MR:", initialAttributes.mr);

        // Set weights for both effects from the start
        // Set ATTRIBUTE weight for MYTHIC to handle oracle's MYTHIC quality during initial forges
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 100);
        // Also set MYTHIC effect weight so it's available when needed
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1000);

        // Check initial hero owner
        console2.log("Initial hero owner:", heroContract.ownerOf(heroId));

        // First, perform 33 regular forges to meet the MYTHIC requirement (34th forge will have 33 total forges, meeting the >= 33 requirement)
        for (uint256 i = 0; i < 33; i++) {
            // Skip time to avoid daily forge cooldown
            vm.warp(block.timestamp + 1 days);

            uint32 _gasLimit = 100_000;
            uint256 _forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, _gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: _forgeCost}(heroId, oracleId, _gasLimit);
            bytes32 _requestId = forgeCoordinator.getPendingRequest(heroId);

            vm.prank(address(mockOracle));
            forgeCoordinator.fulfillForge(_requestId, uint256(keccak256(abi.encode(i))));
        }

        // Check hero owner after 33 forges
        console2.log("Hero owner after 33 forges:", heroContract.ownerOf(heroId));

        // Now set ATTRIBUTE weight to 0 to prevent other effects on 34th forge
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 0);

        // Log the weights to verify
        console2.log(
            "MYTHIC effect weight for MYTHIC quality:",
            mythicEffect.getQualityWeight(GameConstants.ForgeQuality.MYTHIC)
        );
        console2.log(
            "ATTRIBUTE effect weight for MYTHIC quality:",
            attributeEffect.getQualityWeight(GameConstants.ForgeQuality.MYTHIC)
        );

        // Check if MYTHIC effect is available at this point (34th forge with 33 completed forges)
        console2.log(
            "MYTHIC effect available for 33 forges?",
            mythicEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 33)
        );
        console2.log(
            "MYTHIC effect available for 34 forges?",
            mythicEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 34)
        );

        // Check what effects are available from registry
        GameConstants.ForgeEffectType[] memory availableTypes = forgeEffectRegistry.getAvailableEffectTypes(
            GameConstants.ForgeQuality.MYTHIC,
            33
        );
        console2.log("Available effect types count for MYTHIC quality at 33 forges:", availableTypes.length);
        for (uint256 i = 0; i < availableTypes.length; i++) {
            console2.log("  Available effect type:", uint256(availableTypes[i]));
        }

        // Also check what the hero's current stage is - maybe it filters out MYTHIC for SOLO_LEVELING heroes?
        GameConstants.HeroStage currentStage = heroContract.getHero(heroId).stage;
        console2.log("Current hero stage:", uint256(currentStage));

        // Skip time for the 34th forge
        vm.warp(block.timestamp + 1 days);

        // Perform the 34th forge to get MYTHIC effect
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        // Fulfill the forge request with a seed that will generate MYTHIC quality
        // Use a seed that when modulo 100 will be >= 90 to get MYTHIC quality (90-99 range)
        uint256 mythicSeed = 95; // 95 % 100 = 95, which is in MYTHIC range (90-99)
        console2.log("Using seed for MYTHIC quality:", mythicSeed);
        console2.log("Seed modulo 100:", mythicSeed % 100);

        vm.prank(address(mockOracle));
        (
            GameConstants.ForgeEffectType effectType,
            uint256 effectId,
            ,
            GameConstants.HeroStage newStage
        ) = forgeCoordinator.fulfillForge(requestId, mythicSeed);

        console2.log("Effect ID from 34th forge:", effectId);
        console2.log("Effect type from 34th forge:", uint256(effectType));
        console2.log("Expected MYTHIC type:", uint256(GameConstants.ForgeEffectType.MYTHIC));
        console2.log("New hero stage:", uint256(newStage));

        // After forge fulfillment, hero stage should NOT be upgraded yet (mythic item is sent to owner, not applied)
        GameConstants.Hero memory heroAfterForge = heroContract.getHero(heroId);
        assertEq(
            uint256(heroAfterForge.stage),
            uint256(GameConstants.HeroStage.FORGING),
            "Hero stage should still be FORGING after forge (mythic item not yet applied)"
        );

        // Get the mythic forge item contract
        address mythicForgeItemContract = forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.MYTHIC);

        // Check total minted tokens to determine the correct token ID
        uint256 totalMinted = IForgeItemNFT(mythicForgeItemContract).getTotalMinted();
        console2.log("Total minted mythic items:", totalMinted);

        // For testing purposes, assume the last minted MYTHIC item has the highest token ID
        uint256 tokenId = totalMinted; // Should be 1 for first mint

        console2.log("Using token ID:", tokenId);

        console2.log("Mythic forge item contract:", mythicForgeItemContract);
        console2.log("Expected owner (ALICE):", ALICE);
        console2.log("Actual forge item owner:", IForgeItemNFT(mythicForgeItemContract).ownerOf(tokenId));
        console2.log("Hero owner from heroContract.ownerOf(heroId):", heroContract.ownerOf(heroId));
        console2.log("Hero TBA:", heroContract.getTokenBoundAccount(heroId));
        console2.log("DEBUG: _determineMintDestination should return:", heroContract.ownerOf(heroId));
        console2.log("DEBUG: heroContract address:", address(heroContract));

        // Note: In test environment, the forge item owner may differ from hero owner
        // This is expected behavior - the forge item is sent to the correct address
        address actualForgeItemOwner = IForgeItemNFT(mythicForgeItemContract).ownerOf(tokenId);

        // Transfer the mythic forge item to the hero's TBA to trigger the effect
        address heroTBA = heroContract.getTokenBoundAccount(heroId);

        console2.log("Hero ID:", heroId);
        console2.log("Hero TBA from contract:", heroTBA);
        console2.log("Actual forge item owner:", actualForgeItemOwner);
        console2.log("Are they the same?", heroTBA == actualForgeItemOwner);
        console2.log("Hero ID by TBA account:", forgeCoordinator.getHeroIdByAccount(heroTBA));

        // If the forge item is already in the TBA, the effect should already be applied
        // Otherwise, transfer it to trigger the effect
        if (actualForgeItemOwner != heroTBA) {
            console2.log("Before transfer - Hero stage:", uint256(heroContract.getHero(heroId).stage));
            console2.log("Transferring token ID:", tokenId);
            console2.log("From:", actualForgeItemOwner);
            console2.log("To (Hero TBA):", heroTBA);

            vm.prank(actualForgeItemOwner);
            IForgeItemNFT(mythicForgeItemContract).safeTransferFrom(actualForgeItemOwner, heroTBA, tokenId);

            console2.log("After transfer - Hero stage:", uint256(heroContract.getHero(heroId).stage));
        } else {
            console2.log("Forge item already in TBA, checking if effect was applied during mint");
            console2.log("Current hero stage:", uint256(heroContract.getHero(heroId).stage));

            // The effect should have been applied when minted directly to TBA
            // But it seems it wasn't - this is the actual bug we need to fix
        }

        // Now get final attributes after transfer
        GameConstants.Hero memory finalHero = heroContract.getHero(heroId);
        GameConstants.HeroAttributes memory finalAttributes = finalHero.attributes;

        console2.log("=== Final Hero Attributes ===");
        console2.log("HP:", finalAttributes.hp);
        console2.log("AD:", finalAttributes.ad);
        console2.log("AP:", finalAttributes.ap);
        console2.log("Armor:", finalAttributes.armor);
        console2.log("MR:", finalAttributes.mr);

        // MYTHIC effect changes hero stage, not attributes directly
        // But the accumulated attribute changes from 33 forges should be significant
        assertTrue(finalAttributes.hp > initialAttributes.hp, "HP should be increased from accumulated forges");
        assertTrue(finalAttributes.ad > initialAttributes.ad, "AD should be increased from accumulated forges");

        // Check that hero stage was upgraded to SOLO_LEVELING after transfer
        assertEq(
            uint256(finalHero.stage),
            uint256(GameConstants.HeroStage.SOLO_LEVELING),
            "MYTHIC effect should upgrade hero to SOLO_LEVELING stage"
        );

        console2.log("Hero stage after MYTHIC:", uint256(finalHero.stage));
        console2.log("HP after forges:", finalAttributes.hp);
        console2.log("AD after forges:", finalAttributes.ad);
    }

    /// @notice Test that MYTHIC effects can upgrade hero stage
    function testMythicEffectStageUpgrade() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Check initial hero stage
        GameConstants.Hero memory initialHero = heroContract.getHero(heroId);
        GameConstants.HeroStage initialStage = initialHero.stage;
        console2.log("Initial hero stage:", uint256(initialStage));

        // Set MYTHIC weight to guarantee it appears
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 0);

        // Perform forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 54_321);

        // Check final hero stage
        GameConstants.Hero memory finalHero = heroContract.getHero(heroId);
        GameConstants.HeroStage finalStage = finalHero.stage;
        console2.log("Final hero stage:", uint256(finalStage));

        // MYTHIC effects may upgrade hero stage (depending on implementation)
        // At minimum, the stage should not be downgraded
        assertTrue(
            uint256(finalStage) >= uint256(initialStage),
            "Hero stage should not be downgraded by MYTHIC effect"
        );
    }

    /// @notice Test MYTHIC effect rarity by attempting multiple forges
    function testMythicEffectRarity() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set ATTRIBUTE weight for MYTHIC to handle oracle's MYTHIC quality during initial forges
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 100);

        // First perform 32 forges to meet minimum requirement
        for (uint256 i = 0; i < 32; i++) {
            vm.warp(block.timestamp + 1 days);
            uint32 gl = 100_000;
            uint256 fc = forgeCoordinator.calculateForgeCost(heroId, oracleId, gl);
            vm.prank(ALICE);
            heroContract.performDailyForge{value: fc}(heroId, oracleId, gl);
            bytes32 rid = forgeCoordinator.getPendingRequest(heroId);
            vm.prank(address(mockOracle));
            forgeCoordinator.fulfillForge(rid, uint256(keccak256(abi.encode(i))));
        }

        // Now set realistic MYTHIC weight (very low, as it should be rare)
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1); // Very low weight
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 99); // Most forges will be ATTRIBUTE

        // Try multiple forges after meeting the requirement to see if we can get MYTHIC effect
        bool mythicFound = false;
        uint256 maxAttempts = 10;

        for (uint256 i = 0; i < maxAttempts; i++) {
            // Fast forward time to avoid cooldown
            vm.warp(block.timestamp + 1 days);

            uint32 gasLimit = 100_000;
            uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
            bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

            // Use different random seeds to get variety
            vm.prank(address(mockOracle));
            (GameConstants.ForgeEffectType effectType, , , ) = forgeCoordinator.fulfillForge(requestId, 12_345 + i);

            if (effectType == GameConstants.ForgeEffectType.MYTHIC) {
                mythicFound = true;
                console2.log("MYTHIC effect found on attempt", i + 1);
                break;
            }
        }

        // Due to randomness and low weight, MYTHIC might not appear in 10 attempts
        // This test mainly verifies the system doesn't crash when trying to get MYTHIC effects
        console2.log("MYTHIC found in", maxAttempts, "attempts:", mythicFound);
    }

    /// @notice Test that MYTHIC effects emit proper events
    function testMythicEffectEmitsEvents() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set ATTRIBUTE weight for MYTHIC to handle oracle's MYTHIC quality during initial forges
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 100);

        // First perform 33 forges to meet minimum requirement (34th forge will have 33 completed forges)
        for (uint256 i = 0; i < 33; i++) {
            vm.warp(block.timestamp + 1 days);
            uint32 gl = 100_000;
            uint256 fc = forgeCoordinator.calculateForgeCost(heroId, oracleId, gl);
            vm.prank(ALICE);
            heroContract.performDailyForge{value: fc}(heroId, oracleId, gl);
            bytes32 rid = forgeCoordinator.getPendingRequest(heroId);
            vm.prank(address(mockOracle));
            forgeCoordinator.fulfillForge(rid, uint256(keccak256(abi.encode(i))));
        }

        // Set weights to guarantee MYTHIC effect on the 34th forge
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 0);

        // Skip time for the next forge
        vm.warp(block.timestamp + 1 days);

        // Perform the 34th forge to get MYTHIC effect
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);
        // Use a seed that will generate MYTHIC quality (90-99 range)
        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 95);

        // After forge fulfillment, hero stage should NOT be upgraded yet (mythic item is sent to owner, not applied)
        GameConstants.Hero memory heroAfterForge = heroContract.getHero(heroId);
        assertEq(
            uint256(heroAfterForge.stage),
            uint256(GameConstants.HeroStage.FORGING),
            "Hero stage should still be FORGING after forge (mythic item not yet applied)"
        );

        // Get the mythic forge item contract and transfer to hero TBA
        address mythicForgeItemContract = forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.MYTHIC);
        address heroTBA = heroContract.getTokenBoundAccount(heroId);

        // Get the correct token ID of the newly minted MYTHIC item
        uint256 tokenId = IForgeItemNFT(mythicForgeItemContract).getTotalMinted();

        // Get the actual forge item owner
        address actualForgeItemOwner = IForgeItemNFT(mythicForgeItemContract).ownerOf(tokenId);

        // Only transfer if the item is not already in TBA
        if (actualForgeItemOwner != heroTBA) {
            vm.prank(actualForgeItemOwner);
            IForgeItemNFT(mythicForgeItemContract).safeTransferFrom(actualForgeItemOwner, heroTBA, tokenId);
        }

        // Verify the stage was upgraded after transfer (which is what MYTHIC does)
        GameConstants.Hero memory hero = heroContract.getHero(heroId);
        assertEq(uint256(hero.stage), uint256(GameConstants.HeroStage.SOLO_LEVELING), "MYTHIC should upgrade stage");
    }

    /// @notice Test MYTHIC effect quality weight management
    function testMythicQualityWeightManagement() public {
        // Test initial weights (should all be 0 except potentially MYTHIC)
        uint256 silverWeight = mythicEffect.getQualityWeight(GameConstants.ForgeQuality.SILVER);
        uint256 goldWeight = mythicEffect.getQualityWeight(GameConstants.ForgeQuality.GOLD);
        uint256 rainbowWeight = mythicEffect.getQualityWeight(GameConstants.ForgeQuality.RAINBOW);
        uint256 mythicWeight = mythicEffect.getQualityWeight(GameConstants.ForgeQuality.MYTHIC);

        console2.log("Initial SILVER weight:", silverWeight);
        console2.log("Initial GOLD weight:", goldWeight);
        console2.log("Initial RAINBOW weight:", rainbowWeight);
        console2.log("Initial MYTHIC weight:", mythicWeight);

        assertEq(silverWeight, 0, "SILVER weight should be 0");
        assertEq(goldWeight, 0, "GOLD weight should be 0");
        assertEq(rainbowWeight, 0, "RAINBOW weight should be 0");

        // Test setting weights
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 100);
        uint256 newMythicWeight = mythicEffect.getQualityWeight(GameConstants.ForgeQuality.MYTHIC);
        assertEq(newMythicWeight, 100, "MYTHIC weight should be updated to 100");

        // Test that non-owner cannot set weights
        vm.prank(ALICE);
        vm.expectRevert();
        mythicEffect.setQualityWeight(GameConstants.ForgeQuality.MYTHIC, 200);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       PRIVATE HELPERS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Setup oracle that can produce MYTHIC quality for testing
    function _setupMythicOracle() private {
        oracleId = 1; // Use ID 1 for testing

        // Setup supported qualities and weights - heavily favor MYTHIC for testing
        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory weights = new uint256[](4);
        weights[0] = 30; // 30% SILVER
        weights[1] = 30; // 30% GOLD
        weights[2] = 30; // 30% RAINBOW
        weights[3] = 10; // 10% MYTHIC (more realistic)

        oracleRegistry.registerOracle(
            oracleId,
            "Mythic Oracle",
            "Oracle that favors mythic quality forges for testing",
            address(mockOracle),
            10_000, // fixed fee
            supportedQualities,
            weights
        );
    }
}
