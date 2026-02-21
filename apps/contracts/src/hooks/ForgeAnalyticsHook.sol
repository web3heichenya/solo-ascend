// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/* solhint-disable use-natspec */

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IHookRegistry} from "../interfaces/IHookRegistry.sol";
import {GameConstants} from "../libraries/GameConstants.sol";
import {IHook} from "../interfaces/IHook.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title ForgeAnalyticsHook
/// @notice Hook implementation for collecting forge analytics and statistics
/// @author Solo Ascend Team
contract ForgeAnalyticsHook is IHook, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when forge analytics data is recorded
    /// @param user The address of the user who performed the forge
    /// @param heroId The ID of the hero that was forged
    /// @param quality The quality tier of the forge result
    /// @param effectType The type of effect that was generated
    /// @param oracleId The ID of the oracle used for the forge
    event ForgeAnalyticsRecorded(
        address indexed user,
        uint256 indexed heroId,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType,
        uint256 oracleId
    );

    /// @notice Emitted when daily statistics are updated
    /// @param day The day (as timestamp / 1 days) for which stats were updated
    /// @param totalForges The total number of forges for that day
    event DailyStatsUpdated(uint256 indexed day, uint256 indexed totalForges);

    /// @notice Emitted when a user reaches a forge milestone
    /// @param user The address of the user who reached the milestone
    /// @param milestone The milestone number that was reached
    /// @param timestamp The timestamp when the milestone was reached
    event MilestoneReached(address indexed user, uint256 indexed milestone, uint256 indexed timestamp);

    /// @notice Emitted when a forge is completed and recorded
    /// @param user The address of the user who completed the forge
    /// @param heroId The ID of the hero that was forged
    /// @param quality The quality tier of the forge result
    /// @param effectType The type of effect that was generated
    event ForgeCompleted(
        address indexed user,
        uint256 indexed heroId,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType
    );

    /// @notice Emitted when a hero minting is recorded
    /// @param minter The address of the user who minted the hero
    /// @param tokenId The ID of the minted hero
    /// @param classId The class ID of the hero
    /// @param tokenBoundAccount The token bound account address
    event HeroMintingRecorded(
        address indexed minter,
        uint256 indexed tokenId,
        GameConstants.HeroClass classId,
        address tokenBoundAccount
    );

    /// @notice Emitted when forge initiation is recorded
    /// @param requester The address that requested the forge
    /// @param heroId The ID of the hero being forged
    /// @param oracleId The ID of the oracle used
    /// @param requestId The forge request ID
    event ForgeInitiationRecorded(
        address indexed requester,
        uint256 indexed heroId,
        uint256 oracleId,
        bytes32 requestId
    );

    /// @notice Emitted when hero stage change is recorded
    /// @param heroId The ID of the hero whose stage changed
    /// @param newStage The new stage of the hero
    event HeroStageChangeRecorded(uint256 indexed heroId, GameConstants.HeroStage newStage);

    /// @notice Emitted when hero attribute update is recorded
    /// @param heroId The ID of the hero whose attributes were updated
    /// @param attributes The new attributes
    event HeroAttributeUpdateRecorded(uint256 indexed heroId, GameConstants.HeroAttributes attributes);

    /// @notice Emitted when effect generation is recorded
    /// @param from From address
    /// @param to To address
    /// @param tokenId The token ID
    /// @param effectType The effect type
    event EffectGenerationRecorded(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId,
        uint256 effectType
    );
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Daily statistics
    /// @param totalForges Total number of forges for that day
    /// @param uniqueForgers Total number of unique forgers for that day
    /// @param totalRewardsDistributed Total number of rewards distributed for that day
    /// @param qualityCount Quality distribution for that day

    struct DailyStats {
        uint256 totalForges;
        uint256 uniqueForgers;
        uint256 totalRewardsDistributed;
        mapping(GameConstants.ForgeQuality => uint256) qualityCount;
    }

    /// @notice Total statistics
    /// @param totalForges Total number of forges performed
    /// @param totalUsers Total number of unique users
    /// @param totalRewardsDistributed Total number of rewards distributed
    /// @param lastUpdateTime Timestamp of the last update
    struct Stats {
        uint256 totalForges;
        uint256 totalUsers;
        uint256 totalRewardsDistributed;
        uint256 lastUpdateTime;
    }

    /// @notice User statistics
    /// @param totalForges Total number of forges performed
    /// @param firstForgeTime Timestamp of the first forge
    /// @param lastForgeTime Timestamp of the last forge
    /// @param qualityBreakdown Quality distribution
    /// @param effectTypeBreakdown Effect type distribution
    struct UserStats {
        uint256 totalForges;
        uint256 firstForgeTime;
        uint256 lastForgeTime;
        mapping(GameConstants.ForgeQuality => uint256) qualityBreakdown;
        mapping(GameConstants.ForgeEffectType => uint256) effectTypeBreakdown;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Total statistics
    Stats private _totalStats;

    /// @notice Total forges by quality
    mapping(GameConstants.ForgeQuality => uint256) public forgesByQuality;

    /// @notice Total forges by effect type
    mapping(GameConstants.ForgeEffectType => uint256) public forgesByEffectType;

    /// @notice Total forges by oracle
    mapping(uint256 => uint256) public forgesByOracle;

    /// @notice Forge count by user
    mapping(address => uint256) public userForgeCount;

    /// @notice Quality distribution by user
    mapping(address => mapping(GameConstants.ForgeQuality => uint256)) public userQualityStats;

    /// @notice Daily forge statistics
    mapping(uint256 => DailyStats) public dailyStats;

    /// @notice Detailed user statistics
    mapping(address => UserStats) private _userStats;

    /// @notice User milestones tracking
    mapping(address => mapping(uint256 => bool)) public userMilestones;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to the hero contract for owner lookups
    address public immutable HERO_CONTRACT;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the ForgeAnalyticsHook
    /// @param admin The address that will be granted owner privileges
    /// @param heroContract The address of the hero contract
    constructor(address admin, address heroContract) Ownable(admin) {
        if (heroContract == address(0)) revert InvalidHeroContract();
        HERO_CONTRACT = heroContract;
        _totalStats.lastUpdateTime = block.timestamp;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHook
    function executeHook(IHookRegistry.HookPhase phase, bytes calldata data) external returns (bool success) {
        if (phase == IHookRegistry.HookPhase.BEFORE_HERO_MINTING) {
            return _recordHeroMintingStart(data);
        } else if (phase == IHookRegistry.HookPhase.AFTER_HERO_MINTED) {
            return _recordHeroMinted(data);
        } else if (phase == IHookRegistry.HookPhase.BEFORE_EFFECT_GENERATION) {
            return _recordEffectGenerationStart(data);
        } else if (phase == IHookRegistry.HookPhase.AFTER_EFFECT_GENERATED) {
            return _recordEffectGenerated(data);
        } else if (phase == IHookRegistry.HookPhase.FORGE_INITIATION) {
            return _recordForgeInitiation(data);
        } else if (phase == IHookRegistry.HookPhase.HERO_STAGE_CHANGED) {
            return _recordHeroStageChanged(data);
        } else if (phase == IHookRegistry.HookPhase.HERO_ATTRIBUTE_UPDATED) {
            return _recordHeroAttributeUpdated(data);
        }
        return true;
    }

    /// @notice Helper to decode effect generation data (full format)
    /// @param data Encoded effect generation data
    /// @return effectTypeId The type ID of the effect
    /// @return qualityInt The quality as integer
    /// @return requester The address that requested the forge
    /// @return effectId The ID of the generated effect
    /// @return heroId The ID of the hero
    function decodeEffectGenerationData(
        bytes calldata data
    )
        external
        pure
        returns (uint256 effectTypeId, uint256 qualityInt, address requester, uint256 effectId, uint256 heroId)
    {
        (effectTypeId, qualityInt, requester, effectId, heroId) = abi.decode(
            data,
            (uint256, uint256, address, uint256, uint256)
        );
    }

    /// @notice Helper to decode simple effect data
    /// @param data Encoded simple effect data
    /// @return effectType The effect type
    /// @return from From address
    /// @return to To address
    /// @return tokenId The token ID
    function decodeSimpleEffectData(
        bytes calldata data
    ) external pure returns (uint256 effectType, address from, address to, uint256 tokenId) {
        (effectType, from, to, tokenId) = abi.decode(data, (uint256, address, address, uint256));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reset statistics (emergency function)
    function resetStats() external onlyOwner {
        // Reset quality stats
        for (uint256 i = 0; i < uint256(GameConstants.ForgeQuality.MYTHIC) + 1; ++i) {
            forgesByQuality[GameConstants.ForgeQuality(i)] = 0;
        }

        // Reset effect type stats
        for (uint256 i = 0; i < uint256(GameConstants.ForgeEffectType.NFT) + 1; ++i) {
            forgesByEffectType[GameConstants.ForgeEffectType(i)] = 0;
        }

        // Reset total stats
        _totalStats.totalForges = 0;
        _totalStats.totalUsers = 0;
        _totalStats.lastUpdateTime = block.timestamp;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHook
    function getHookInfo() external pure returns (string memory name, string memory version) {
        return ("ForgeAnalyticsHook", "1.0.0");
    }

    /// @notice Get comprehensive forge statistics
    /// @return totalForges Total number of forges performed
    /// @return totalUsers Total number of unique users
    /// @return qualityDistribution Distribution of forge qualities
    /// @return effectTypeDistribution Distribution of effect types
    function getComprehensiveStats()
        external
        view
        returns (
            uint256 totalForges,
            uint256 totalUsers,
            uint256[4] memory qualityDistribution,
            uint256[6] memory effectTypeDistribution
        )
    {
        totalForges = _totalStats.totalForges;
        totalUsers = _totalStats.totalUsers;

        qualityDistribution[0] = forgesByQuality[GameConstants.ForgeQuality.SILVER];
        qualityDistribution[1] = forgesByQuality[GameConstants.ForgeQuality.GOLD];
        qualityDistribution[2] = forgesByQuality[GameConstants.ForgeQuality.RAINBOW];
        qualityDistribution[3] = forgesByQuality[GameConstants.ForgeQuality.MYTHIC];

        effectTypeDistribution[0] = forgesByEffectType[GameConstants.ForgeEffectType.ATTRIBUTE];
        effectTypeDistribution[1] = forgesByEffectType[GameConstants.ForgeEffectType.AMPLIFY];
        effectTypeDistribution[2] = forgesByEffectType[GameConstants.ForgeEffectType.MYTHIC];
        effectTypeDistribution[3] = forgesByEffectType[GameConstants.ForgeEffectType.ENHANCE];
        effectTypeDistribution[4] = forgesByEffectType[GameConstants.ForgeEffectType.FT];
        effectTypeDistribution[5] = forgesByEffectType[GameConstants.ForgeEffectType.NFT];
    }

    /// @notice Get daily statistics for a specific day
    /// @param day Day timestamp (in days since epoch)
    /// @return totalForges Total forges for the day
    /// @return qualityBreakdown Quality distribution for the day
    function getDailyStats(
        uint256 day
    ) external view returns (uint256 totalForges, uint256[4] memory qualityBreakdown) {
        totalForges = dailyStats[day].totalForges;

        qualityBreakdown[0] = dailyStats[day].qualityCount[GameConstants.ForgeQuality.SILVER];
        qualityBreakdown[1] = dailyStats[day].qualityCount[GameConstants.ForgeQuality.GOLD];
        qualityBreakdown[2] = dailyStats[day].qualityCount[GameConstants.ForgeQuality.RAINBOW];
        qualityBreakdown[3] = dailyStats[day].qualityCount[GameConstants.ForgeQuality.MYTHIC];
    }

    /// @notice Get user-specific statistics with quality and effect breakdowns
    /// @param user User address
    /// @return totalForges User's total forge count
    /// @return firstForgeTime Timestamp of user's first forge
    /// @return lastForgeTime Timestamp of user's last forge
    /// @return qualityBreakdown User's quality distribution [SILVER, GOLD, RAINBOW, MYTHIC]
    /// @return effectTypeBreakdown User's effect type distribution
    function getUserStats(
        address user
    )
        external
        view
        returns (
            uint256 totalForges,
            uint256 firstForgeTime,
            uint256 lastForgeTime,
            uint256[4] memory qualityBreakdown,
            uint256[6] memory effectTypeBreakdown
        )
    {
        totalForges = _userStats[user].totalForges;
        firstForgeTime = _userStats[user].firstForgeTime;
        lastForgeTime = _userStats[user].lastForgeTime;

        // Fill quality breakdown
        qualityBreakdown[0] = _userStats[user].qualityBreakdown[GameConstants.ForgeQuality.SILVER];
        qualityBreakdown[1] = _userStats[user].qualityBreakdown[GameConstants.ForgeQuality.GOLD];
        qualityBreakdown[2] = _userStats[user].qualityBreakdown[GameConstants.ForgeQuality.RAINBOW];
        qualityBreakdown[3] = _userStats[user].qualityBreakdown[GameConstants.ForgeQuality.MYTHIC];

        // Fill effect type breakdown
        effectTypeBreakdown[0] = _userStats[user].effectTypeBreakdown[GameConstants.ForgeEffectType.ATTRIBUTE];
        effectTypeBreakdown[1] = _userStats[user].effectTypeBreakdown[GameConstants.ForgeEffectType.AMPLIFY];
        effectTypeBreakdown[2] = _userStats[user].effectTypeBreakdown[GameConstants.ForgeEffectType.MYTHIC];
        // Note: indices 3-5 reserved for future effect types
    }

    /// @notice Get quality success rate
    /// @param quality Quality to check
    /// @return rate Success rate in basis points (10000 = 100%)
    function getQualityRate(GameConstants.ForgeQuality quality) external view returns (uint256 rate) {
        if (_totalStats.totalForges == 0) return 0;
        return (forgesByQuality[quality] * 10_000) / _totalStats.totalForges;
    }

    /// @notice Get total number of forges
    /// @return The total number of forges performed
    function getTotalForges() external view returns (uint256) {
        return _totalStats.totalForges;
    }

    /// @notice Get total number of unique users
    /// @return The total number of unique users
    function getTotalUsers() external view returns (uint256) {
        return _totalStats.totalUsers;
    }

    /// @notice Get count for a specific quality
    /// @param quality The forge quality to check
    /// @return The number of forges for this quality
    function getQualityCount(GameConstants.ForgeQuality quality) external view returns (uint256) {
        return forgesByQuality[quality];
    }

    /// @notice Get count for a specific effect type
    /// @param effectType The forge effect type to check
    /// @return The number of forges for this effect type
    function getEffectTypeCount(GameConstants.ForgeEffectType effectType) external view returns (uint256) {
        return forgesByEffectType[effectType];
    }

    /// @notice Check if user has reached a milestone
    /// @param user The user address to check
    /// @param milestone The milestone number to check
    /// @return Whether the user has reached this milestone
    function hasMilestone(address user, uint256 milestone) external view returns (bool) {
        return userMilestones[user][milestone];
    }

    /// @notice Get the owner of a hero
    /// @param heroId The hero ID to query
    /// @return owner The owner address
    function getHeroOwner(uint256 heroId) public view returns (address) {
        address owner = IERC721(HERO_CONTRACT).ownerOf(heroId);

        return owner;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Record hero minting start
    /// @return success Always returns true
    function _recordHeroMintingStart(bytes calldata /* data */) internal pure returns (bool success) {
        // Could track minting metrics if needed
        return true;
    }

    /// @notice Record hero minted
    /// @param data Encoded data: abi.encode(tokenId, classId, msg.sender, tokenBoundAccount)
    /// @return success Always returns true
    function _recordHeroMinted(bytes calldata data) internal returns (bool success) {
        (uint256 tokenId, GameConstants.HeroClass classId, address minter, address tokenBoundAccount) = abi.decode(
            data,
            (uint256, GameConstants.HeroClass, address, address)
        );

        // Track hero minting statistics
        emit HeroMintingRecorded(minter, tokenId, classId, tokenBoundAccount);
        return true;
    }

    /// @notice Record effect generation start
    /// @return success Always returns true
    function _recordEffectGenerationStart(bytes calldata /* data */) internal pure returns (bool success) {
        // Could track effect generation initiation metrics if needed
        return true;
    }

    /// @notice Record effect generated
    /// @param data Encoded data: either (uint256, address, address, uint256) or (uint256, uint256, address, uint256, uint256)
    /// @return success Always returns true
    function _recordEffectGenerated(bytes calldata data) internal returns (bool success) {
        // Try to decode the full forge completion format first
        try this.decodeEffectGenerationData(data) returns (
            uint256 effectTypeId,
            uint256 qualityInt,
            address requester,
            uint256,
            /* effectId */
            uint256 heroId
        ) {
            GameConstants.ForgeQuality quality = GameConstants.ForgeQuality(qualityInt);
            GameConstants.ForgeEffectType effectType = GameConstants.ForgeEffectType(effectTypeId);

            // Update comprehensive stats for full forge completion
            _updateMinimalStats(requester, quality, effectType);

            emit ForgeAnalyticsRecorded(requester, heroId, quality, effectType, 0);
            emit ForgeCompleted(requester, heroId, quality, effectType);

            return true;
        } catch {
            // Try to decode the simpler format: (effectType, from, to, tokenId)
            try this.decodeSimpleEffectData(data) returns (
                uint256 effectType,
                address from,
                address to,
                uint256 tokenId
            ) {
                // Just emit basic event for simple effect generation
                emit EffectGenerationRecorded(from, to, tokenId, effectType);
                return true;
            } catch {
                // If both fail, still return success to not break the hook chain
                return true;
            }
        }
    }

    /// @notice Record forge initiation statistics
    /// @param data Encoded data: abi.encode(requestId, heroId, oracleId, requester)
    /// @return success Always returns true
    function _recordForgeInitiation(bytes calldata data) internal returns (bool success) {
        (bytes32 requestId, uint256 heroId, uint256 oracleId, address requester) = abi.decode(
            data,
            (bytes32, uint256, uint256, address)
        );

        emit ForgeInitiationRecorded(requester, heroId, oracleId, requestId);
        return true;
    }

    /// @notice Record hero stage changed
    /// @param data Encoded data: abi.encode(heroId, newStage)
    /// @return success Always returns true
    function _recordHeroStageChanged(bytes calldata data) internal returns (bool success) {
        (uint256 heroId, GameConstants.HeroStage newStage) = abi.decode(data, (uint256, GameConstants.HeroStage));

        emit HeroStageChangeRecorded(heroId, newStage);
        return true;
    }

    /// @notice Record hero attribute updated
    /// @param data Encoded data: abi.encode(heroId, attributes)
    /// @return success Always returns true
    function _recordHeroAttributeUpdated(bytes calldata data) internal returns (bool success) {
        (uint256 heroId, GameConstants.HeroAttributes memory attributes) = abi.decode(
            data,
            (uint256, GameConstants.HeroAttributes)
        );

        emit HeroAttributeUpdateRecorded(heroId, attributes);
        return true;
    }

    /// @notice Update user-specific statistics
    /// @param user User address
    /// @param quality Forge quality
    /// @param effectType Effect type
    function _updateUserStats(
        address user,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType
    ) internal {
        // Initialize user if first forge
        if (userForgeCount[user] == 0) {
            ++_totalStats.totalUsers;
            _userStats[user].firstForgeTime = block.timestamp;
        }

        // Update counters
        ++userForgeCount[user];
        ++userQualityStats[user][quality];

        // Update detailed stats
        ++_userStats[user].totalForges;
        _userStats[user].lastForgeTime = block.timestamp;
        ++_userStats[user].qualityBreakdown[quality];
        ++_userStats[user].effectTypeBreakdown[effectType];
    }

    /// @notice Update global statistics
    /// @param quality Forge quality
    /// @param effectType Effect type
    function _updateGlobalStats(GameConstants.ForgeQuality quality, GameConstants.ForgeEffectType effectType) internal {
        ++forgesByQuality[quality];
        ++forgesByEffectType[effectType];
        ++_totalStats.totalForges;
        _totalStats.lastUpdateTime = block.timestamp;
    }

    /// @notice Check and update user milestones
    /// @param user User address to check milestones for
    function _checkAndUpdateMilestones(address user) internal {
        uint256 userForges = _userStats[user].totalForges;
        uint256[6] memory milestones = [uint256(1), 5, 10, 25, 50, 100];

        for (uint256 i = 0; i < milestones.length; ++i) {
            uint256 milestone = milestones[i];
            if (userForges == milestone && !userMilestones[user][milestone]) {
                userMilestones[user][milestone] = true;
                emit MilestoneReached(user, milestone, block.timestamp);
                break; // Only emit one milestone per transaction
            }
        }
    }

    /// @notice Update daily statistics
    /// @param quality Forge quality to record
    function _updateDailyStats(GameConstants.ForgeQuality quality) internal {
        uint256 today = block.timestamp / 1 days;
        ++dailyStats[today].totalForges;
        ++dailyStats[today].qualityCount[quality];
    }

    /// @notice Update minimal statistics to reduce gas usage
    /// @param user User address
    /// @param quality Forge quality
    /// @param effectType Effect type
    function _updateMinimalStats(
        address user,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType
    ) internal {
        // Initialize user if first forge
        if (userForgeCount[user] == 0) {
            ++_totalStats.totalUsers;
            _userStats[user].firstForgeTime = block.timestamp;
        }

        // Update essential counters
        ++userForgeCount[user];
        ++_totalStats.totalForges;
        ++forgesByQuality[quality];
        ++forgesByEffectType[effectType];

        // Update minimal user stats for getUserStats compatibility
        ++_userStats[user].totalForges;
        _userStats[user].lastForgeTime = block.timestamp;
        ++_userStats[user].qualityBreakdown[quality];
        ++_userStats[user].effectTypeBreakdown[effectType];

        // Check milestones (only for the first few to avoid gas issues)
        uint256 userForges = _userStats[user].totalForges;
        if (userForges == 1 || userForges == 5 || userForges == 10) {
            if (!userMilestones[user][userForges]) {
                userMilestones[user][userForges] = true;
                emit MilestoneReached(user, userForges, block.timestamp);
            }
        }
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                    USAGE EXAMPLE                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

/**
 * DEPLOYMENT AND USAGE:
 *
 * 1. Deploy ForgeAnalyticsHook
 * 2. Register with HookRegistry for all desired phases:
 *    // Hero lifecycle hooks
 *    hookRegistry.registerHook(HookPhase.BEFORE_HERO_MINTING, analyticsHookAddress, 1, 50000);
 *    hookRegistry.registerHook(HookPhase.AFTER_HERO_MINTED, analyticsHookAddress, 1, 100000);
 *    hookRegistry.registerHook(HookPhase.HERO_STAGE_CHANGED, analyticsHookAddress, 1, 75000);
 *    hookRegistry.registerHook(HookPhase.HERO_ATTRIBUTE_UPDATED, analyticsHookAddress, 1, 100000);
 *
 *    // Forge lifecycle hooks
 *    hookRegistry.registerHook(HookPhase.FORGE_INITIATION, analyticsHookAddress, 1, 100000);
 *    hookRegistry.registerHook(HookPhase.BEFORE_EFFECT_GENERATION, analyticsHookAddress, 1, 50000);
 *    hookRegistry.registerHook(HookPhase.AFTER_EFFECT_GENERATED, analyticsHookAddress, 1, 150000);
 *
 * 3. Analytics will be automatically collected during forging
 * 4. Query statistics using view functions:
 *    - getComprehensiveStats()
 *    - getDailyStats(today)
 *    - getUserStats(userAddress)
 *    - getQualityRate(GameConstants.ForgeQuality.MYTHIC)
 *
 * BENEFITS:
 * - Zero modification to core contracts
 * - Real-time analytics collection
 * - Flexible querying capabilities
 * - Can be disabled/upgraded independently
 * - Minimal gas overhead (isolated execution)
 */
