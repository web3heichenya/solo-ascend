// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IHook} from "../../src/interfaces/IHook.sol";
import {IHookRegistry} from "../../src/interfaces/IHookRegistry.sol";

/// @title MockHook
/// @notice Mock hook implementation for testing
contract MockHook is IHook {
    uint256 public executionCount;
    IHookRegistry.HookPhase public lastPhase;
    bytes public lastData;
    bool public shouldRevert;
    string public revertMessage;
    bool public executionResult = true;
    address public lastCaller;

    event HookExecuted(IHookRegistry.HookPhase phase, bytes data);

    /// @notice Set whether the hook should revert
    function setShouldRevert(bool _shouldRevert, string memory _message) external {
        shouldRevert = _shouldRevert;
        revertMessage = _message;
    }

    /// @notice Set execution result
    function setExecutionResult(bool result) external {
        executionResult = result;
    }

    /// @notice Check if hook was executed
    function wasExecuted() external view returns (bool) {
        return executionCount > 0;
    }

    /// @notice Get last caller
    function getLastCaller() external view returns (address) {
        return lastCaller;
    }

    /// @notice Reset execution state
    function resetExecutionState() external {
        executionCount = 0;
        lastCaller = address(0);
    }

    /// @notice Execute hook (mock implementation)
    function executeHook(IHookRegistry.HookPhase phase, bytes calldata data) external override returns (bool success) {
        if (shouldRevert) {
            revert(revertMessage);
        }

        executionCount++;
        lastPhase = phase;
        lastCaller = msg.sender;
        // Don't store the full data to save gas

        emit HookExecuted(phase, data);
        return executionResult;
    }

    /// @notice Get hook metadata
    function getHookInfo() external pure override returns (string memory name, string memory version) {
        return ("MockHook", "1.0.0");
    }

    /// @notice Reset execution state
    function reset() external {
        executionCount = 0;
        lastPhase = IHookRegistry.HookPhase.BEFORE_HERO_MINTING;
        shouldRevert = false;
        revertMessage = "";
    }
}
