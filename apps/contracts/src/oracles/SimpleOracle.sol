// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {LibPRNG} from "solady/utils/LibPRNG.sol";
import {IOracle} from "../interfaces/IOracle.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title SimpleOracle
/// @notice Basic pseudo-random oracle using block data
/// @author Solo Ascend Team
contract SimpleOracle is IOracle, Ownable, ReentrancyGuard {
    using LibPRNG for LibPRNG.PRNG;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Request counter for generating unique IDs
    uint256 private _requestCounter;

    /// @notice Whether oracle is active
    bool private _isActive = true;

    /// @notice Mapping from request ID to request data
    mapping(bytes32 => IForgeCoordinator.RandomRequest) public requests;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Coordinator contract to callback
    address public immutable FORGE_COORDINATOR;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the SimpleOracle
    /// @param admin The address that will be granted owner privileges
    /// @param forgeCoordinator The address of the coordinator contract
    constructor(address admin, address forgeCoordinator) Ownable(admin) {
        if (forgeCoordinator == address(0)) revert InvalidAddress();
        FORGE_COORDINATOR = forgeCoordinator;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Toggle oracle active status
    /// @param active New active status
    function setActive(bool active) external onlyOwner {
        _isActive = active;
    }

    /// @inheritdoc IOracle
    function requestRandomness(
        bytes32 requestId,
        uint256 heroId,
        address requester,
        uint32 /*gasLimit*/
    ) external payable override returns (bytes32) {
        if (!_isActive) revert OracleNotActive();
        ++_requestCounter;
        // Generate pseudo-random seed using block data
        uint256 randomSeed = uint256(keccak256(abi.encode(address(this), block.prevrandao, requestId)));

        // Store request
        requests[requestId] = IForgeCoordinator.RandomRequest({
            requester: requester,
            requestTime: uint64(block.timestamp),
            heroId: uint32(heroId),
            vrfRequestId: requestId,
            fulfilled: true, // Immediately fulfilled for pseudo-random
            randomSeed: randomSeed
        });

        emit RandomnessRequested(requestId, requestId, heroId, requester);
        if (FORGE_COORDINATOR != address(0)) {
            IForgeCoordinator(FORGE_COORDINATOR).fulfillForge(requestId, randomSeed);
        }
        emit RandomnessFulfilled(requestId, randomSeed);

        return requestId;
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

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IOracle
    function getRandomness(bytes32 requestId) external view override returns (bool fulfilled, uint256 randomSeed) {
        IForgeCoordinator.RandomRequest storage request = requests[requestId];
        return (request.fulfilled, request.randomSeed);
    }

    /// @inheritdoc IOracle
    function getFee(uint32 /*gasLimit*/) external pure override returns (uint256 fee) {
        return 0; // Free oracle
    }

    /// @inheritdoc IOracle
    function isActive() external view override returns (bool active) {
        return _isActive;
    }

    /// @notice Get request data
    /// @param requestId Request ID
    /// @return request Request data
    function getRequest(bytes32 requestId) external view returns (IForgeCoordinator.RandomRequest memory request) {
        return requests[requestId];
    }

    /// @notice Get request counter
    /// @return counter Current request counter
    function getRequestCounter() external view returns (uint256 counter) {
        return _requestCounter;
    }
}
