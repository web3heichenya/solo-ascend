// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title AmplifyForgeEffect
/// @notice Implementation of AMPLIFY type forge effects
/// @author Solo Ascend Team
contract AmplifyForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    error InsufficientForgesForAmplify();
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Amplification scaling factor per quality level
    mapping(GameConstants.ForgeQuality => uint256) private _qualityAmplifyBps;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Minimum forges required before AMPLIFY effects become available
    uint256 public constant MIN_FORGES_REQUIRED = 15;

    /// @notice Base amplification percentage (in basis points)
    uint256 public constant BASE_AMPLIFY_BPS = 1000; // 10%

    /// @notice Maximum amplification percentage (in basis points)
    uint256 public constant MAX_AMPLIFY_BPS = 5000; // 50%

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the AmplifyForgeEffect with quality-based amplification values
    /// @param admin Admin address for ownership
    /// @param coordinator Address of the forge coordinator
    constructor(address admin, address coordinator) Ownable(admin) {
        if (coordinator == address(0)) revert InvalidCoordinator();
        FORGE_COORDINATOR = IForgeCoordinator(coordinator);

        // Initialize quality weights
        _initializeQualityWeights();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function generateEffect(
        uint256 randomSeed,
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (GameConstants.ForgeEffect memory effect) {
        // Check if hero meets minimum forge requirement
        if (totalForges < MIN_FORGES_REQUIRED) revert InsufficientForgesForAmplify();
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        // Generate amplification percentage based on quality
        uint256 amplifyBps = _qualityAmplifyBps[quality];

        // Add some randomness to the amplification (±20% variation)
        uint256 variation = (randomSeed % 400) + 800; // 800-1200 (80%-120%)
        amplifyBps = (amplifyBps * variation) / 1000;

        // Cap at maximum amplification
        if (amplifyBps > MAX_AMPLIFY_BPS) {
            amplifyBps = MAX_AMPLIFY_BPS;
        }

        return
            GameConstants.ForgeEffect({
                effectType: GameConstants.ForgeEffectType.AMPLIFY,
                quality: quality,
                attribute: GameConstants.HeroAttribute.HP, // Not used for AMPLIFY effects
                value: uint32(amplifyBps),
                createdAt: uint64(block.timestamp),
                isLocked: false
            });
    }

    /// @inheritdoc IForgeEffect
    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        // Amplify effects complete the forging process
        FORGE_COORDINATOR.updateHeroStage(heroId, GameConstants.HeroStage.COMPLETED);

        // Apply percentage boost to all attributes at once
        FORGE_COORDINATOR.increaseHeroAllAttributes(heroId, effect.value, true);

        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Set quality weight for probability distribution
    /// @param quality The quality level to set weight for
    /// @param weight The new weight value
    function setQualityWeight(GameConstants.ForgeQuality quality, uint256 weight) external onlyOwner {
        _qualityWeights[quality] = weight;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.AMPLIFY;
    }

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @notice Get amplification value preview for a given quality
    /// @param quality Forge quality
    /// @return amplifyBps Amplification in basis points
    function getAmplificationPreview(GameConstants.ForgeQuality quality) external view returns (uint256 amplifyBps) {
        return _qualityAmplifyBps[quality];
    }

    /// @inheritdoc IForgeEffect
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (bool available) {
        return getQualityWeight(quality) > 0 && totalForges >= MIN_FORGES_REQUIRED;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights with default values
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 10;
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 30;
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 30;
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 0;
    }
}
