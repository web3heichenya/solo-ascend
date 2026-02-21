// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IOracle} from "../interfaces/IOracle.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {VRFV2PlusClient} from "../libraries/VRFV2PlusClient.sol";

/// @title IVRFV2PlusWrapper
/// @notice Minimal VRF v2.5 Wrapper interface (Direct Funding)
/// @author Chainlink Labs
interface IVRFV2PlusWrapper {
    /// @notice Calculate the request price
    /// @param callbackGasLimit The gas limit for the callback
    /// @param numWords The number of words to request
    /// @return The request price
    function calculateRequestPriceNative(uint32 callbackGasLimit, uint32 numWords) external view returns (uint256);
    /// @notice Request random words
    /// @param callbackGasLimit The gas limit for the callback
    /// @param requestConfirmations The number of confirmations
    /// @param numWords The number of words to request
    /// @param extraArgs Additional arguments for the request
    /// @return requestId The request ID
    function requestRandomWordsInNative(
        uint32 callbackGasLimit,
        uint16 requestConfirmations,
        uint32 numWords,
        bytes calldata extraArgs
    ) external payable returns (uint256 requestId);
}

/// @title ChainlinkVRFDirectOracle
/// @notice Chainlink VRF v2.5 Direct Funding oracle (ETH payment)
/// @author Solo Ascend Team
contract ChainlinkVRFDirectOracle is IOracle, Ownable, ReentrancyGuard {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.´:•˚°.*°.˚:*.´+°.•*/
    /*                          STORAGE                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Whether oracle is active
    bool private _isActive = true;

    /// @notice Number of confirmations
    uint16 private _requestConfirmations = 1;

    /// @notice Number of words to request
    uint32 private _numWords = 1;

    /// @notice Request mapping (internal requestId => record)
    mapping(bytes32 => IForgeCoordinator.RandomRequest) private _requests;

    /// @notice VRF requestId mapping to internal requestId
    mapping(uint256 => bytes32) private _vrfRequestToInternal;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice VRF v2.5 Wrapper address
    address public immutable VRF_WRAPPER;

    /// @notice Coordinator contract address (callbacks go here for authorization and distribution)
    address public immutable FORGE_COORDINATOR;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Only Wrapper can call fulfill callback
    modifier onlyWrapper() {
        if (msg.sender != VRF_WRAPPER) revert OracleNotActive();
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Constructor
    /// @param admin The address that will be the owner of the contract
    /// @param vrfWrapper The address of the VRF wrapper contract
    /// @param forgeCoordinator The address of the coordinator contract
    constructor(address admin, address vrfWrapper, address forgeCoordinator) Ownable(admin) {
        if (vrfWrapper == address(0) || forgeCoordinator == address(0)) revert InvalidAddress();
        VRF_WRAPPER = vrfWrapper;
        FORGE_COORDINATOR = forgeCoordinator;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Set the active state of the oracle
    /// @param active The active state
    function setActive(bool active) external onlyOwner {
        _isActive = active;
    }

    /// @notice Set the VRF configuration
    /// @param confirmations The number of confirmations
    /// @param numWords The number of words to request
    function setVrfConfig(uint16 confirmations, uint32 numWords) external onlyOwner {
        _requestConfirmations = confirmations;
        _numWords = numWords;
    }

    /// @notice Withdraw all project revenue
    /// @param to Address to send the ETH to
    function withdrawAllRevenue(address to) external onlyOwner nonReentrant {
        if (to == address(0)) revert InvalidAddress();

        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientFee();

        (bool success, ) = to.call{value: balance}("");
        if (!success) revert TransferFailed();
    }

    /*´:°•.°+.*•´.*:˚.°*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                       IOracle METHODS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IOracle
    function requestRandomness(
        bytes32 requestId,
        uint256 heroId,
        address requester,
        uint32 gasLimit
    ) external payable override returns (bytes32) {
        if (!_isActive) revert OracleNotActive();
        if (VRF_WRAPPER == address(0) || FORGE_COORDINATOR == address(0)) revert InvalidRequest();

        // Price estimation (Direct Funding method, pay wrapper based on gasLimit)
        uint256 price = IVRFV2PlusWrapper(VRF_WRAPPER).calculateRequestPriceNative(gasLimit, _numWords);
        if (msg.value < price) revert InsufficientFee();

        // extraArgs enables native coin (ETH) payment
        bytes memory extraArgs = VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true}));

        // Direct payment request for randomness
        uint256 vrfReqId = IVRFV2PlusWrapper(VRF_WRAPPER).requestRandomWordsInNative{value: msg.value}(
            gasLimit,
            _requestConfirmations,
            _numWords,
            extraArgs
        );

        // Record request
        _requests[requestId] = IForgeCoordinator.RandomRequest({
            requester: requester,
            requestTime: uint64(block.timestamp),
            heroId: uint32(heroId),
            vrfRequestId: bytes32(vrfReqId),
            fulfilled: false,
            randomSeed: 0
        });

        emit RandomnessRequested(requestId, bytes32(vrfReqId), heroId, requester);

        _vrfRequestToInternal[vrfReqId] = requestId;
        return requestId;
    }

    /// @inheritdoc IOracle
    function getRandomness(bytes32 requestId) external view override returns (bool fulfilled, uint256 randomSeed) {
        IForgeCoordinator.RandomRequest storage r = _requests[requestId];
        return (r.fulfilled, r.randomSeed);
    }

    /// @inheritdoc IOracle
    function getFee(uint32 gasLimit) external view override returns (uint256 fee) {
        if (VRF_WRAPPER == address(0)) return 0;
        return IVRFV2PlusWrapper(VRF_WRAPPER).calculateRequestPriceNative(gasLimit, _numWords);
    }

    /// @inheritdoc IOracle
    function isActive() external view override returns (bool active) {
        return _isActive;
    }

    /*´:°•.°+.*•´.*:˚.°*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                       VRF CALLBACK                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice VRF Wrapper callback entry point (aligned with v2.5 Wrapper: wrapper -> consumer)
    /// @param requestId VRF requestId
    /// @param randomWords Random number array (numWords)
    function rawFulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) external onlyWrapper {
        bytes32 internalId = _vrfRequestToInternal[requestId];
        if (internalId == bytes32(0)) revert RequestNotFound();

        IForgeCoordinator.RandomRequest storage r = _requests[internalId];
        if (r.fulfilled) revert RequestAlreadyFulfilled();

        uint256 seed = randomWords.length > 0
            ? randomWords[0]
            : uint256(keccak256(abi.encode(requestId, block.timestamp, block.prevrandao)));
        r.randomSeed = seed;
        r.fulfilled = true;

        // Callback to Coordinator (validates authorization and distributes next step)
        IForgeCoordinator(FORGE_COORDINATOR).fulfillForge(internalId, seed);

        emit RandomnessFulfilled(internalId, seed);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get the request
    /// @param requestId The request ID
    /// @return request The request
    function getRequest(bytes32 requestId) external view returns (IForgeCoordinator.RandomRequest memory request) {
        return _requests[requestId];
    }

    /// @notice Get the VRF request to internal request mapping
    /// @param vrfRequestId The VRF request ID
    /// @return internalRequestId The internal request ID
    function getVrfRequestToInternal(uint256 vrfRequestId) external view returns (bytes32 internalRequestId) {
        return _vrfRequestToInternal[vrfRequestId];
    }

    /// @notice Get the request confirmations
    /// @return requestConfirmations The request confirmations
    function getRequestConfirmations() external view returns (uint16 requestConfirmations) {
        return _requestConfirmations;
    }

    /// @notice Get the number of words
    /// @return numWords The number of words
    function getNumWords() external view returns (uint32 numWords) {
        return _numWords;
    }
}
