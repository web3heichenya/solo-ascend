// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title TraitSetup
/// @notice Helper contract for setting up basic traits in tests
library TraitSetup {
    /// @notice Setup basic traits for all required layers
    /// @param traitRegistry The HeroTraitRegistry to register traits in
    function setupBasicTraits(HeroTraitRegistry traitRegistry) internal {
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
                string(abi.encodePacked("Weapon", bytes1(uint8(48 + i + 1))))
            );
        }
    }
}
