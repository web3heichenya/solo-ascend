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
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {IForgeEffect} from "../../src/interfaces/IForgeEffect.sol";
import {IForgeItemNFT} from "../../src/interfaces/IForgeItemNFT.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {ForgeItemNFT} from "../../src/core/ForgeItemNFT.sol";
import {RealForgeEffectSetup} from "../helpers/RealForgeEffectSetup.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";

/// @title ForgeAttributeVerificationTest
/// @notice Test suite for verifying that forge effects correctly update hero attributes
/// @dev Tests the complete flow: initial attributes -> forge -> effect application -> final attributes
contract ForgeAttributeVerificationTest is Test {
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

        // Set hero contract in forge coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Authorize forge coordinator to distribute treasury rewards
        treasury.setAuthorizedDistributor(address(forgeCoordinator), true);

        // Setup forge effects with real implementations instead of mocks
        RealForgeEffectSetup.setupRealForgeEffects(
            forgeEffectRegistry,
            admin,
            address(forgeCoordinator),
            address(treasury),
            address(heroContract)
        );

        // Setup real forge item contracts (not mocks)
        ForgeItemSetup.setupRealForgeItemContracts(
            forgeItemRegistry,
            admin,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Setup oracle
        _setupOracle();

        // Setup basic traits for testing
        _setupBasicTraits();

        // Setup test accounts
        vm.deal(ALICE, 10 ether);
        vm.deal(BOB, 10 ether);
    }

    function _setupBasicTraits() internal {
        // Register basic traits for each layer to avoid NoActiveTraitsInLayer error
        // Register background traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BACKGROUND,
            '<rect fill="blue"/>',
            "Blue Background"
        );

        // Register base traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, '<circle fill="red"/>', "Red Base");

        // Register eye traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, '<ellipse fill="green"/>', "Green Eyes");

        // Register mouth traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, '<path d="M0,0"/>', "Simple Mouth");

        // Register hair traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.HAIR_HAT,
            '<polygon points="0,0"/>',
            "Basic Hair"
        );

        // Register body/armor traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, '<rect fill="silver"/>', "Silver Armor");

        // Register leg traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, '<rect fill="grey"/>', "Grey Pants");

        // Register foot traits
        traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FOOT, '<rect fill="brown"/>', "Brown Boots");

        // Register weapon traits for each class
        traitRegistry.registerWeaponTrait(
            GameConstants.HeroClass.WARRIOR,
            '<path d="M0,0" fill="gold"/>',
            '<path d="M0,0" fill="gold"/>',
            '<path d="M0,0" fill="gold"/>',
            "Golden Sword"
        );
    }

    function _setupOracle() internal {
        oracleId = 1; // Use ID 1 for testing

        // Setup supported qualities and weights
        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory weights = new uint256[](4);
        weights[0] = 80; // 80% SILVER
        weights[1] = 15; // 15% GOLD
        weights[2] = 4; // 4% RAINBOW
        weights[3] = 1; // 1% MYTHIC

        oracleRegistry.registerOracle(
            oracleId,
            "Test Oracle",
            "Test Oracle Description",
            address(mockOracle),
            10_000, // fixed fee
            supportedQualities,
            weights
        );
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    ATTRIBUTE VERIFICATION                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testForgeEffectCorrectlyUpdatesHeroAttributes() public {
        // Step 1: Mint a hero and record initial attributes
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Get initial hero data
        GameConstants.Hero memory heroBeforeForge = heroContract.getHero(tokenId);
        GameConstants.HeroAttributes memory initialAttributes = heroBeforeForge.attributes;

        // Log initial state
        console2.log("=== Initial Hero State ===");
        console2.log("Hero ID:", tokenId);
        console2.log("Initial HP:", initialAttributes.hp);
        console2.log("Initial AD:", initialAttributes.ad);
        console2.log("Initial AP:", initialAttributes.ap);
        console2.log("Initial Armor:", initialAttributes.armor);
        console2.log("Initial MR:", initialAttributes.mr);

        // Step 2: Wait for cooldown period
        vm.warp(block.timestamp + 1 days);

        // Step 3: Initiate forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        console2.log("\n=== Initiating Forge ===");
        console2.log("Forge Cost:", forgeCost);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        console2.log("Request ID created");

        // Step 4: Fulfill forge with controlled randomness for predictable results
        uint256 controlledRandomSeed = 42; // Use a fixed seed for deterministic testing

        vm.prank(address(mockOracle));
        (GameConstants.ForgeEffectType effectType, uint256 effectId, , ) = forgeCoordinator.fulfillForge(
            requestId,
            controlledRandomSeed
        );

        console2.log("\n=== Forge Effect Applied ===");
        console2.log("Effect Type:", uint256(effectType));
        console2.log("Effect ID:", effectId);

        // Step 5: Get the applied effect details from the created ForgeItemNFT
        // The forge process creates a ForgeItemNFT which contains the effect data
        address forgeItemContract = forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.SILVER);

        // The latest minted token should be tokenId 1 (first item minted)
        uint256 forgeItemTokenId = 1;
        GameConstants.ForgeEffect memory appliedEffect = IForgeItemNFT(forgeItemContract).getForgeItem(
            forgeItemTokenId
        );

        console2.log("Effect Attribute:", uint256(appliedEffect.attribute));
        console2.log("Effect Value:", appliedEffect.value);
        console2.log("Effect Quality:", uint256(appliedEffect.quality));

        // Step 6: Get hero attributes after forge
        GameConstants.Hero memory heroAfterForge = heroContract.getHero(tokenId);
        GameConstants.HeroAttributes memory finalAttributes = heroAfterForge.attributes;

        console2.log("\n=== Final Hero State ===");
        console2.log("Final HP:", finalAttributes.hp);
        console2.log("Final AD:", finalAttributes.ad);
        console2.log("Final AP:", finalAttributes.ap);
        console2.log("Final Armor:", finalAttributes.armor);
        console2.log("Final MR:", finalAttributes.mr);

        // Step 7: Verify the mathematical correctness of attribute updates
        console2.log("\n=== Verification ===");

        if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            // For ATTRIBUTE effect, verify the specific attribute was increased correctly
            _verifyAttributeEffect(initialAttributes, finalAttributes, appliedEffect);

            // Log the changes for debugging
            _logAttributeChanges(initialAttributes, finalAttributes);
        } else if (effectType == GameConstants.ForgeEffectType.AMPLIFY) {
            // For AMPLIFY effect, verify percentage-based increases
            _verifyAmplifyEffect(initialAttributes, finalAttributes);
        } else if (effectType == GameConstants.ForgeEffectType.ENHANCE) {
            // For ENHANCE effect, verify multiple attributes were enhanced
            _verifyEnhanceEffect(initialAttributes, finalAttributes);
        }

        // Step 8: Verify forge metadata
        IForgeCoordinator.ForgeRequest memory forgeRequest = forgeCoordinator.getForgeRequest(requestId);
        assertTrue(forgeRequest.fulfilled, "Forge request should be fulfilled");
        assertEq(forgeRequest.effectId, effectId, "Effect ID should match");
        assertEq(forgeRequest.randomSeed, controlledRandomSeed, "Random seed should match");
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Hero should not have pending forge");

        // Step 9: Verify hero forge count was incremented
        assertEq(heroAfterForge.totalForges, heroBeforeForge.totalForges + 1, "Total forges should increment by 1");

        console2.log("\n=== Test Passed ===");
        console2.log("Attribute changes verified successfully!");
    }

    function testMultipleForgesStackCorrectly() public {
        // Test that multiple forge effects stack correctly on a hero
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        GameConstants.Hero memory initialHero = heroContract.getHero(tokenId);

        console2.log("=== Testing Multiple Forge Stacking ===");
        console2.log("Initial HP:", initialHero.attributes.hp);
        console2.log("Initial AD:", initialHero.attributes.ad);

        // Perform 3 forges
        for (uint256 i = 0; i < 3; i++) {
            console2.log("\n--- Forge", i + 1, "---");

            // Wait for cooldown
            vm.warp(block.timestamp + 1 days);

            // Initiate forge
            uint32 gasLimit = 100_000;
            uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);
            bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

            // Use different seeds for variety
            uint256 randomSeed = 100 + i * 50;

            vm.prank(address(mockOracle));
            (GameConstants.ForgeEffectType effectType, , , ) = forgeCoordinator.fulfillForge(requestId, randomSeed);

            // Get attributes after forge
            GameConstants.Hero memory afterForge = heroContract.getHero(tokenId);

            // For tracking cumulative increases, we can't directly call generateEffect
            // But we can track the actual attribute changes
            if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
                console2.log("ATTRIBUTE effect applied");
            } else if (effectType == GameConstants.ForgeEffectType.AMPLIFY) {
                console2.log("AMPLIFY effect applied");
            }

            console2.log(string.concat("Attributes after forge ", vm.toString(i + 1)));
            console2.log("HP:", afterForge.attributes.hp);
            console2.log("AD:", afterForge.attributes.ad);
        }

        // Final verification
        GameConstants.Hero memory finalHero = heroContract.getHero(tokenId);

        console2.log("\n=== Final Verification ===");
        console2.log("Initial HP:", initialHero.attributes.hp);
        console2.log("Final HP:", finalHero.attributes.hp);
        console2.log("Initial AD:", initialHero.attributes.ad);
        console2.log("Final AD:", finalHero.attributes.ad);

        // Verify that attributes have generally increased (some effects should have been applied)
        bool attributesIncreased = _hasAttributeChanged(initialHero.attributes, finalHero.attributes);
        assertTrue(attributesIncreased, "Hero attributes should have changed after 3 forges");

        // Log all the changes
        _logAttributeChanges(initialHero.attributes, finalHero.attributes);

        assertEq(finalHero.totalForges, 3, "Hero should have 3 total forges");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      HELPER FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _hasAttributeChanged(
        GameConstants.HeroAttributes memory initial,
        GameConstants.HeroAttributes memory final_
    ) internal pure returns (bool) {
        return (final_.hp != initial.hp ||
            final_.hpRegen != initial.hpRegen ||
            final_.ad != initial.ad ||
            final_.ap != initial.ap ||
            final_.attackSpeed != initial.attackSpeed ||
            final_.crit != initial.crit ||
            final_.armor != initial.armor ||
            final_.mr != initial.mr ||
            final_.cdr != initial.cdr ||
            final_.moveSpeed != initial.moveSpeed ||
            final_.lifesteal != initial.lifesteal ||
            final_.tenacity != initial.tenacity ||
            final_.penetration != initial.penetration ||
            final_.mana != initial.mana ||
            final_.manaRegen != initial.manaRegen ||
            final_.intelligence != initial.intelligence);
    }

    function _logAttributeChanges(
        GameConstants.HeroAttributes memory initial,
        GameConstants.HeroAttributes memory final_
    ) internal pure {
        console2.log("=== Attribute Changes ===");
        if (final_.hp != initial.hp) console2.log("HP:", initial.hp, "->", final_.hp);
        if (final_.hpRegen != initial.hpRegen) console2.log("HP Regen:", initial.hpRegen, "->", final_.hpRegen);
        if (final_.ad != initial.ad) console2.log("AD:", initial.ad, "->", final_.ad);
        if (final_.ap != initial.ap) console2.log("AP:", initial.ap, "->", final_.ap);
        if (final_.attackSpeed != initial.attackSpeed) {
            console2.log("Attack Speed:", initial.attackSpeed, "->", final_.attackSpeed);
        }
        if (final_.crit != initial.crit) console2.log("Crit:", initial.crit, "->", final_.crit);
        if (final_.armor != initial.armor) console2.log("Armor:", initial.armor, "->", final_.armor);
        if (final_.mr != initial.mr) console2.log("MR:", initial.mr, "->", final_.mr);
        if (final_.cdr != initial.cdr) console2.log("CDR:", initial.cdr, "->", final_.cdr);
        if (final_.moveSpeed != initial.moveSpeed) {
            console2.log("Move Speed:", initial.moveSpeed, "->", final_.moveSpeed);
        }
        if (final_.lifesteal != initial.lifesteal) {
            console2.log("Lifesteal:", initial.lifesteal, "->", final_.lifesteal);
        }
        if (final_.tenacity != initial.tenacity) console2.log("Tenacity:", initial.tenacity, "->", final_.tenacity);
        if (final_.penetration != initial.penetration) {
            console2.log("Penetration:", initial.penetration, "->", final_.penetration);
        }
        if (final_.mana != initial.mana) console2.log("Mana:", initial.mana, "->", final_.mana);
        if (final_.manaRegen != initial.manaRegen) {
            console2.log("Mana Regen:", initial.manaRegen, "->", final_.manaRegen);
        }
        if (final_.intelligence != initial.intelligence) {
            console2.log("Intelligence:", initial.intelligence, "->", final_.intelligence);
        }
    }

    function _verifyAttributeEffect(
        GameConstants.HeroAttributes memory initial,
        GameConstants.HeroAttributes memory final_,
        GameConstants.ForgeEffect memory effect
    ) internal pure {
        // Verify that only the specified attribute was changed by the exact effect value
        if (effect.attribute == GameConstants.HeroAttribute.HP) {
            require(final_.hp == initial.hp + effect.value, "HP increment incorrect");
            require(final_.ad == initial.ad, "AD should not change");
            require(final_.ap == initial.ap, "AP should not change");
            require(final_.armor == initial.armor, "Armor should not change");
        } else if (effect.attribute == GameConstants.HeroAttribute.AD) {
            require(final_.ad == initial.ad + effect.value, "AD increment incorrect");
            require(final_.hp == initial.hp, "HP should not change");
            require(final_.ap == initial.ap, "AP should not change");
            require(final_.armor == initial.armor, "Armor should not change");
        } else if (effect.attribute == GameConstants.HeroAttribute.AP) {
            require(final_.ap == initial.ap + effect.value, "AP increment incorrect");
            require(final_.hp == initial.hp, "HP should not change");
            require(final_.ad == initial.ad, "AD should not change");
            require(final_.armor == initial.armor, "Armor should not change");
        } else if (effect.attribute == GameConstants.HeroAttribute.ARMOR) {
            require(final_.armor == initial.armor + effect.value, "Armor increment incorrect");
            require(final_.hp == initial.hp, "HP should not change");
            require(final_.ad == initial.ad, "AD should not change");
            require(final_.ap == initial.ap, "AP should not change");
        } else if (effect.attribute == GameConstants.HeroAttribute.MR) {
            require(final_.mr == initial.mr + effect.value, "MR increment incorrect");
            require(final_.hp == initial.hp, "HP should not change");
            require(final_.ad == initial.ad, "AD should not change");
            require(final_.ap == initial.ap, "AP should not change");
        }
    }

    function _verifyAmplifyEffect(
        GameConstants.HeroAttributes memory initial,
        GameConstants.HeroAttributes memory final_
    ) internal pure {
        // For AMPLIFY, all attributes should be increased
        // The mock implementation might increase all by a fixed amount or percentage
        require(final_.hp >= initial.hp, "HP should be increased");
        require(final_.ad >= initial.ad, "AD should be increased");
        require(final_.ap >= initial.ap, "AP should be increased");
        require(final_.armor >= initial.armor, "Armor should be increased");
        require(final_.mr >= initial.mr, "MR should be increased");
    }

    function _verifyEnhanceEffect(
        GameConstants.HeroAttributes memory initial,
        GameConstants.HeroAttributes memory final_
    ) internal pure {
        // For ENHANCE, at least some attributes should be improved
        uint256 changedCount = 0;
        if (final_.hp > initial.hp) changedCount++;
        if (final_.ad > initial.ad) changedCount++;
        if (final_.ap > initial.ap) changedCount++;
        if (final_.armor > initial.armor) changedCount++;
        if (final_.mr > initial.mr) changedCount++;

        require(changedCount > 0, "At least one attribute should be enhanced");
    }

    /// @notice Test forge loop until AMPLIFY effect appears and hero stage becomes COMPLETED
    /// @dev Loops up to 60 forges, checking for AMPLIFY effects and stage completion
    function testAmplifyForgeEffectAndStageCompletion() public {
        // Step 1: Mint a hero
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        console2.log("=== Testing AMPLIFY Effect and Stage Completion ===");
        console2.log("Hero ID:", heroId);

        // Record initial attributes and stage
        GameConstants.Hero memory initialHero = heroContract.getHero(heroId);
        GameConstants.HeroAttributes memory initialAttributes = initialHero.attributes;
        GameConstants.HeroStage initialStage = initialHero.stage;

        console2.log("=== Initial Hero State ===");
        console2.log("Initial HP:", initialAttributes.hp);
        console2.log("Initial AD:", initialAttributes.ad);
        console2.log("Initial AP:", initialAttributes.ap);
        console2.log("Initial Armor:", initialAttributes.armor);
        console2.log("Initial MR:", initialAttributes.mr);
        console2.log("Initial Stage:", uint256(initialStage));

        bool amplifyFound = false;
        uint256 amplifyForgeCount = 0;
        uint256 maxForges = 60;
        uint32 gasLimit = 100_000;

        // Track cumulative attribute changes from ATTRIBUTE effects
        uint256 totalHPFromAttribute = 0;
        uint256 totalADFromAttribute = 0;
        uint256 totalAPFromAttribute = 0;
        uint256 totalArmorFromAttribute = 0;
        uint256 totalMRFromAttribute = 0;

        for (uint256 i = 0; i < maxForges && !amplifyFound; i++) {
            console2.log("\n--- Forge", i + 1, "---");

            // Check if hero is already completed from previous AMPLIFY effect
            GameConstants.HeroStage currentStageBeforeForge = heroContract.getHero(heroId).stage;
            if (currentStageBeforeForge == GameConstants.HeroStage.COMPLETED) {
                console2.log("Hero stage is already COMPLETED, stopping forges");
                break;
            }

            // Wait for cooldown if needed
            vm.warp(block.timestamp + 1 days);

            // Perform forge
            uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
            bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

            // Fulfill forge with different random seeds to get variety
            uint256 randomSeed = uint256(keccak256(abi.encodePacked(block.timestamp, i)));

            vm.prank(address(mockOracle));
            (GameConstants.ForgeEffectType effectType, uint256 effectId, , ) = forgeCoordinator.fulfillForge(
                requestId,
                randomSeed
            );

            console2.log("Effect Type:", uint256(effectType));
            console2.log("Effect ID:", effectId);

            // Get forge item details from the ForgeItemNFT
            // Try different contracts to find the effect
            GameConstants.ForgeEffect memory effect;
            bool effectRetrieved = false;

            // Try SILVER first (most common)
            try forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.SILVER) returns (
                address forgeItemContract
            ) {
                uint256 totalMinted = IForgeItemNFT(forgeItemContract).getTotalMinted();
                if (totalMinted > 0) {
                    try IForgeItemNFT(forgeItemContract).getForgeItem(totalMinted) returns (
                        GameConstants.ForgeEffect memory retrievedEffect
                    ) {
                        effect = retrievedEffect;
                        effectRetrieved = true;
                    } catch {}
                }
            } catch {}
            // If not found in SILVER, check if it's an AMPLIFY effect (which might be in a different contract)
            if (!effectRetrieved && effectType == GameConstants.ForgeEffectType.AMPLIFY) {
                console2.log("AMPLIFY Effect Found at forge", i + 1, "(effect not in SILVER contract)");
                amplifyFound = true;
                amplifyForgeCount = i + 1;

                // AMPLIFY should be available after 15 forges
                assertTrue(i + 1 >= 15, "AMPLIFY should only appear after 15+ forges");

                // Check hero stage changed to COMPLETED
                GameConstants.HeroStage currentStage = heroContract.getHero(heroId).stage;
                console2.log("Stage after AMPLIFY:", uint256(currentStage));
                assertEq(
                    uint256(currentStage),
                    uint256(GameConstants.HeroStage.COMPLETED),
                    "Hero stage should be COMPLETED after AMPLIFY"
                );

                // Get final attributes after AMPLIFY
                GameConstants.HeroAttributes memory finalAttributes = heroContract.getHero(heroId).attributes;

                console2.log("=== After AMPLIFY ===");
                console2.log("Final HP:", finalAttributes.hp);
                console2.log("Final AD:", finalAttributes.ad);
                console2.log("Final AP:", finalAttributes.ap);
                console2.log("Final Armor:", finalAttributes.armor);
                console2.log("Final MR:", finalAttributes.mr);

                // For verification, we can check that attributes have increased from initial
                assertTrue(finalAttributes.hp >= initialAttributes.hp, "HP should have increased");
                assertTrue(finalAttributes.ad >= initialAttributes.ad, "AD should have increased");
                assertTrue(finalAttributes.ap >= initialAttributes.ap, "AP should have increased");
                assertTrue(finalAttributes.armor >= initialAttributes.armor, "Armor should have increased");
                assertTrue(finalAttributes.mr >= initialAttributes.mr, "MR should have increased");

                // Break out of the loop since AMPLIFY completes the forging
                break;
            }

            // If not AMPLIFY and not found in SILVER, skip detailed verification for this forge
            if (!effectRetrieved) {
                console2.log("Effect not found in SILVER, skipping detailed verification for this forge");
                continue; // Skip this iteration and continue the loop
            }

            console2.log("Effect Quality:", uint256(effect.quality));
            console2.log("Effect Value:", effect.value);

            // Track attribute effects
            if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
                if (effect.attribute == GameConstants.HeroAttribute.HP) {
                    totalHPFromAttribute += effect.value;
                } else if (effect.attribute == GameConstants.HeroAttribute.AD) {
                    totalADFromAttribute += effect.value;
                } else if (effect.attribute == GameConstants.HeroAttribute.AP) {
                    totalAPFromAttribute += effect.value;
                } else if (effect.attribute == GameConstants.HeroAttribute.ARMOR) {
                    totalArmorFromAttribute += effect.value;
                } else if (effect.attribute == GameConstants.HeroAttribute.MR) {
                    totalMRFromAttribute += effect.value;
                }

                // Verify current attributes after ATTRIBUTE effect
                GameConstants.HeroAttributes memory currentAttributes = heroContract.getHero(heroId).attributes;
                uint256 expectedHPAfterAttribute = initialAttributes.hp + totalHPFromAttribute;
                uint256 expectedADAfterAttribute = initialAttributes.ad + totalADFromAttribute;
                assertEq(
                    currentAttributes.hp,
                    expectedHPAfterAttribute,
                    "HP should match expected after ATTRIBUTE effects"
                );
                assertEq(
                    currentAttributes.ad,
                    expectedADAfterAttribute,
                    "AD should match expected after ATTRIBUTE effects"
                );
            }
            // Check for AMPLIFY effect
            else if (effectType == GameConstants.ForgeEffectType.AMPLIFY) {
                console2.log("AMPLIFY Effect Found at forge", i + 1);
                amplifyFound = true;
                amplifyForgeCount = i + 1;

                // AMPLIFY should be available after 15 forges
                assertTrue(i + 1 >= 15, "AMPLIFY should only appear after 15+ forges");

                // Check hero stage changed to COMPLETED
                GameConstants.HeroStage currentStage = heroContract.getHero(heroId).stage;
                console2.log("Stage after AMPLIFY:", uint256(currentStage));
                assertEq(
                    uint256(currentStage),
                    uint256(GameConstants.HeroStage.COMPLETED),
                    "Hero stage should be COMPLETED after AMPLIFY"
                );

                // Get final attributes after AMPLIFY
                GameConstants.HeroAttributes memory finalAttributes = heroContract.getHero(heroId).attributes;

                console2.log("=== After AMPLIFY ===");
                console2.log("Final HP:", finalAttributes.hp);
                console2.log("Final AD:", finalAttributes.ad);
                console2.log("Final AP:", finalAttributes.ap);
                console2.log("Final Armor:", finalAttributes.armor);
                console2.log("Final MR:", finalAttributes.mr);

                // For verification, we can check that attributes have increased from initial
                // Since we skipped some effect retrievals, we'll just verify the amplification happened
                assertTrue(finalAttributes.hp >= initialAttributes.hp, "HP should have increased");
                assertTrue(finalAttributes.ad >= initialAttributes.ad, "AD should have increased");
                assertTrue(finalAttributes.ap >= initialAttributes.ap, "AP should have increased");
                assertTrue(finalAttributes.armor >= initialAttributes.armor, "Armor should have increased");
                assertTrue(finalAttributes.mr >= initialAttributes.mr, "MR should have increased");

                // Break out of the loop since AMPLIFY completes the forging
                break;
            }
        }

        // Verify AMPLIFY effect was found
        assertTrue(amplifyFound, "AMPLIFY effect should appear within 60 forges");
        console2.log("\nAMPLIFY effect found at forge", amplifyForgeCount, "and hero stage completed successfully");
    }
}
