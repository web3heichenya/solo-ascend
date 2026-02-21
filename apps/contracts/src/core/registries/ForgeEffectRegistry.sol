// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffectRegistry} from "../../interfaces/IForgeEffectRegistry.sol";
import {GameConstants} from "../../libraries/GameConstants.sol";
import {IForgeEffect} from "../../interfaces/IForgeEffect.sol";

/// @title ForgeEffectRegistry
/// @notice Dynamic registry for forge effect types and their implementations
/// @author Solo Ascend Team
contract ForgeEffectRegistry is Ownable, IForgeEffectRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Mapping from effect type ID to implementation address
    mapping(GameConstants.ForgeEffectType => address) private _effectImplementations;

    /// @notice Mapping from effect type ID to metadata
    mapping(GameConstants.ForgeEffectType => EffectTypeData) private _effectTypes;

    /// @notice Mapping from effect implementation address to whether it is authorized
    mapping(address => bool) private _isAuthorizedForgeEffect;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize ForgeEffectRegistry
    /// @param admin Admin address for ownership
    constructor(address admin) Ownable(admin) {}

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

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
    ) external onlyOwner {
        if (_effectTypes[effectTypeId].createdAt > 0) revert EffectTypeAlreadyRegistered(effectTypeId);
        if (implementation == address(0)) revert InvalidImplementation();
        if (bytes(name).length == 0) revert InvalidEffectTypeData();

        _effectTypes[effectTypeId] = EffectTypeData({
            name: name,
            description: description,
            isActive: true,
            createdAt: uint64(block.timestamp)
        });

        _effectImplementations[effectTypeId] = implementation;
        _isAuthorizedForgeEffect[implementation] = true;
        emit EffectTypeRegistered(effectTypeId, name, implementation);
    }

    /// @notice Update implementation for an effect type
    /// @param effectTypeId Effect type to update
    /// @param newImplementation New implementation address
    function updateEffectImplementation(
        GameConstants.ForgeEffectType effectTypeId,
        address newImplementation
    ) external onlyOwner {
        if (_effectTypes[effectTypeId].createdAt == 0) revert EffectTypeNotFound(effectTypeId);
        if (newImplementation == address(0)) revert InvalidImplementation();
        address oldImplementation = _effectImplementations[effectTypeId];
        _effectImplementations[effectTypeId] = newImplementation;
        _isAuthorizedForgeEffect[oldImplementation] = false;
        _isAuthorizedForgeEffect[newImplementation] = true;

        emit EffectTypeUpdated(effectTypeId, newImplementation);
    }

    /// @notice Deactivate an effect type
    /// @param effectTypeId Effect type to deactivate
    function deactivateEffectType(GameConstants.ForgeEffectType effectTypeId) external onlyOwner {
        if (_effectTypes[effectTypeId].createdAt == 0) revert EffectTypeNotFound(effectTypeId);

        _effectTypes[effectTypeId].isActive = false;

        emit EffectTypeDeactivated(effectTypeId);
    }

    /// @notice Reactivate an effect type
    /// @param effectTypeId Effect type to reactivate
    function reactivateEffectType(GameConstants.ForgeEffectType effectTypeId) external onlyOwner {
        if (_effectTypes[effectTypeId].createdAt == 0) revert EffectTypeNotFound(effectTypeId);

        _effectTypes[effectTypeId].isActive = true;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffectRegistry
    function getEffectType(GameConstants.ForgeEffectType effectTypeId) external view returns (EffectTypeData memory) {
        return _effectTypes[effectTypeId];
    }

    /// @inheritdoc IForgeEffectRegistry
    function getEffectImplementation(GameConstants.ForgeEffectType effectTypeId) external view returns (address) {
        return _effectImplementations[effectTypeId];
    }

    /// @inheritdoc IForgeEffectRegistry
    function getEffectQualityWeight(
        GameConstants.ForgeEffectType effectTypeId,
        GameConstants.ForgeQuality quality
    ) external view returns (uint256) {
        uint256 weight = IForgeEffect(_effectImplementations[effectTypeId]).getQualityWeight(quality);
        return weight;
    }

    /// @inheritdoc IForgeEffectRegistry
    function getAvailableEffectTypes(
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (GameConstants.ForgeEffectType[] memory) {
        GameConstants.ForgeEffectType[] memory tmp = new GameConstants.ForgeEffectType[](6);
        uint256 n = 0;
        for (uint256 i = 0; i < 6; ) {
            GameConstants.ForgeEffectType t = GameConstants.ForgeEffectType(i);
            unchecked {
                ++i;
            }

            if (_effectTypes[t].isActive) {
                address impl = _effectImplementations[t];
                if (impl != address(0) && IForgeEffect(impl).isAvailable(quality, totalForges)) {
                    tmp[n] = t;
                    unchecked {
                        ++n;
                    }
                }
            }
        }
        GameConstants.ForgeEffectType[] memory availableEffectTypes = new GameConstants.ForgeEffectType[](n);
        for (uint256 j = 0; j < n; ) {
            availableEffectTypes[j] = tmp[j];
            unchecked {
                ++j;
            }
        }
        return availableEffectTypes;
    }

    /// @inheritdoc IForgeEffectRegistry
    function isAuthorizedForgeEffect(address effectImplementation) external view returns (bool) {
        return _isAuthorizedForgeEffect[effectImplementation];
    }
}
