// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";
import {IHookRegistry} from "./IHookRegistry.sol";

/// @title IForgeCoordinator
/// @notice Interface for ForgeCoordinator contract
/// @author Solo Ascend Team
interface IForgeCoordinator {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the address is invalid
    error InvalidAddress();
    /// @notice Error thrown when the caller is not authorized
    error UnauthorizedCaller();
    /// @notice Error thrown when the request is not found
    error RequestNotFound();
    /// @notice Error thrown when the request is already fulfilled
    error RequestAlreadyFulfilled();
    /// @notice Error thrown when there are no available effect types
    error NoAvailableEffectTypes();
    /// @notice Error thrown when the forge parameters are invalid
    error InvalidForgeParameters();
    /// @notice Error thrown when the effect generation fails
    error EffectGenerationFailed();
    /// @notice Error thrown when the effect application fails
    error EffectApplicationFailed();
    /// @notice Error thrown when the forge item contract is not found
    error ForgeItemContractNotFound();
    /// @notice Error thrown when the forge item is invalid
    error InvalidForgeItem();
    /// @notice Error thrown when the hero contract is not set
    error HeroContractNotSet();
    /// @notice Error thrown when the function is not allowed at this time
    error NotAllowedAtThisTime();
    /// @notice Error thrown when the hero is not found
    error HeroNotFound();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Pending effect data for NFT hooks
    /// @param heroId Hero ID
    /// @param effect Effect data
    /// @param effectImplementation Effect implementation address
    struct PendingEffect {
        uint256 heroId;
        GameConstants.ForgeEffect effect;
        address effectImplementation;
    }

    /// @notice Forge request data
    /// @param heroId Hero being forged
    /// @param oracleId Oracle used for randomness
    /// @param totalForges Total forges at time of request
    /// @param randomSeed Random seed from oracle
    /// @param effectId Generated effect ID (if any)
    /// @param requester Address that initiated the forge
    /// @param requestTime When request was made
    /// @param fulfilled Whether request has been fulfilled
    struct ForgeRequest {
        uint256 heroId;
        uint256 oracleId;
        uint256 totalForges; // Total forges at time of request
        uint256 randomSeed; // Random seed from oracle
        uint256 effectId; // Generated effect ID (if any)
        address requester; // Address that initiated the forge
        uint64 requestTime; // When request was made
        bool fulfilled; // Whether request has been fulfilled
    }

    /// @notice Random request structure
    /// @param requester Who requested randomness
    /// @param requestTime When request was made
    /// @param heroId Associated hero ID
    /// @param requestId Oracle-specific request ID
    /// @param fulfilled Whether request is fulfilled
    /// @param randomSeed Resulting random seed
    struct RandomRequest {
        address requester; // Who requested randomness (20 bytes)
        uint64 requestTime; // When request was made (8 bytes)
        uint32 heroId; // Associated hero ID (4 bytes)
        // Total: 32 bytes (1 storage slot)
        bytes32 vrfRequestId; // Oracle-specific request ID
        bool fulfilled; // Whether request is fulfilled
        uint256 randomSeed; // Resulting random seed
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a forge item is created through the coordinator
    /// @param forgeContract The address of the forge contract that created the item
    /// @param tokenId The unique identifier of the created forge item
    /// @param recipient The address that received the forge item
    /// @param quality The quality level of the forge item
    /// @param effectType The type of forge effect
    event ForgeItemCreated(
        address indexed forgeContract,
        uint256 indexed tokenId,
        address indexed recipient,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType
    );

    /// @notice Emitted when a forge request is initiated
    /// @param requestId Unique identifier for the forge request
    /// @param heroId ID of the hero being forged
    /// @param requester Address that initiated the forge
    /// @param oracleId ID of the oracle used for randomness
    event ForgeInitiated(
        bytes32 indexed requestId,
        uint256 indexed heroId,
        address indexed requester,
        uint256 oracleId
    );

    /// @notice Emitted when a forge request is completed successfully
    /// @param requestId Unique identifier for the forge request
    /// @param heroId ID of the hero that was forged
    /// @param effectTypeId Type of effect that was generated
    /// @param effectId Unique ID of the generated effect instance
    /// @param quality Quality tier of the forge result
    event ForgeCompleted(
        bytes32 indexed requestId,
        uint256 indexed heroId,
        GameConstants.ForgeEffectType effectTypeId,
        uint256 effectId,
        GameConstants.ForgeQuality quality
    );

    /// @notice Emitted when forge quality is determined by the oracle
    /// @param requestId Unique identifier for the forge request
    /// @param quality Determined quality tier of the forge
    event ForgeQualityDetermined(bytes32 indexed requestId, GameConstants.ForgeQuality quality);

    /// @notice Emitted when treasury rewards are distributed
    /// @param recipient Address receiving the treasury reward
    /// @param amount Amount of reward distributed
    event TreasuryRewardDistributed(address indexed recipient, uint256 indexed amount);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get forge request data
    /// @param requestId Request ID
    /// @return request Forge request data
    function getForgeRequest(bytes32 requestId) external view returns (ForgeRequest memory request);

