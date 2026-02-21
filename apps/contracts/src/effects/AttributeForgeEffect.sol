// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {LibPRNG} from "solady/utils/LibPRNG.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title AttributeForgeEffect
/// @notice Forge effect that boosts specific hero attributes
/// @author Solo Ascend Team
contract AttributeForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         LIBRARIES                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    using LibPRNG for LibPRNG.PRNG;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Next effect ID counter
    uint256 private _nextEffectId = 1;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /// @notice Value ranges for each quality and attribute
    mapping(GameConstants.ForgeQuality => mapping(uint8 => uint256[2])) private _valueRanges;

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTANTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Minimum forges required before ATTRIBUTE effects become available
    uint256 public constant MIN_FORGES_REQUIRED = 0;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the AttributeForgeEffect with default configurations
    /// @param admin The address that will be granted owner privileges
    /// @param coordinator The address of the forge coordinator
    constructor(address admin, address coordinator) Ownable(admin) {
        if (coordinator == address(0)) revert InvalidCoordinator();
        FORGE_COORDINATOR = IForgeCoordinator(coordinator);
        _initializeQualityWeights();
        _initializeValueRanges();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function generateEffect(
        uint256 randomSeed,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external override returns (GameConstants.ForgeEffect memory effect) {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        LibPRNG.PRNG memory prng = LibPRNG.PRNG(randomSeed);

        // Generate random attribute (0-9 for the 10 attributes)
        uint8 attributeIndex = uint8(prng.uniform(10));
        GameConstants.HeroAttribute attribute = GameConstants.HeroAttribute(attributeIndex);

        // Get value range for quality and attribute
        uint256[2] memory range = _valueRanges[quality][attributeIndex];
        uint32 value = uint32(range[0] + prng.uniform(range[1] - range[0] + 1));

        // Create effect
        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.ATTRIBUTE,
            quality: quality,
            attribute: attribute,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        // Store effect
        uint256 effectId = _nextEffectId;
        ++_nextEffectId;

        emit EffectGenerated(effectId, GameConstants.ForgeEffectType.ATTRIBUTE, value);
        return effect;
    }

    /// @inheritdoc IForgeEffect
    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        // Get the ForgeCoordinator from msg.sender
        IForgeCoordinator coordinator = IForgeCoordinator(msg.sender);

        coordinator.increaseHeroAttribute(heroId, effect.attribute, effect.value, false);

        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Update quality weight
    /// @param quality Quality tier
    /// @param weight New weight
    function setQualityWeight(GameConstants.ForgeQuality quality, uint256 weight) external onlyOwner {
        _qualityWeights[quality] = weight;
    }

    /// @notice Update value range for quality and attribute
    /// @param quality Quality tier
    /// @param attributeIndex Attribute index (0-9)
    /// @param minValue Minimum value
    /// @param maxValue Maximum value
    function setValueRange(
        GameConstants.ForgeQuality quality,
        uint8 attributeIndex,
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner {
        if (9 < attributeIndex) revert InvalidEffectData();
        if (maxValue < minValue) revert InvalidEffectData();

        _valueRanges[quality][attributeIndex] = [minValue, maxValue];
    }

    /// @inheritdoc IForgeEffect
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view returns (bool available) {
        return getQualityWeight(quality) > 0;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view override returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @inheritdoc IForgeEffect
    function getEffect(uint256 effectId) external view override returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }

    /// @notice Get value range for quality and attribute
    /// @param quality Quality tier
    /// @param attributeIndex Attribute index
    /// @return minValue Minimum value
    /// @return maxValue Maximum value
    function getValueRange(
        GameConstants.ForgeQuality quality,
        uint8 attributeIndex
    ) external view returns (uint256 minValue, uint256 maxValue) {
        uint256[2] memory range = _valueRanges[quality][attributeIndex];
        return (range[0], range[1]);
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure override returns (GameConstants.ForgeEffectType effectType) {
        return GameConstants.ForgeEffectType.ATTRIBUTE;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 100; // Most common
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 100; // Common
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 100; // Common for attributes
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 0; // Not available for attributes
    }

    /// @notice Initialize value ranges for all qualities and attributes
    function _initializeValueRanges() internal {
        // HP ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][0] = [10, 50]; // HP
        _valueRanges[GameConstants.ForgeQuality.GOLD][0] = [50, 100];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][0] = [100, 200];

        // HP Regen ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][1] = [1, 3]; // HP Regen
        _valueRanges[GameConstants.ForgeQuality.GOLD][1] = [3, 6];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][1] = [6, 15];

        // AD ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][2] = [3, 10]; // AD
        _valueRanges[GameConstants.ForgeQuality.GOLD][2] = [10, 20];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][2] = [20, 40];

        // AP ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][3] = [3, 10]; // AP
        _valueRanges[GameConstants.ForgeQuality.GOLD][3] = [10, 20];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][3] = [20, 40];

        // Attack Speed ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][4] = [2, 8]; // Attack Speed
        _valueRanges[GameConstants.ForgeQuality.GOLD][4] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][4] = [15, 30];

        // Crit ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][5] = [2, 8]; // Crit
        _valueRanges[GameConstants.ForgeQuality.GOLD][5] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][5] = [15, 30];

        // Armor ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][6] = [2, 8]; // Armor
        _valueRanges[GameConstants.ForgeQuality.GOLD][6] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][6] = [15, 30];

        // MR ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][7] = [2, 8]; // MR
        _valueRanges[GameConstants.ForgeQuality.GOLD][7] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][7] = [15, 30];

        // CDR ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][8] = [2, 8]; // CDR
        _valueRanges[GameConstants.ForgeQuality.GOLD][8] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][8] = [15, 30];

        // Move Speed ranges
        _valueRanges[GameConstants.ForgeQuality.SILVER][9] = [2, 8]; // Move Speed
        _valueRanges[GameConstants.ForgeQuality.GOLD][9] = [8, 15];
        _valueRanges[GameConstants.ForgeQuality.RAINBOW][9] = [15, 30];
    }
}
