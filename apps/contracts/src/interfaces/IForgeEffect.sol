// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IForgeEffect
/// @notice Interface for modular forge effects system
/// @author Solo Ascend Team
interface IForgeEffect {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when effect cannot be applied to the specified hero
    error EffectNotApplicable();
    /// @notice Error thrown when effect data is invalid or corrupted
    error InvalidEffectData();
    /// @notice Error thrown when attempting to apply an effect that has already been applied
    error EffectAlreadyApplied();
    /// @notice Error thrown when attempting to apply an effect to an invalid quality
    error InvalidQuality();
    /// @notice Error thrown when attempting to apply an effect to an invalid coordinator
    error InvalidCoordinator();
    /// @notice Error thrown when attempting to apply an effect to an invalid treasury
    error InvalidTreasury();
    /// @notice Error thrown when attempting to apply an effect to an invalid hero contract
    error InvalidHeroContract();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new effect is generated
    /// @param effectId Unique effect instance ID
    /// @param effectType Type of effect generated
    /// @param value Value of the effect
    event EffectGenerated(uint256 indexed effectId, GameConstants.ForgeEffectType effectType, uint256 value);

    /// @notice Emitted when an effect is applied to a hero
    /// @param heroId Target hero ID
    /// @param effectId Unique effect instance ID
    /// @param value Value of the effect
    event EffectApplied(uint256 indexed heroId, uint256 indexed effectId, uint256 value);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate a new forge effect based on random seed
    /// @param randomSeed Random seed for effect generation
    /// @param quality Quality tier for the effect
    /// @param totalForges Total forges performed by the hero
    /// @return effect The generated forge effect
    function generateEffect(
        uint256 randomSeed,
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external returns (GameConstants.ForgeEffect memory effect);

    /// @notice Execute effect logic (called by ForgeCoordinator after generation)
    /// @param heroId Target hero ID
    /// @param effect Generated effect data
    /// @param effectId Unique effect instance ID
    function executeEffect(uint256 heroId, GameConstants.ForgeEffect calldata effect, uint256 effectId) external;

    /// @notice Get effect data
    /// @param effectId Effect ID
    /// @return effect Effect data
    function getEffect(uint256 effectId) external view returns (GameConstants.ForgeEffect memory effect);

    /// @notice Get effect type supported by this contract
    /// @return effectType The effect type this contract handles
    function getEffectType() external pure returns (GameConstants.ForgeEffectType effectType);

    /// @notice Get quality distribution for this effect type
    /// @param quality Quality tier to check
    /// @return weight Probability weight for this quality
    function getQualityWeight(GameConstants.ForgeQuality quality) external view returns (uint256 weight);

    /// @notice Check if the effect is available for a given total forges
    /// @param quality Quality tier to check
    /// @param totalForges Total forges performed by the hero
    /// @return isAvailable True if the effect is available, false otherwise
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (bool isAvailable);
}
