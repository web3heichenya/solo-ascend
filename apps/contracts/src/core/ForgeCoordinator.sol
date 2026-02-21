// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {LibPRNG} from "solady/utils/LibPRNG.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {IHookRegistry} from "../interfaces/IHookRegistry.sol";
import {ISoloAscendHero} from "../interfaces/ISoloAscendHero.sol";
import {GameConstants} from "../libraries/GameConstants.sol";
import {IForgeEffectRegistry} from "../interfaces/IForgeEffectRegistry.sol";
import {IForgeItemRegistry} from "../interfaces/IForgeItemRegistry.sol";
import {IForgeItemNFT} from "../interfaces/IForgeItemNFT.sol";
import {IOracleRegistry} from "../interfaces/IOracleRegistry.sol";
import {IOracle} from "../interfaces/IOracle.sol";
import {ITreasury} from "../interfaces/ITreasury.sol";

/// @title ForgeCoordinator
/// @notice Coordinates the complete forging process from randomness to effect application.
/// @author Solo Ascend Team
contract ForgeCoordinator is Ownable, ReentrancyGuard, IForgeCoordinator {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          LIBRARIES                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    using LibPRNG for LibPRNG.PRNG;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Hero contract address (authorized to initiate forging).
    address private _heroContract;

    /// @notice Nonce for request id generation.
    uint256 private _requestNonce;

    /// @notice Mapping from request ID to forge request data.
    mapping(bytes32 => ForgeRequest) private _forgeRequests;

    /// @notice Mapping from hero ID to pending request ID.
    mapping(uint256 => bytes32) private _heroToPendingRequest;

    /// @notice Mapping from effect ID to pending effect data.
    mapping(uint256 => PendingEffect) private _pendingEffects;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge effect registry.
    IForgeEffectRegistry public immutable FORGE_EFFECT_REGISTRY;

    /// @notice Reference to forge item registry.
    IForgeItemRegistry public immutable FORGE_ITEM_REGISTRY;

    /// @notice Reference to oracle registry.
    IOracleRegistry public immutable ORACLE_REGISTRY;

    /// @notice Reference to hook registry.
    IHookRegistry public immutable HOOK_REGISTRY;

    /// @notice Reference to treasury.
    ITreasury public immutable TREASURY;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Modifier to ensure only the hero contract can call the function.
    modifier onlyHeroContract() {
        if (msg.sender != _heroContract) revert UnauthorizedCaller();
        _;
    }

    /// @notice Modifier to ensure only authorized forge effects can call the function.
    modifier onlyAuthorizedEffect() {
        bool isAuthorized = FORGE_EFFECT_REGISTRY.isAuthorizedForgeEffect(msg.sender);
        if (!isAuthorized) revert UnauthorizedCaller();
        _;
    }

    /// @notice Modifier to ensure only authorized forge item contracts can call the function.
    modifier onlyAuthorizedForgeItem() {
        bool isAuthorized = FORGE_ITEM_REGISTRY.isAuthorizedForgeItem(msg.sender);
        if (!isAuthorized) revert UnauthorizedCaller();
        _;
    }

    /// @notice Modifier to ensure only authorized oracles can call the function.
    modifier onlyAuthorizedOracle(bytes32 requestId) {
        ForgeRequest storage request = _forgeRequests[requestId];
        if (request.heroId == 0) revert RequestNotFound();

        // Allow calls from authorized oracle or hero contract
        bool isAuthorized = ORACLE_REGISTRY.isAuthorizedOracle(msg.sender);
        if (!isAuthorized && msg.sender != _heroContract) {
            revert UnauthorizedCaller();
        }
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize ForgeCoordinator with required dependencies
    /// @param admin Admin address for ownership
    /// @param forgeEffectRegistry Forge effect registry address
    /// @param forgeItemRegistry Forge item registry address
    /// @param oracleRegistry Oracle registry address
    /// @param hookRegistry Hook registry address
    /// @param treasury Treasury address
    constructor(
        address admin,
        address forgeEffectRegistry,
        address forgeItemRegistry,
        address oracleRegistry,
        address hookRegistry,
        address treasury
    ) Ownable(admin) {
        if (forgeEffectRegistry == address(0)) revert InvalidAddress();
        if (forgeItemRegistry == address(0)) revert InvalidAddress();
        if (oracleRegistry == address(0)) revert InvalidAddress();
        if (hookRegistry == address(0)) revert InvalidAddress();
        if (treasury == address(0)) revert InvalidAddress();

        FORGE_EFFECT_REGISTRY = IForgeEffectRegistry(forgeEffectRegistry);
        FORGE_ITEM_REGISTRY = IForgeItemRegistry(forgeItemRegistry);
        ORACLE_REGISTRY = IOracleRegistry(oracleRegistry);
        TREASURY = ITreasury(payable(treasury));
        HOOK_REGISTRY = IHookRegistry(hookRegistry);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeCoordinator
    function initiateForgeAndRequestAuto(
        uint256 heroId,
        address requester,
        uint256 oracleId,
        uint32 gasLimit
    ) external payable onlyHeroContract returns (bytes32 requestId) {
        // validate
        if (!ORACLE_REGISTRY.isOracleRegistered(oracleId)) revert InvalidForgeParameters();
        // generate request id
        unchecked {
            requestId = keccak256(abi.encode(address(this), block.chainid, block.timestamp, heroId, ++_requestNonce));
        }
        // get hero's current forge count
        GameConstants.Hero memory hero = ISoloAscendHero(_heroContract).getHero(heroId);

        // create forge request record
        _forgeRequests[requestId] = ForgeRequest({
            heroId: heroId,
            requester: requester,
            oracleId: oracleId,
            totalForges: hero.totalForges,
            requestTime: uint64(block.timestamp),
            fulfilled: false,
            randomSeed: 0,
            effectId: 0
        });
        _heroToPendingRequest[heroId] = requestId;
        emit ForgeInitiated(requestId, heroId, requester, oracleId);

        // forward randomness request
        address oracleImpl = ORACLE_REGISTRY.getOracleImplementation(oracleId);
        IOracle(oracleImpl).requestRandomness{value: msg.value}(requestId, heroId, requester, gasLimit);

        // Execute forge initiation hook
        _executeHook(IHookRegistry.HookPhase.FORGE_INITIATION, abi.encode(requestId, heroId, oracleId, requester));
    }

    /// @inheritdoc IForgeCoordinator
    function fulfillForge(
        bytes32 requestId,
        uint256 randomSeed
    )
        external
        onlyAuthorizedOracle(requestId)
        nonReentrant
        returns (
            GameConstants.ForgeEffectType effectTypeId,
            uint256 effectId,
            GameConstants.HeroAttributes memory newAttributes,
            GameConstants.HeroStage newStage
        )
    {
        ForgeRequest storage request = _forgeRequests[requestId];
        _validateAndUpdateRequest(request, randomSeed);

        // Clear pending request
        delete _heroToPendingRequest[request.heroId];

        // Step 1: Determine forge quality based on randomness
        GameConstants.ForgeQuality quality = _processForgeQuality(requestId, request, randomSeed);

        // Step 2: Randomly select forge effect type based on quality
        (effectTypeId, effectId) = _generateForgeEffect(requestId, request, quality, randomSeed);

        // Step 3: Mint corresponding forge item NFT
        // Step 4: Call _update hook in NFT contract to trigger ForgeCoordinator
        // Step 5: ForgeCoordinator executes effect logic and updates hero attributes/stage
        // (These steps happen in _generateForgeEffect and the NFT _update hook)

        // Return default values - actual updates handled via hooks
        return (effectTypeId, effectId, newAttributes, newStage);
    }

    /// @notice Fulfill forge request with retry logic (When oracle fails to fulfill)
    /// @param requestId The request ID to fulfill
    /// @return effectTypeId The effect type ID
    /// @return effectId The effect ID
    /// @return newAttributes The new attributes
    /// @return newStage The new stage
    function fulfillForgeManually(
        bytes32 requestId
    )
        external
        nonReentrant
        returns (
            GameConstants.ForgeEffectType effectTypeId,
            uint256 effectId,
            GameConstants.HeroAttributes memory newAttributes,
            GameConstants.HeroStage newStage
        )
    {
        ForgeRequest storage request = _forgeRequests[requestId];
        if (msg.sender != request.requester) revert UnauthorizedCaller();
        if (block.timestamp < request.requestTime + 2 hours) revert NotAllowedAtThisTime();

        // generate pseudo-random seed
        uint256 enhancedRandomSeed = uint256(keccak256(abi.encode(requestId, block.timestamp, block.prevrandao)));

        _validateAndUpdateRequest(request, enhancedRandomSeed);

        // Clear pending request
        delete _heroToPendingRequest[request.heroId];

        // Execute before quality determination hook
        _executeHook(
            IHookRegistry.HookPhase.BEFORE_EFFECT_GENERATION,
            abi.encode(requestId, request.heroId, request.oracleId, enhancedRandomSeed)
        );
        // determine forge quality, if oracleId > 1 (Not free oracle), then it's gold quality
        GameConstants.ForgeQuality quality = GameConstants.ForgeQuality.SILVER;
        if (1 < request.oracleId) {
            quality = GameConstants.ForgeQuality.GOLD;
        }
        emit ForgeQualityDetermined(requestId, quality);

        // generate forge effect
        (effectTypeId, effectId) = _generateForgeEffect(requestId, request, quality, enhancedRandomSeed);

        // Return default values - actual updates handled via hooks
        return (effectTypeId, effectId, newAttributes, newStage);
    }

    /// @inheritdoc IForgeCoordinator
    function handleForgeItemUpdate(
        address from,
        address to,
        uint256 tokenId,
        GameConstants.ForgeEffectType effectType
    ) external onlyAuthorizedForgeItem {
        // Mint: Mint has handled when forge is fulfilled
        if (from == address(0) && to != address(0)) {
            return;
        }
        // Burn: Handle forge item burning
        if (from != address(0) && to == address(0)) {
            _handleForgeItemBurning(from, tokenId, effectType);
        }
        // Transfer: Handle dynamic attribute updates
        if (from != address(0) && to != address(0)) {
            _handleForgeItemTransfer(from, to, tokenId, effectType);
        }
    }

    /// @inheritdoc IForgeCoordinator
    function distributeTreasuryReward(address recipient, uint256 rewardBps) external onlyAuthorizedEffect {
        ITreasury(TREASURY).distributeReward(recipient, rewardBps);
    }

    /// @inheritdoc IForgeCoordinator
    function triggerHook(IHookRegistry.HookPhase phase, bytes calldata data) external onlyAuthorizedEffect {
        _executeHook(phase, data);
    }

    /// @inheritdoc IForgeCoordinator
    function increaseHeroAttribute(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external onlyAuthorizedEffect {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        ISoloAscendHero(_heroContract).increaseHeroAttributeFromCoordinator(heroId, attribute, value, isPercentage);
    }

    /// @inheritdoc IForgeCoordinator
    function decreaseHeroAttribute(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external onlyAuthorizedEffect {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        ISoloAscendHero(_heroContract).decreaseHeroAttributeFromCoordinator(heroId, attribute, value, isPercentage);
    }

    /// @inheritdoc IForgeCoordinator
    function increaseHeroAllAttributes(uint256 heroId, uint32 value, bool isPercentage) external onlyAuthorizedEffect {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        ISoloAscendHero(_heroContract).increaseHeroAllAttributesFromCoordinator(heroId, value, isPercentage);
    }

    /// @inheritdoc IForgeCoordinator
    function updateHeroStage(uint256 heroId, GameConstants.HeroStage newStage) external onlyAuthorizedEffect {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        ISoloAscendHero(_heroContract).updateHeroStageFromCoordinator(heroId, newStage);
    }

    /// @inheritdoc IForgeCoordinator
    function mintForgeItem(
        uint256 heroId,
        GameConstants.ForgeQuality quality,
        GameConstants.ForgeEffectType effectType,
        uint256 effectId
    ) external onlyAuthorizedEffect returns (uint256 tokenId) {
        address effectImplementation = FORGE_EFFECT_REGISTRY.getEffectImplementation(effectType);
        if (effectImplementation == address(0)) revert ForgeItemContractNotFound();
        if (heroId == 0) revert HeroNotFound();

        GameConstants.Hero memory hero = ISoloAscendHero(_heroContract).getHero(heroId);
        GameConstants.ForgeEffect memory effect = IForgeEffect(effectImplementation).generateEffect(
            effectId,
            quality,
            hero.totalForges
        );

        tokenId = _mintForgeItemNFT(heroId, effect, effectId);
        _callEffectContract(effectImplementation, heroId, effect, effectId);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeCoordinator
    function setHeroContract(address newHeroContract) external onlyOwner {
        _heroContract = newHeroContract;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeCoordinator
    function getHeroTokenBoundAccount(uint256 heroId) external view returns (address) {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        return ISoloAscendHero(_heroContract).getTokenBoundAccount(heroId);
    }

    /// @inheritdoc IForgeCoordinator
    function getHeroIdByAccount(address account) external view returns (uint256 heroId) {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        return ISoloAscendHero(_heroContract).getHeroIdByAccount(account);
    }

    /// @inheritdoc IForgeCoordinator
    function getForgeRequest(bytes32 requestId) external view returns (ForgeRequest memory request) {
        return _forgeRequests[requestId];
    }

    /// @inheritdoc IForgeCoordinator
    function getPendingRequest(uint256 heroId) external view returns (bytes32 requestId) {
        return _heroToPendingRequest[heroId];
    }

    /// @inheritdoc IForgeCoordinator
    function hasPendingForge(uint256 heroId) external view returns (bool hasPending) {
        return _heroToPendingRequest[heroId] != bytes32(0);
    }

    /// @inheritdoc IForgeCoordinator
    function calculateForgeCost(
        uint256 heroId,
        uint256 oracleId,
        uint32 gasLimit
    ) external view returns (uint256 cost) {
        heroId; // Silence unused parameter warning
        return ORACLE_REGISTRY.calculateFee(oracleId, gasLimit);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Select effect type based on available types, quality, and randomness
    /// @param availableEffectTypes Array of available effect type IDs
    /// @param quality Forge quality
    /// @param randomSeed Random seed
    /// @param totalForges Total forges performed by hero
    /// @param heroStage Current hero stage
    /// @return effectTypeId Selected effect type ID
    function _selectEffectType(
        GameConstants.ForgeEffectType[] memory availableEffectTypes,
        GameConstants.ForgeQuality quality,
        uint256 randomSeed,
        uint256 totalForges,
        GameConstants.HeroStage heroStage
    ) internal view returns (GameConstants.ForgeEffectType) {
        // Special case: Force AMPLIFY effect on guaranteed forge count (if hero is not SOLO_LEVELING)
        if (
            totalForges == GameConstants.AMPLIFY_GUARANTEE_FORGE_COUNT &&
            heroStage != GameConstants.HeroStage.SOLO_LEVELING
        ) {
            // Check if AMPLIFY effect is available
            for (uint256 i = 0; i < availableEffectTypes.length; ) {
                unchecked {
                    ++i;
                }
                if (availableEffectTypes[i] == GameConstants.ForgeEffectType.AMPLIFY) {
                    // AMPLIFY effect type ID is 1
                    // For 50th forge guarantee, we need to ensure it can be generated
                    // If quality is SILVER and AMPLIFY requires higher quality, upgrade quality check
                    uint256 weight = FORGE_EFFECT_REGISTRY.getEffectQualityWeight(
                        GameConstants.ForgeEffectType.AMPLIFY,
                        quality
                    );
                    if (weight > 0) {
                        return GameConstants.ForgeEffectType.AMPLIFY; // Force AMPLIFY effect
                    } else if (quality == GameConstants.ForgeQuality.SILVER) {
                        // Check if AMPLIFY is available at GOLD or RAINBOW
                        weight = FORGE_EFFECT_REGISTRY.getEffectQualityWeight(
                            GameConstants.ForgeEffectType.AMPLIFY,
                            GameConstants.ForgeQuality.GOLD
                        );
                        if (weight > 0) {
                            return GameConstants.ForgeEffectType.AMPLIFY; // Force AMPLIFY even with quality mismatch
                        }
                        weight = FORGE_EFFECT_REGISTRY.getEffectQualityWeight(
                            GameConstants.ForgeEffectType.AMPLIFY,
                            GameConstants.ForgeQuality.RAINBOW
                        );
                        if (weight > 0) {
                            return GameConstants.ForgeEffectType.AMPLIFY; // Force AMPLIFY even with quality mismatch
                        }
                    }
                    break;
                }
            }
        }

        // Calculate total weight for available effect types at this quality
        uint256 totalWeight = 0;

        for (uint256 i = 0; i < availableEffectTypes.length; ) {
            uint256 weight = FORGE_EFFECT_REGISTRY.getEffectQualityWeight(
                GameConstants.ForgeEffectType(availableEffectTypes[i]),
                quality
            );
            unchecked {
                totalWeight += weight;
                ++i;
            }
        }

        if (totalWeight == 0) {
            // If no weights, select randomly
            return availableEffectTypes[randomSeed % availableEffectTypes.length];
        }

        // Use weighted selection
        LibPRNG.PRNG memory prng = LibPRNG.PRNG(randomSeed);
        uint256 randomValue = prng.uniform(totalWeight);
        uint256 currentWeight = 0;

        for (uint256 i = 0; i < availableEffectTypes.length; ) {
            uint256 weight = FORGE_EFFECT_REGISTRY.getEffectQualityWeight(
                GameConstants.ForgeEffectType(availableEffectTypes[i]),
                quality
            );
            unchecked {
                currentWeight += weight;
            }

            if (randomValue < currentWeight) {
                return availableEffectTypes[i];
            }

            unchecked {
                ++i;
            }
        }

        // Fallback to first available
        return availableEffectTypes[0];
    }

    /// @notice Execute hook for a specific phase
    /// @param phase Hook execution phase
    /// @param data Encoded data to pass to hooks
    function _executeHook(IHookRegistry.HookPhase phase, bytes memory data) internal {
        if (address(HOOK_REGISTRY) == address(0)) return;
        if (HOOK_REGISTRY.hasHooks(phase)) {
            // solhint-disable-next-line no-empty-blocks
            try HOOK_REGISTRY.executeHooks(phase, data) {
                // Hook executed successfully - no action needed
                // solhint-disable-next-line no-empty-blocks
            } catch (bytes memory) {
                // This ensures hooks don't break the main forge flow
            }
        }
    }

    /// @notice Validate and update forge request
    /// @param request Forge request to validate
    /// @param randomSeed Random seed from oracle
    function _validateAndUpdateRequest(ForgeRequest storage request, uint256 randomSeed) internal {
        if (request.heroId == 0) revert RequestNotFound();
        if (request.fulfilled) revert RequestAlreadyFulfilled();

        request.fulfilled = true;
        request.randomSeed = randomSeed;
    }

    /// @notice Process forge quality determination and related hooks
    /// @param requestId Request ID
    /// @param request Forge request data
    /// @param randomSeed Random seed from oracle
    /// @return quality Determined forge quality
    function _processForgeQuality(
        bytes32 requestId,
        ForgeRequest storage request,
        uint256 randomSeed
    ) internal returns (GameConstants.ForgeQuality quality) {
        // Execute before quality determination hook
        _executeHook(
            IHookRegistry.HookPhase.BEFORE_EFFECT_GENERATION,
            abi.encode(requestId, request.heroId, request.oracleId, randomSeed)
        );

        // Determine forge quality
        quality = ORACLE_REGISTRY.determineQuality(request.oracleId, randomSeed, request.totalForges);
        emit ForgeQualityDetermined(requestId, quality);
    }

    /// @notice Generate forge effect based on quality and randomness
    /// @param requestId Request ID
    /// @param request Forge request data
    /// @param quality Forge quality
    /// @param randomSeed Random seed
    /// @return effectTypeId Selected effect type
    /// @return effectId Generated effect ID
    function _generateForgeEffect(
        bytes32 requestId,
        ForgeRequest storage request,
        GameConstants.ForgeQuality quality,
        uint256 randomSeed
    ) internal returns (GameConstants.ForgeEffectType effectTypeId, uint256 effectId) {
        // Step 1: Get and filter available effect types
        GameConstants.ForgeEffectType[] memory availableEffectTypes = _getFilteredEffectTypes(quality, request);

        // Step 2: Select effect type
        effectTypeId = _selectEffectType(
            availableEffectTypes,
            quality,
            randomSeed,
            request.totalForges,
            _getHeroStage(request.heroId)
        );

        // Step 3: Generate and execute effect
        effectId = _executeSelectedEffect(requestId, request, effectTypeId, quality, randomSeed);
    }

    /// @notice Get and filter available effect types for a request
    /// @param quality Forge quality
    /// @param request Forge request data
    /// @return availableEffectTypes Filtered array of effect types
    function _getFilteredEffectTypes(
        GameConstants.ForgeQuality quality,
        ForgeRequest storage request
    ) internal view returns (GameConstants.ForgeEffectType[] memory availableEffectTypes) {
        availableEffectTypes = FORGE_EFFECT_REGISTRY.getAvailableEffectTypes(quality, request.totalForges);
        if (availableEffectTypes.length == 0) revert NoAvailableEffectTypes();

        // Filter out AMPLIFY for SOLO_LEVELING heroes
        bool isSoloLeveling = _getHeroStage(request.heroId) == GameConstants.HeroStage.SOLO_LEVELING;
        if (isSoloLeveling) {
            availableEffectTypes = _filterOutEffectType(GameConstants.ForgeEffectType.AMPLIFY, availableEffectTypes);
        }
    }

    /// @notice Filter out AMPLIFY effect from available types
    /// @param effectType Effect type to filter out
    /// @param effectTypes Original effect types array
    /// @return filteredEffects Array without AMPLIFY effect
    function _filterOutEffectType(
        GameConstants.ForgeEffectType effectType,
        GameConstants.ForgeEffectType[] memory effectTypes
    ) internal pure returns (GameConstants.ForgeEffectType[] memory filteredEffects) {
        uint256 count = 0;
        bool removed = false;
        for (uint256 i = 0; i < effectTypes.length; ) {
            if (effectTypes[i] != effectType) {
                unchecked {
                    ++count;
                }
            } else {
                removed = true;
            }
            unchecked {
                ++i;
            }
        }

        if (count == 0) revert NoAvailableEffectTypes();
        if (!removed) return effectTypes;

        filteredEffects = new GameConstants.ForgeEffectType[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < effectTypes.length; ) {
            if (effectTypes[i] != effectType) {
                filteredEffects[index] = effectTypes[i];
                unchecked {
                    ++index;
                }
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Execute selected effect
    /// @param requestId Request ID
    /// @param request Forge request data
    /// @param effectTypeId Selected effect type ID
    /// @param quality Forge quality
    /// @param randomSeed Random seed
    /// @return effectId Generated effect ID
    function _executeSelectedEffect(
        bytes32 requestId,
        ForgeRequest storage request,
        GameConstants.ForgeEffectType effectTypeId,
        GameConstants.ForgeQuality quality,
        uint256 randomSeed
    ) internal returns (uint256 effectId) {
        effectId = uint256(keccak256(abi.encode(requestId, block.timestamp)));
        request.effectId = effectId;

        address effectImplementation = FORGE_EFFECT_REGISTRY.getEffectImplementation(effectTypeId);

        GameConstants.ForgeEffect memory effect = IForgeEffect(effectImplementation).generateEffect(
            randomSeed,
            quality,
            request.totalForges
        );

        _mintForgeItemNFT(request.heroId, effect, effectId);
        _callEffectContract(effectImplementation, request.heroId, effect, effectId);
        _finalizeForgeEffect(requestId, request, effectTypeId, effectId, quality);
    }

    /// @notice Finalize forge effect generation
    /// @param requestId Request ID
    /// @param request Forge request data
    /// @param effectTypeId Effect type ID
    /// @param effectId Effect instance ID
    /// @param quality Forge quality
    function _finalizeForgeEffect(
        bytes32 requestId,
        ForgeRequest storage request,
        GameConstants.ForgeEffectType effectTypeId,
        uint256 effectId,
        GameConstants.ForgeQuality quality
    ) internal {
        emit ForgeCompleted(requestId, request.heroId, effectTypeId, effectId, quality);

        // Execute after effect generated hook
        _executeHook(
            IHookRegistry.HookPhase.AFTER_EFFECT_GENERATED,
            abi.encode(effectTypeId, quality, request.requester, effectId, request.heroId)
        );
    }

    /// @notice Call effect contract to execute its specific logic
    /// @param effectImplementation Address of the effect contract
    /// @param heroId Hero token ID
    /// @param effect Generated forge effect
    /// @param effectId Effect instance ID
    function _callEffectContract(
        address effectImplementation,
        uint256 heroId,
        GameConstants.ForgeEffect memory effect,
        uint256 effectId
    ) internal {
        IForgeEffect(effectImplementation).executeEffect(heroId, effect, effectId);
    }

    /// @notice Mint forge item NFT
    /// @param heroId Hero token ID
    /// @param effect Generated forge effect
    /// @param effectId Effect instance ID
    /// @return tokenId Minted token ID
    function _mintForgeItemNFT(
        uint256 heroId,
        GameConstants.ForgeEffect memory effect,
        uint256 effectId
    ) internal returns (uint256 tokenId) {
        address forgeItemContract = FORGE_ITEM_REGISTRY.getForgeItemContract(effect.quality);
        if (address(forgeItemContract) == address(0)) revert ForgeItemContractNotFound();

        address mintTo = _determineMintDestination(heroId, effect.effectType);
        _storePendingEffect(effectId, heroId, effect);

        tokenId = IForgeItemNFT(forgeItemContract).mint(mintTo, effect.effectType, effect.attribute, effect.value);
        _updatePendingEffectMapping(effectId, tokenId);

        emit ForgeItemCreated(address(forgeItemContract), tokenId, mintTo, effect.quality, effect.effectType);
    }

    /// @notice Determine mint destination based on effect type
    /// @param heroId Hero token ID
    /// @param effectType Effect type
    /// @return mintTo Destination address for minting
    function _determineMintDestination(
        uint256 heroId,
        GameConstants.ForgeEffectType effectType
    ) internal view returns (address mintTo) {
        if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            return this.getHeroTokenBoundAccount(heroId);
        } else if (
            effectType == GameConstants.ForgeEffectType.AMPLIFY ||
            effectType == GameConstants.ForgeEffectType.ENHANCE ||
            effectType == GameConstants.ForgeEffectType.FT ||
            effectType == GameConstants.ForgeEffectType.NFT
        ) {
            return address(0);
        } else if (effectType == GameConstants.ForgeEffectType.MYTHIC) {
            return IERC721(_heroContract).ownerOf(heroId);
        }
        return address(0);
    }

    /// @notice Store pending effect data
    /// @param effectId Effect instance ID
    /// @param heroId Hero token ID
    /// @param effect Generated forge effect
    function _storePendingEffect(uint256 effectId, uint256 heroId, GameConstants.ForgeEffect memory effect) internal {
        _pendingEffects[effectId] = PendingEffect({
            heroId: heroId,
            effect: effect,
            effectImplementation: FORGE_EFFECT_REGISTRY.getEffectImplementation(effect.effectType)
        });
    }

    /// @notice Update pending effect mapping to use token ID
    /// @param effectId Original effect ID
    /// @param tokenId Minted token ID
    function _updatePendingEffectMapping(uint256 effectId, uint256 tokenId) internal {
        _pendingEffects[tokenId] = _pendingEffects[effectId];
        if (tokenId != effectId) {
            delete _pendingEffects[effectId];
        }
    }

    /// @notice Get hero stage from hero contract
    /// @param heroId Hero ID
    /// @return stage Hero stage
    function _getHeroStage(uint256 heroId) internal view returns (GameConstants.HeroStage stage) {
        if (_heroContract == address(0)) revert HeroContractNotSet();

        // Get hero data and extract stage
        GameConstants.Hero memory hero = ISoloAscendHero(_heroContract).getHero(heroId);
        return hero.stage;
    }

    /// @notice Handle forge item burning
    /// @param from Address of the previous owner
    /// @param tokenId Token ID
    /// @param effectType Effect type
    function _handleForgeItemBurning(address from, uint256 tokenId, GameConstants.ForgeEffectType effectType) internal {
        // Get the pending effect data
        PendingEffect memory pending = _pendingEffects[tokenId];
        if (pending.heroId == 0) return;

        // Execute the effect through the effect contract
        if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            uint256 heroId = _isHeroTBA(from) ? this.getHeroIdByAccount(from) : 0;
            if (heroId != 0) {
                ISoloAscendHero(_heroContract).decreaseHeroAttributeFromCoordinator(
                    heroId,
                    pending.effect.attribute,
                    pending.effect.value,
                    false
                );
            }
        }

        // Clean up pending effect
        delete _pendingEffects[tokenId];
    }

    /// @notice Handle forge item transfers between addresses
    /// @param from Previous owner
    /// @param to New owner
    /// @param tokenId Token ID
    /// @param effectType Effect type
    function _handleForgeItemTransfer(
        address from,
        address to,
        uint256 tokenId,
        GameConstants.ForgeEffectType effectType
    ) internal {
        // Handle attribute forge items for TBA transfers
        if (effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            uint256 fromHeroId = _isHeroTBA(from) ? this.getHeroIdByAccount(from) : 0;
            uint256 toHeroId = _isHeroTBA(to) ? this.getHeroIdByAccount(to) : 0;

            if (fromHeroId != 0 || toHeroId != 0) {
                _processAttributeTransfer(tokenId, fromHeroId, toHeroId);
            }
        }
        // Handle Mythic forge items
        if (effectType == GameConstants.ForgeEffectType.MYTHIC) {
            uint256 toHeroId = _isHeroTBA(to) ? this.getHeroIdByAccount(to) : 0;
            if (toHeroId != 0) {
                _processMythicEffect(tokenId, toHeroId);
            }
        }
    }

    /// @notice Process attribute transfer between TBAs
    /// @param tokenId Token ID
    /// @param fromHeroId Source hero ID
    /// @param toHeroId Target hero ID
    function _processAttributeTransfer(uint256 tokenId, uint256 fromHeroId, uint256 toHeroId) internal {
        // Get the forge item effect data
        PendingEffect memory pending = _pendingEffects[tokenId];
        if (pending.heroId == 0) return;

        // Remove attributes from source hero
        if (fromHeroId != 0) {
            ISoloAscendHero(_heroContract).decreaseHeroAttributeFromCoordinator(
                fromHeroId,
                pending.effect.attribute,
                pending.effect.value,
                false
            );
        }

        // Add attributes to target hero
        if (toHeroId != 0) {
            ISoloAscendHero(_heroContract).increaseHeroAttributeFromCoordinator(
                toHeroId,
                pending.effect.attribute,
                pending.effect.value,
                false
            );
        }
    }

    /// @notice Process mythic effect when transferred to TBA
    /// @param tokenId Token ID
    /// @param heroId Hero ID
    function _processMythicEffect(uint256 tokenId, uint256 heroId) internal {
        // Get the pending effect data
        PendingEffect memory pending = _pendingEffects[tokenId];
        if (pending.heroId == 0) return;

        ISoloAscendHero(_heroContract).updateHeroStageFromCoordinator(heroId, GameConstants.HeroStage.SOLO_LEVELING);

        delete _pendingEffects[tokenId];
    }

    /// @notice Check if address is a hero TBA
    /// @param addr Address to check
    /// @return True if TBA
    function _isHeroTBA(address addr) internal view returns (bool) {
        if (addr == address(0)) return false;
        return this.getHeroIdByAccount(addr) != 0;
    }
}
