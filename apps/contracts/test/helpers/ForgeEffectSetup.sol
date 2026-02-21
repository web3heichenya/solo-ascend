// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {
    MockForgeEffectAttribute,
    MockForgeEffectAmplify,
    MockForgeEffectEnhance,
    MockForgeEffectMythic
} from "../mocks/MockForgeEffect.sol";

/// @title ForgeEffectSetup
/// @notice Helper library for setting up forge effects in tests
library ForgeEffectSetup {
    /// @notice Setup default forge effects for all effect types
    /// @param registry The ForgeEffectRegistry to setup
    function setupDefaultForgeEffects(ForgeEffectRegistry registry) internal {
        // Deploy mock implementations for each effect type
        MockForgeEffectAttribute attributeEffect = new MockForgeEffectAttribute();
        MockForgeEffectAmplify amplifyEffect = new MockForgeEffectAmplify();
        MockForgeEffectEnhance enhanceEffect = new MockForgeEffectEnhance();
        MockForgeEffectMythic mythicEffect = new MockForgeEffectMythic();

        // Register ATTRIBUTE effect type
        registry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute Boost",
            "Increases basic hero attributes",
            address(attributeEffect)
        );

        // Register AMPLIFY effect type
        registry.registerEffectType(
            GameConstants.ForgeEffectType.AMPLIFY,
            "Amplify Power",
            "Amplifies hero's combat power",
            address(amplifyEffect)
        );

        // Register ENHANCE effect type
        registry.registerEffectType(
            GameConstants.ForgeEffectType.ENHANCE,
            "Enhanced Abilities",
            "Enhances hero's special abilities",
            address(enhanceEffect)
        );

        // Register MYTHIC effect type
        registry.registerEffectType(
            GameConstants.ForgeEffectType.MYTHIC,
            "Mythic Power",
            "Grants mythic-tier bonuses",
            address(mythicEffect)
        );
    }
}
