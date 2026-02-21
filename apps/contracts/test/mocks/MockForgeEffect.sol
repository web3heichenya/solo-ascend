// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IForgeEffect} from "../../src/interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title MockForgeEffect
/// @notice Mock implementation of IForgeEffect for testing
contract MockForgeEffectAttribute is IForgeEffect {
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    function generateEffect(
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (GameConstants.ForgeEffect memory effect) {
        uint32 value;

        if (quality == GameConstants.ForgeQuality.SILVER) {
            value = 10;
        } else if (quality == GameConstants.ForgeQuality.GOLD) {
            value = 20;
        } else if (quality == GameConstants.ForgeQuality.RAINBOW) {
            value = 30;
        } else if (quality == GameConstants.ForgeQuality.MYTHIC) {
            value = 50;
        }

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.ATTRIBUTE,
            quality: quality,
            attribute: GameConstants.HeroAttribute.HP,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        return effect;
    }

    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        _effects[effectId] = effect;
        emit EffectApplied(heroId, effectId, effect.value);
    }

    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.ATTRIBUTE;
    }

    function getQualityWeight(GameConstants.ForgeQuality quality) external pure override returns (uint256) {
        if (quality == GameConstants.ForgeQuality.SILVER) return 100;
        if (quality == GameConstants.ForgeQuality.GOLD) return 80;
        if (quality == GameConstants.ForgeQuality.RAINBOW) return 60;
        if (quality == GameConstants.ForgeQuality.MYTHIC) return 40;
        return 0;
    }

    function isAvailable(
        GameConstants.ForgeQuality /* quality */,
        uint256 /* totalForges */
    ) external pure override returns (bool) {
        return true;
    }

    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }
}

contract MockForgeEffectAmplify is IForgeEffect {
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    function generateEffect(
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (GameConstants.ForgeEffect memory effect) {
        uint32 value;

        if (quality == GameConstants.ForgeQuality.SILVER) {
            value = 10;
        } else if (quality == GameConstants.ForgeQuality.GOLD) {
            value = 20;
        } else if (quality == GameConstants.ForgeQuality.RAINBOW) {
            value = 30;
        } else if (quality == GameConstants.ForgeQuality.MYTHIC) {
            value = 50;
        }

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.AMPLIFY,
            quality: quality,
            attribute: GameConstants.HeroAttribute.AD,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        return effect;
    }

    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        // Import the interface to make the call
        IForgeCoordinator coordinator = IForgeCoordinator(msg.sender);

        // AMPLIFY effects complete the forging process -> COMPLETED stage
        coordinator.updateHeroStage(heroId, GameConstants.HeroStage.COMPLETED);
        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.AMPLIFY;
    }

    function getQualityWeight(GameConstants.ForgeQuality quality) external pure override returns (uint256) {
        // Keep AMPLIFY effect with normal weights to avoid interfering with regular tests
        if (quality == GameConstants.ForgeQuality.SILVER) return 80;
        if (quality == GameConstants.ForgeQuality.GOLD) return 60;
        if (quality == GameConstants.ForgeQuality.RAINBOW) return 40;
        if (quality == GameConstants.ForgeQuality.MYTHIC) return 20;
        return 0;
    }

    function isAvailable(
        GameConstants.ForgeQuality /* quality */,
        uint256 totalForges
    ) external pure override returns (bool) {
        // Make AMPLIFY effect available at the 50th forge (guaranteed) or after 100 forges to avoid interfering with regular tests
        return totalForges >= 50;
    }

    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }
}

contract MockForgeEffectEnhance is IForgeEffect {
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    function generateEffect(
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (GameConstants.ForgeEffect memory effect) {
        uint32 value;

        if (quality == GameConstants.ForgeQuality.SILVER) {
            value = 10;
        } else if (quality == GameConstants.ForgeQuality.GOLD) {
            value = 20;
        } else if (quality == GameConstants.ForgeQuality.RAINBOW) {
            value = 30;
        } else if (quality == GameConstants.ForgeQuality.MYTHIC) {
            value = 50;
        }

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.ENHANCE,
            quality: quality,
            attribute: GameConstants.HeroAttribute.AP,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        return effect;
    }

    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        _effects[effectId] = effect;
        emit EffectApplied(heroId, effectId, effect.value);
    }

    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.ENHANCE;
    }

    function getQualityWeight(GameConstants.ForgeQuality quality) external pure override returns (uint256) {
        if (quality == GameConstants.ForgeQuality.SILVER) return 100;
        if (quality == GameConstants.ForgeQuality.GOLD) return 80;
        if (quality == GameConstants.ForgeQuality.RAINBOW) return 60;
        if (quality == GameConstants.ForgeQuality.MYTHIC) return 40;
        return 0;
    }

    function isAvailable(
        GameConstants.ForgeQuality /* quality */,
        uint256 /* totalForges */
    ) external pure override returns (bool) {
        return true;
    }

    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }
}

contract MockForgeEffectMythic is IForgeEffect {
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    function generateEffect(
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (GameConstants.ForgeEffect memory effect) {
        uint32 value;

        if (quality == GameConstants.ForgeQuality.SILVER) {
            value = 10;
        } else if (quality == GameConstants.ForgeQuality.GOLD) {
            value = 20;
        } else if (quality == GameConstants.ForgeQuality.RAINBOW) {
            value = 30;
        } else if (quality == GameConstants.ForgeQuality.MYTHIC) {
            value = 50;
        }

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.MYTHIC,
            quality: quality,
            attribute: GameConstants.HeroAttribute.HP,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        return effect;
    }

    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        // Import the interface to make the call
        IForgeCoordinator coordinator = IForgeCoordinator(msg.sender);

        // MYTHIC effects enable solo leveling -> SOLO_LEVELING stage
        coordinator.updateHeroStage(heroId, GameConstants.HeroStage.SOLO_LEVELING);
        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.MYTHIC;
    }

    function getQualityWeight(GameConstants.ForgeQuality quality) external pure override returns (uint256) {
        if (quality == GameConstants.ForgeQuality.SILVER) return 100;
        if (quality == GameConstants.ForgeQuality.GOLD) return 80;
        if (quality == GameConstants.ForgeQuality.RAINBOW) return 60;
        if (quality == GameConstants.ForgeQuality.MYTHIC) return 40;
        return 0;
    }

    function isAvailable(
        GameConstants.ForgeQuality /* quality */,
        uint256 totalForges
    ) external pure override returns (bool) {
        // Make MYTHIC effect only available after many forges to avoid interfering with regular tests
        return totalForges >= 200;
    }

    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }
}
