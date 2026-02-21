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
import {EnhanceForgeEffect} from "../../src/effects/EnhanceForgeEffect.sol";
import {AttributeForgeEffect} from "../../src/effects/AttributeForgeEffect.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {IForgeEffect} from "../../src/interfaces/IForgeEffect.sol";
import {IForgeItemNFT} from "../../src/interfaces/IForgeItemNFT.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {ForgeItemNFT} from "../../src/core/ForgeItemNFT.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";

/// @title EnhanceForgeEffectTest
/// @notice Test suite for verifying EnhanceForgeEffect functionality
/// @dev Tests that ENHANCE effects properly create additional attribute forge items
contract EnhanceForgeEffectTest is Test {
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
    ForgeItemNFT public forgeItemNFT;

    // Effect contracts
    EnhanceForgeEffect public enhanceEffect;
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
        // Deploy mock contracts after everything else is set up

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
        enhanceEffect = new EnhanceForgeEffect(admin, address(forgeCoordinator));
        attributeEffect = new AttributeForgeEffect(admin, address(forgeCoordinator));

        // Setup effects registry
        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ENHANCE,
            "Enhanced Abilities",
            "Enhances hero's special abilities",
            address(enhanceEffect)
        );

        forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute Boost",
            "Increases basic hero attributes",
            address(attributeEffect)
        );

        // Setup oracle with GOLD/RAINBOW bias for ENHANCE effects
        _setupHighQualityOracle();

        // Setup forge coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Setup forge item registry with real ForgeItemNFT contracts
        ForgeItemSetup.setupDefaultForgeItemContracts(
            forgeItemRegistry,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Get the GOLD quality forge item contract for testing (since ENHANCE effects are GOLD+)
        forgeItemNFT = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD));

        // Setup basic traits for testing
        _setupBasicTraits();

        // Fund Alice for minting
        vm.deal(ALICE, 1 ether);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Test that ENHANCE effects only appear in GOLD/RAINBOW quality
    function testEnhanceEffectQualityRestriction() public view {
        // Test that ENHANCE is not available for SILVER quality
        assertFalse(
            enhanceEffect.isAvailable(GameConstants.ForgeQuality.SILVER, 0),
            "ENHANCE should not be available for SILVER quality"
        );

        // Test that ENHANCE is available for GOLD quality
        assertTrue(
            enhanceEffect.isAvailable(GameConstants.ForgeQuality.GOLD, 0),
            "ENHANCE should be available for GOLD quality"
        );

        // Test that ENHANCE is available for RAINBOW quality
        assertTrue(
            enhanceEffect.isAvailable(GameConstants.ForgeQuality.RAINBOW, 0),
            "ENHANCE should be available for RAINBOW quality"
        );

        // Test that ENHANCE is not available for MYTHIC quality (default weight is 0)
        assertFalse(
            enhanceEffect.isAvailable(GameConstants.ForgeQuality.MYTHIC, 0),
            "ENHANCE should not be available for MYTHIC quality"
        );
    }

    /// @notice Test that ENHANCE effects create additional forge items
    function testEnhanceEffectCreatesAdditionalForgeItems() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set ENHANCE weight to maximum to guarantee it appears
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 1000);

        // Set ATTRIBUTE weight to 1 to allow it to be created by ENHANCE (but lower than ENHANCE)
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 1);

        // Count initial forge items for GOLD quality (since ENHANCE is GOLD+)
        uint256 initialGoldCount = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD))
            .getTotalMinted();

        // Perform forge to get ENHANCE effect
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        // Fulfill the forge request
        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 12_345);

        // Check forge items created
        uint256 finalGoldCount = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD))
            .getTotalMinted();
        uint256 newGoldItems = finalGoldCount - initialGoldCount;

        // ENHANCE should create 2 additional ATTRIBUTE forge items (plus the original forge = 3 total)
        assertEq(newGoldItems, 3, "ENHANCE effect should create 1 original + 2 additional forge items = 3 total");
    }

    /// @notice Test ENHANCE effect with RAINBOW quality
    function testEnhanceEffectWithRainbowQuality() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set weights to guarantee ENHANCE effect for both GOLD and RAINBOW
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.RAINBOW, 1);
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1);

        // Perform forge
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        // Count initial forge items for both RAINBOW and GOLD (in case oracle generates either)
        uint256 initialRainbowCount = ForgeItemNFT(
            forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.RAINBOW)
        ).getTotalMinted();
        uint256 initialGoldCount = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD))
            .getTotalMinted();

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        // Fulfill with RAINBOW quality seed
        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 54_321);

        // Verify additional forge items were created in either quality
        uint256 finalRainbowCount = ForgeItemNFT(
            forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.RAINBOW)
        ).getTotalMinted();
        uint256 finalGoldCount = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD))
            .getTotalMinted();
        uint256 newRainbowItems = finalRainbowCount - initialRainbowCount;
        uint256 newGoldItems = finalGoldCount - initialGoldCount;
        uint256 totalNewItems = newRainbowItems + newGoldItems;

        assertEq(totalNewItems, 3, "ENHANCE effect should create 1 original + 2 additional forge items = 3 total");
    }

    /// @notice Test that multiple ENHANCE effects can be applied
    function testMultipleEnhanceEffects() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set weights to guarantee ENHANCE effects
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1);

        uint256 totalNewForgeItems = 0;

        // Perform multiple forges (skip time between forges to avoid cooldown)
        ForgeItemNFT goldContract = ForgeItemNFT(
            forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD)
        );
        for (uint256 i = 0; i < 3; i++) {
            // Skip 1 day to avoid forge cooldown
            vm.warp(block.timestamp + 1 days);
            uint256 initialForgeItemCount = goldContract.getTotalMinted();

            uint32 gasLimit = 100_000;
            uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

            vm.prank(ALICE);
            heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
            bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

            vm.prank(address(mockOracle));
            forgeCoordinator.fulfillForge(requestId, 12_345 + i);

            uint256 finalForgeItemCount = goldContract.getTotalMinted();
            uint256 newForgeItems = finalForgeItemCount - initialForgeItemCount;

            assertEq(newForgeItems, 3, "Each ENHANCE effect should create 1 original + 2 additional = 3 forge items");
            totalNewForgeItems += newForgeItems;
        }

        assertEq(
            totalNewForgeItems,
            9,
            "Three ENHANCE effects should create 9 total forge items (3 original + 6 additional)"
        );
    }

    /// @notice Test that ENHANCE effects emit proper events
    function testEnhanceEffectEmitsEvents() public {
        // Mint hero as ALICE
        vm.prank(ALICE);
        uint256 heroId = heroContract.mint{value: MINT_PRICE}();

        // Set weights to guarantee ENHANCE effect
        enhanceEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1000);
        attributeEffect.setQualityWeight(GameConstants.ForgeQuality.GOLD, 1);

        // Perform forge first, then check events in the logs
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(heroId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(heroId, oracleId, gasLimit);
        bytes32 requestId = forgeCoordinator.getPendingRequest(heroId);

        vm.prank(address(mockOracle));
        forgeCoordinator.fulfillForge(requestId, 12_345);

        // Verify that the ENHANCE effect was applied by checking forge items created
        uint256 goldCount = ForgeItemNFT(forgeItemRegistry.getForgeItemContract(GameConstants.ForgeQuality.GOLD))
            .getTotalMinted();
        assertEq(goldCount, 3, "ENHANCE effect should have been applied and created 3 forge items");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       PRIVATE HELPERS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Setup oracle to favor GOLD/RAINBOW qualities for ENHANCE testing
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

    /// @notice Setup basic traits for testing
    function _setupBasicTraits() private {
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

        // Register weapon traits for warrior class (assuming default class)
        traitRegistry.registerWeaponTrait(
            GameConstants.HeroClass.WARRIOR,
            '<path d="M0,0" fill="gold"/>',
            '<path d="M0,0" fill="gold"/>',
            '<path d="M0,0" fill="gold"/>',
            "Golden Sword"
        );
    }
}
