// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IOracle} from "../../src/interfaces/IOracle.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";

/// @title MockOracle
/// @notice Mock oracle implementation for testing
contract MockOracle is IOracle {
    mapping(bytes32 => uint256) private _pendingRequests;
    uint256 private _fixedRandomSeed;
    bool private _autoFulfill;

    event RandomnessRequested(bytes32 indexed requestId, uint256 indexed heroId, address indexed requester);
    event MockRandomnessFulfilled(bytes32 indexed requestId, uint256 randomSeed);

    /// @notice Set fixed random seed for predictable testing
    function setFixedRandomSeed(uint256 seed) external {
        _fixedRandomSeed = seed;
    }

    /// @notice Enable/disable auto-fulfillment
    function setAutoFulfill(bool enabled) external {
        _autoFulfill = enabled;
    }

    /// @notice Request randomness (mock implementation)
    function requestRandomness(
        bytes32 requestId,
        uint256 heroId,
        address requester,
        uint32 gasLimit
    ) external payable override returns (bytes32 echoedRequestId) {
        gasLimit; // Silence unused parameter warning

        _pendingRequests[requestId] = heroId;
        emit RandomnessRequested(requestId, heroId, requester);

        if (_autoFulfill) {
            _fulfillRandomness(requestId);
        }

        return requestId;
    }

    /// @notice Manually fulfill randomness request
    function fulfillRandomness(bytes32 requestId) external {
        _fulfillRandomness(requestId);
    }

    /// @notice Fulfill randomness request with custom seed
    function fulfillRandomnessWithSeed(bytes32 requestId, uint256 randomSeed, address coordinator) external {
        require(_pendingRequests[requestId] != 0, "Request not found");

        delete _pendingRequests[requestId];

        IForgeCoordinator(coordinator).fulfillForge(requestId, randomSeed);
        emit MockRandomnessFulfilled(requestId, randomSeed);
    }

    /// @notice Internal fulfill function
    function _fulfillRandomness(bytes32 requestId) internal {
        require(_pendingRequests[requestId] != 0, "Request not found");

        uint256 randomSeed = _fixedRandomSeed != 0
            ? _fixedRandomSeed
            : uint256(keccak256(abi.encodePacked(requestId, block.timestamp, block.prevrandao)));

        delete _pendingRequests[requestId];

        // Call back to ForgeCoordinator
        IForgeCoordinator(msg.sender).fulfillForge(requestId, randomSeed);
        emit MockRandomnessFulfilled(requestId, randomSeed);
    }

    /// @notice Check if request is pending
    function isPending(bytes32 requestId) external view returns (bool) {
        return _pendingRequests[requestId] != 0;
    }

    /// @notice Get randomness for a request
    function getRandomness(bytes32 requestId) external view override returns (bool fulfilled, uint256 randomSeed) {
        return (_pendingRequests[requestId] == 0, _fixedRandomSeed);
    }

    /// @notice Get fee for randomness request
    function getFee(uint32 gasLimit) external pure override returns (uint256 fee) {
        return uint256(gasLimit) * 1 gwei; // Mock fee calculation
    }

    /// @notice Check if oracle is active
    function isActive() external pure override returns (bool active) {
        return true;
    }
}