    /// @notice Get pending request for hero
    /// @param heroId Hero ID
    /// @return requestId Pending request ID (bytes32(0) if none)
    function getPendingRequest(uint256 heroId) external view returns (bytes32 requestId);

    /// @notice Check if hero has pending forge request
    /// @param heroId Hero ID
    /// @return hasPending Whether hero has pending request
    function hasPendingForge(uint256 heroId) external view returns (bool hasPending);

    /// @notice Calculate forge cost for hero using specific oracle
    /// @param heroId Hero ID (currently unused in calculation)
    /// @param oracleId Oracle ID
    /// @param gasLimit Gas limit for the request
    /// @return cost Total cost for forge
    function calculateForgeCost(uint256 heroId, uint256 oracleId, uint32 gasLimit) external view returns (uint256 cost);

    /// @notice Get hero's token-bound account address
    /// @param heroId Hero token ID
    /// @return Token-bound account address
    function getHeroTokenBoundAccount(uint256 heroId) external view returns (address);

    /// @notice Get hero ID by TBA account address
    /// @param account TBA account address
    /// @return heroId Hero ID (0 if not a TBA)
    function getHeroIdByAccount(address account) external view returns (uint256 heroId);

    /// @notice Set hero contract address
    /// @param newHeroContract Hero contract address
    function setHeroContract(address newHeroContract) external;

    /// @notice Handle forge item NFT updates (called from ForgeItemNFT._update)
    /// @param from Previous owner (address(0) for minting)
    /// @param to New owner (address(0) for burning)
    /// @param tokenId Forge item token ID
    /// @param effectType Effect type of the forge item
    function handleForgeItemUpdate(
        address from,
        address to,
        uint256 tokenId,
        GameConstants.ForgeEffectType effectType
    ) external;

    /// @notice Create and mint forge item (called by effect contracts)
    /// @param heroId Hero ID
    /// @param quality Forge quality
    /// @param effectType Effect type
    /// @param effectId Effect ID
    /// @return tokenId Minted token ID
    function mintForgeItem(
        uint256 heroId,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType,
        uint256 effectId
    ) external returns (uint256 tokenId);

    /// @notice Update all hero attributes at once (called by effect contracts)
    /// @param heroId Hero token ID
    /// @param value Value to add/set to all attributes
    /// @param isPercentage Whether value is percentage-based
    function increaseHeroAllAttributes(uint256 heroId, uint32 value, bool isPercentage) external;

    /// @notice Update hero stage (called by effect contracts)
    /// @param heroId Hero token ID
    /// @param newStage New hero stage
    function updateHeroStage(uint256 heroId, GameConstants.HeroStage newStage) external;

    /// @notice Distribute treasury rewards (called by effect contracts)
    /// @param recipient Reward recipient
    /// @param rewardBps Reward basis points (percentage of treasury)
    function distributeTreasuryReward(address recipient, uint256 rewardBps) external;

    /// @notice Trigger hook execution (called by effect contracts)
    /// @param phase Hook phase
    /// @param data Hook data
    function triggerHook(IHookRegistry.HookPhase phase, bytes calldata data) external;

    /// @notice Increase hero attribute (called by ForgeItemNFT for dynamic attribute changes)
    /// @param heroId Hero token ID
    /// @param attribute Attribute index (0-9)
    /// @param value Value to increase
    /// @param isPercentage Whether value is percentage-based
    function increaseHeroAttribute(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external;

    /// @notice Decrease hero attribute (called by ForgeItemNFT for dynamic attribute changes)
    /// @param heroId Hero token ID
    /// @param attribute Attribute index (0-9)
    /// @param value Value to decrease
    /// @param isPercentage Whether value is percentage-based
    function decreaseHeroAttribute(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external;

    /// @notice Initiate forge and request randomness (requestId generated internally)
    /// @param heroId Target hero id
    /// @param requester The address who initiated the forge
    /// @param oracleId Oracle id from registry
    /// @param gasLimit Gas limit for the request
    /// @return requestId Generated oracle request id
    function initiateForgeAndRequestAuto(
        uint256 heroId,
        address requester,
        uint256 oracleId,
        uint32 gasLimit
    ) external payable returns (bytes32 requestId);

    /// @notice Oracle fulfillment entry
    /// @param requestId Oracle request ID
    /// @param randomSeed Random seed from oracle
    /// @return effectTypeId Type id
    /// @return effectId Effect instance id
    /// @return newAttributes Updated hero attributes (if any)
    /// @return newStage Updated hero stage (if any)
    function fulfillForge(
        bytes32 requestId,
        uint256 randomSeed
    )
        external
        returns (
            GameConstants.ForgeEffectType effectTypeId,
            uint256 effectId,
            GameConstants.HeroAttributes memory newAttributes,
            GameConstants.HeroStage newStage
        );
}
