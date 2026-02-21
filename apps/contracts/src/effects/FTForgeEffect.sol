// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {ITreasury} from "../interfaces/ITreasury.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title FTForgeEffect
/// @notice Fungible Token reward forge effect - gives percentage of treasury funds
/// @author Solo Ascend Team
contract FTForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when reward percentage is too high
    error RewardPercentageTooHigh();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a token reward is claimed
    /// @param recipient The address that received the token reward
    /// @param amount The amount of tokens claimed
    /// @param quality The quality level that determined the reward percentage
    event TokenRewardClaimed(address indexed recipient, uint256 amount, GameConstants.ForgeQuality quality);

    /// @notice Emitted when the treasury contract is updated
    /// @param treasury The address of the new treasury contract
    event TreasurySet(address indexed treasury);

    /// @notice Emitted when reward percentage for a quality level is updated
    /// @param quality The quality level being updated
    /// @param newPercentage The new reward percentage in basis points
    event RewardPercentageUpdated(GameConstants.ForgeQuality indexed quality, uint256 newPercentage);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Token reward percentages by quality (in basis points)
    mapping(GameConstants.ForgeQuality => uint256) private _qualityRewardBps;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTANTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to the hero contract
    address public immutable HERO_CONTRACT;

    /// @notice Treasury contract reference
    ITreasury public immutable TREASURY;

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Minimum forges required to generate TOKEN effects
    uint256 public constant MIN_FORGES_REQUIRED = 0;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize FTForgeEffect
    /// @param admin Contract admin address
    /// @param treasuryAddress Treasury contract address
    /// @param heroContract Address of the hero contract
    /// @param forgeCoordinator Address of the forge coordinator
    constructor(address admin, address treasuryAddress, address heroContract, address forgeCoordinator) Ownable(admin) {
        if (treasuryAddress == address(0)) revert InvalidTreasury();
        if (heroContract == address(0)) revert InvalidHeroContract();
        if (forgeCoordinator == address(0)) revert InvalidCoordinator();

        TREASURY = ITreasury(payable(treasuryAddress));
        HERO_CONTRACT = heroContract;
        FORGE_COORDINATOR = IForgeCoordinator(forgeCoordinator);

        // Initialize quality reward bps
        _initializeQualityRewardBps();

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
        uint256 /* totalForges */
    ) external view returns (GameConstants.ForgeEffect memory effect) {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        // Get reward percentage for this quality
        uint256 rewardBps = _qualityRewardBps[quality];
        if (rewardBps == 0) revert InvalidQuality();

        // Add some randomness to the reward (±20% variation)
        uint256 variation = (randomSeed % 400) + 800; // 800-1200 (80%-120%)
        uint256 finalRewardBps = (rewardBps * variation) / 1000;

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.FT,
            quality: quality,
            attribute: GameConstants.HeroAttribute.HP, // Not used for token effects
            value: uint32(finalRewardBps), // Store reward percentage
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
        // Get the ForgeCoordinator from msg.sender
        IForgeCoordinator coordinator = IForgeCoordinator(msg.sender);

        // Get hero owner for reward distribution
        address heroOwner = IERC721(HERO_CONTRACT).ownerOf(heroId);

        // Distribute treasury reward based on effect value (basis points)
        coordinator.distributeTreasuryReward(heroOwner, effect.value);

        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Update reward percentage for a quality
    /// @param quality Forge quality
    /// @param rewardBps New reward percentage in basis points
    function setRewardPercentage(GameConstants.ForgeQuality quality, uint256 rewardBps) external onlyOwner {
        if (rewardBps > 1000) revert RewardPercentageTooHigh(); // Max 10%
        _qualityRewardBps[quality] = rewardBps;
        emit RewardPercentageUpdated(quality, rewardBps);
    }

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
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (bool available) {
        return getQualityWeight(quality) > 0;
    }

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view override returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @notice Get effect data
    /// @param effectId Effect ID
    /// @return effect Effect data
    function getEffect(uint256 effectId) external view returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.FT;
    }

    /// @notice Calculate potential reward for a quality
    /// @param quality Forge quality
    /// @return rewardAmount Potential reward amount
    function calculatePotentialReward(GameConstants.ForgeQuality quality) external view returns (uint256 rewardAmount) {
        uint256 rewardBps = _qualityRewardBps[quality];
        if (rewardBps == 0) return 0;

        uint256 treasuryBalance = address(TREASURY).balance;
        return (treasuryBalance * rewardBps) / 10_000;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights with default values
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 0;
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 20;
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 20;
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 0;
    }

    /// @notice Initialize default reward percentages (in basis points)
    function _initializeQualityRewardBps() internal {
        _qualityRewardBps[GameConstants.ForgeQuality.SILVER] = 0; // 0% - Silver does not generate token rewards
        _qualityRewardBps[GameConstants.ForgeQuality.GOLD] = 100; // 1% of treasury
        _qualityRewardBps[GameConstants.ForgeQuality.RAINBOW] = 300; // 3% of treasury
        _qualityRewardBps[GameConstants.ForgeQuality.MYTHIC] = 0; // 0% - Mythic does not generate token rewards
    }
}
