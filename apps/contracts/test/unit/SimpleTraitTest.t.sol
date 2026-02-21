// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

contract SimpleTraitTest is Test {
    HeroTraitRegistry public registry;
    address public admin = address(0x1);

    function setUp() public {
        vm.startPrank(admin);
        registry = new HeroTraitRegistry(admin);
        vm.stopPrank();
    }

    function testBasicRegistration() public {
        vm.startPrank(admin);

        // Register a simple BASE trait
        registry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BASE,
            '<rect x="10" y="10" width="80" height="100" fill="#dbb180"/>',
            "Human"
        );

        assertEq(registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE), 1);

        vm.stopPrank();
    }

    function testWeaponRegistration() public {
        vm.startPrank(admin);

        // Register a warrior weapon
        registry.registerWeaponTrait(
            GameConstants.HeroClass.WARRIOR,
            '<rect x="10" y="50" width="5" height="100" fill="#C0C0C0"/>',
            '<rect x="10" y="50" width="5" height="100" fill="#FFD700"/>',
            '<rect x="10" y="50" width="5" height="100" fill="#FF69B4"/>',
            "Excalibur"
        );

        assertEq(registry.weaponTraitsCounts(GameConstants.HeroClass.WARRIOR), 1);

        // Test getting weapon SVG (weapon IDs now start from 1)
        string memory svg = registry.getWeaponTraitSVG(
            GameConstants.HeroClass.WARRIOR,
            1,
            GameConstants.HeroStage.FORGING
        );

        assertTrue(bytes(svg).length > 0);

        vm.stopPrank();
    }

    function testLayerBounds() public view {
        // Check BACKGROUND bounds (new in v2.0)
        IHeroTraitRegistry.LayerBounds memory bounds = registry.layerBounds(IHeroTraitRegistry.TraitLayer.BACKGROUND);
        assertEq(bounds.x, 0);
        assertEq(bounds.y, 0);
        assertEq(bounds.width, 400);
        assertEq(bounds.height, 400);

        // Check BASE bounds (updated for v2.0)
        bounds = registry.layerBounds(IHeroTraitRegistry.TraitLayer.BASE);
        assertEq(bounds.x, 100);
        assertEq(bounds.y, 70);
        assertEq(bounds.width, 200);
        assertEq(bounds.height, 260);

        // Check EYES bounds (updated positioning)
        bounds = registry.layerBounds(IHeroTraitRegistry.TraitLayer.EYES);
        assertEq(bounds.x, 165);
        assertEq(bounds.y, 95);
        assertEq(bounds.width, 70);
        assertEq(bounds.height, 16);
    }

    function testRequiredLayers() public view {
        // Check required layers (v2.0 includes BACKGROUND)
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.BACKGROUND));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.BASE));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.EYES));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.MOUTH));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.BODY));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.LEGS));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.FOOT));
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.WEAPON));

        // Check required layer (v2.0 - HAIR_HAT is now required)
        assertTrue(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.HAIR_HAT));

        // Check optional layers
        assertFalse(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.GLASSES));
        assertFalse(registry.requiredLayers(IHeroTraitRegistry.TraitLayer.FACE_FEATURE));
    }

    function testTraitSelectionWithData() public {
        vm.startPrank(admin);

        // Register multiple traits with equal probability
        registry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, '<rect fill="#dbb180"/>', "Human");

        registry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, '<rect fill="#90EE90"/>', "Elf");

        registry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, '<rect fill="#696969"/>', "Zombie");

        // Test selection
        uint256 seed = 12_345;
        uint256 traitId = registry.selectRandomLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, seed);

        // Should return a valid trait ID (trait IDs now start from 1)
        assertTrue(traitId > 0 && traitId <= 3);

        vm.stopPrank();
    }
}
