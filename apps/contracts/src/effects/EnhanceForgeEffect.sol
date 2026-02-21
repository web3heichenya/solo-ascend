// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title EnhanceForgeEffect
/// @notice Implementation of ENHANCE type forge effects
/// @author Solo Ascend Team
contract EnhanceForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTANTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice ENHANCE effects have no minimum forge requirement
    uint256 public constant MIN_FORGES_REQUIRED = 0;

    /// @notice Number of attribute forge items to create
    uint256 public constant ITEMS_TO_CREATE = 2;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize enhance forge effect
    /// @param admin Admin address for ownership
    /// @param coordinator Forge coordinator address
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
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view returns (GameConstants.ForgeEffect memory effect) {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        return
            GameConstants.ForgeEffect({
                effectType: GameConstants.ForgeEffectType.ENHANCE,
                quality: quality,
                attribute: GameConstants.HeroAttribute.HP, // Not used for ENHANCE effects
                value: uint32(ITEMS_TO_CREATE), // Number of additional forges to create
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

        for (uint256 i = 0; i < ITEMS_TO_CREATE; ++i) {
            // Create the forge item NFT to hero's TBA
            uint256 afterEffectId = uint256(keccak256(abi.encode(effectId, block.timestamp, i)));
            FORGE_COORDINATOR.mintForgeItem(
                heroId,
                effect.quality,
                GameConstants.ForgeEffectType.ATTRIBUTE,
                afterEffectId
            );
        }

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
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 totalForges
    ) external view returns (bool available) {
        return getQualityWeight(quality) > 0 && totalForges >= MIN_FORGES_REQUIRED;
    }

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.ENHANCE;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights with default values
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 0;
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 30;
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 30;
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 0;
    }
}
