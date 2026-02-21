// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {AttributeForgeEffect} from "../../src/effects/AttributeForgeEffect.sol";
import {EnhanceForgeEffect} from "../../src/effects/EnhanceForgeEffect.sol";
import {AmplifyForgeEffect} from "../../src/effects/AmplifyForgeEffect.sol";
import {MythicForgeEffect} from "../../src/effects/MythicForgeEffect.sol";
import {FTForgeEffect} from "../../src/effects/FTForgeEffect.sol";
import {NFTForgeEffect} from "../../src/effects/NFTForgeEffect.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";

/// @title RealForgeEffectSetup
/// @notice Helper library for setting up real forge effects in tests
library RealForgeEffectSetup {
    /// @notice Setup real forge effects using actual implementations
    /// @param registry The ForgeEffectRegistry to setup
    /// @param admin Admin address for effect contracts
    /// @param coordinator Forge coordinator address
    /// @param treasury Treasury contract address for FT effect
    /// @param heroContract Hero contract address for FT effect
    function setupRealForgeEffects(
        ForgeEffectRegistry registry,
        address admin,
        address coordinator,
        address treasury,
        address heroContract
    ) internal {
        // Deploy real AttributeForgeEffect
        AttributeForgeEffect attributeEffect = new AttributeForgeEffect(admin, coordinator);

        // Deploy real EnhanceForgeEffect
        EnhanceForgeEffect enhanceEffect = new EnhanceForgeEffect(admin, coordinator);

        // Deploy real AmplifyForgeEffect
        AmplifyForgeEffect amplifyEffect = new AmplifyForgeEffect(admin, coordinator);

        // Deploy real MythicForgeEffect
        MythicForgeEffect mythicEffect = new MythicForgeEffect(admin, coordinator);

        // Deploy real FTForgeEffect
        FTForgeEffect ftEffect = new FTForgeEffect(admin, treasury, heroContract, coordinator);

        // Deploy real NFTForgeEffect
        NFTForgeEffect nftEffect = new NFTForgeEffect(admin, coordinator);

        // Register ATTRIBUTE effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute Boost",
            "Increases basic hero attributes",
            address(attributeEffect)
        );

        // Register ENHANCE effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.ENHANCE,
            "Enhanced Abilities",
            "Enhances hero's special abilities",
            address(enhanceEffect)
        );

        // Register AMPLIFY effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.AMPLIFY,
            "Amplify Power",
            "Percentage boost to all attributes",
            address(amplifyEffect)
        );

        // Register MYTHIC effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.MYTHIC,
            "Mythic Power",
            "Grants mythic-tier bonuses",
            address(mythicEffect)
        );

        // Register FT effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.FT,
            "Token Reward",
            "Grants treasury token rewards",
            address(ftEffect)
        );

        // Register NFT effect type with real implementation
        registry.registerEffectType(
            GameConstants.ForgeEffectType.NFT,
            "NFT Reward",
            "Grants special NFT rewards",
            address(nftEffect)
        );
    }
}
