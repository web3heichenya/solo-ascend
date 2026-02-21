// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title MythicForgeEffect
/// @notice Implementation of MYTHIC type forge effects
/// @author Solo Ascend Team
contract MythicForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when insufficient forges are required for MYTHIC effects
    error InsufficientForgesForMythic();
    /// @notice Error thrown when MYTHIC effects have already been applied
    error MythicAlreadyApplied();
    /// @notice Error thrown when the target hero is invalid
    error InvalidTargetHero();
    /// @notice Error thrown when the mythic supply is exhausted
    error MythicSupplyExhausted();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a MYTHIC effect is generated
    /// @param heroId The ID of the hero receiving the effect
    /// @param quality The quality level of the forge
    /// @param supplyRemaining Remaining supply of mythic effects
    event MythicEffectGenerated(uint256 indexed heroId, GameConstants.ForgeQuality quality, uint256 supplyRemaining);

    /// @notice Emitted when maximum supply is reached
    /// @param timestamp The timestamp when supply was exhausted
    event MythicSupplyCompleted(uint256 indexed timestamp);

    /// @notice Emitted when a mythic effect is manually applied to a hero
    /// @param effectId The effect ID that was applied
    /// @param targetHeroId The hero that received the mythic effect
    /// @param appliedBy The address that applied the effect
    event MythicEffectApplied(uint256 indexed effectId, uint256 indexed targetHeroId, address indexed appliedBy);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Current number of MYTHIC effects generated
    uint256 private _currentSupply;

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTANTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Minimum forges required before MYTHIC effects become available
    uint256 public constant MIN_FORGES_REQUIRED = 33;

    /// @notice Maximum number of MYTHIC effects that can ever be generated
    uint256 public constant MAX_SUPPLY = 33;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the MythicForgeEffect with quality-based multipliers
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
    ) external returns (GameConstants.ForgeEffect memory effect) {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (_currentSupply > MAX_SUPPLY - 1) revert MythicSupplyExhausted();
        if (totalForges < MIN_FORGES_REQUIRED) revert InsufficientForgesForMythic();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        // Increment supply counter
        ++_currentSupply;

        // Create the MYTHIC effect
        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.MYTHIC,
            quality: quality,
            attribute: GameConstants.HeroAttribute.HP, // Affects all attributes
            value: 1,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        // Extract hero ID from randomSeed for event (this is a simplified approach)
        uint256 heroId = (randomSeed >> 128) & 0xFFFFFFFF;

        emit MythicEffectGenerated(heroId, quality, MAX_SUPPLY - _currentSupply);

        // Check if supply is exhausted
        if (_currentSupply > MAX_SUPPLY - 1) {
            emit MythicSupplyCompleted(block.timestamp);
        }

        return effect;
    }

    /// @inheritdoc IForgeEffect
    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();

        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
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
    ) external view override returns (bool available) {
        return getQualityWeight(quality) > 0 && totalForges >= MIN_FORGES_REQUIRED && _currentSupply < MAX_SUPPLY;
    }

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view override returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @notice Check remaining supply of MYTHIC effects
    /// @return remaining Number of MYTHIC effects that can still be generated
    function getRemainingSupply() external view returns (uint256 remaining) {
        if (_currentSupply > MAX_SUPPLY - 1) {
            return 0;
        }
        return MAX_SUPPLY - _currentSupply;
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.MYTHIC;
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
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights with default values
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 0;
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 0;
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 0;
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 100; // Extremely rare
    }
}
