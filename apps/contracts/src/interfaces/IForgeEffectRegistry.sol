// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IForgeEffectRegistry
/// @notice Interface for the ForgeEffectRegistry contract
/// @author Solo Ascend Team
interface IForgeEffectRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the effect type is already registered
    error EffectTypeAlreadyRegistered(GameConstants.ForgeEffectType effectTypeId);
    /// @notice Error thrown when the effect type is not found
    error EffectTypeNotFound(GameConstants.ForgeEffectType effectTypeId);
    /// @notice Error thrown when the effect type is inactive
    error EffectTypeInactive(GameConstants.ForgeEffectType effectTypeId);
    /// @notice Error thrown when the implementation is invalid
    error InvalidImplementation();
    /// @notice Error thrown when the effect type data is invalid
    error InvalidEffectTypeData();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new effect type is registered
    /// @param effectTypeId Unique identifier for the effect type
    /// @param name Display name for the effect type
    /// @param implementation Implementation contract address
    event EffectTypeRegistered(
        GameConstants.ForgeEffectType indexed effectTypeId,
        string name,
        address indexed implementation
    );

    /// @notice Emitted when an effect type implementation is updated
    /// @param effectTypeId Effect type identifier
    /// @param newImplementation New implementation address
    event EffectTypeUpdated(GameConstants.ForgeEffectType indexed effectTypeId, address indexed newImplementation);

    /// @notice Emitted when an effect type is deactivated
    /// @param effectTypeId Effect type identifier
    event EffectTypeDeactivated(GameConstants.ForgeEffectType indexed effectTypeId);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Effect type data
    /// @param name Effect type name
    /// @param description Effect type description
    /// @param isActive Whether effect type is active
    /// @param createdAt Registration timestamp
    struct EffectTypeData {
        string name;
        string description;
        bool isActive; // Whether effect type is active
        uint64 createdAt; // Registration timestamp
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get implementation address for an effect type
    /// @param effectTypeId Effect type identifier
    /// @return implementation Implementation contract address
    function getEffectImplementation(
        GameConstants.ForgeEffectType effectTypeId
    ) external view returns (address implementation);

    /// @notice Get effect type metadata
    /// @param effectTypeId Effect type identifier
    /// @return effectType Effect type data
    function getEffectType(
        GameConstants.ForgeEffectType effectTypeId
    ) external view returns (EffectTypeData memory effectType);

    /// @notice Get quality weight for an effect type
    /// @param effectTypeId Effect type ID
    /// @param quality Quality tier to check
    /// @return weight Probability weight for this quality
    function getEffectQualityWeight(
        GameConstants.ForgeEffectType effectTypeId,
        GameConstants.ForgeQuality quality
    ) external view returns (uint256);

    /// @notice Get available effect types
    /// @param quality Quality tier to check
    /// @param totalForges Total forges performed by the hero
    /// @return availableEffectTypes Array of available effect types
    function getAvailableEffectTypes(
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (GameConstants.ForgeEffectType[] memory);

    /// @notice Check if an effect implementation is authorized
    /// @param effectImplementation Address of the effect implementation
    /// @return isAuthorized Whether the effect implementation is authorized
    function isAuthorizedForgeEffect(address effectImplementation) external view returns (bool);

    /// @notice Register a new effect type
    /// @param effectTypeId Unique identifier for the effect type
    /// @param name Display name for the effect type
    /// @param description Effect type description
    /// @param implementation Contract implementing IForgeEffect
    function registerEffectType(
        GameConstants.ForgeEffectType effectTypeId,
        string calldata name,
        string calldata description,
        address implementation
    ) external;

    /// @notice Update implementation for an effect type
    /// @param effectTypeId Effect type to update
    /// @param newImplementation New implementation address
    function updateEffectImplementation(GameConstants.ForgeEffectType effectTypeId, address newImplementation) external;

    /// @notice Deactivate an effect type
    /// @param effectTypeId Effect type to deactivate
    function deactivateEffectType(GameConstants.ForgeEffectType effectTypeId) external;

    /// @notice Reactivate an effect type
    /// @param effectTypeId Effect type to reactivate
    function reactivateEffectType(GameConstants.ForgeEffectType effectTypeId) external;
}
