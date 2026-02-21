// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IHookRegistry} from "../../interfaces/IHookRegistry.sol";
import {IHook} from "../../interfaces/IHook.sol";

/// @title HookRegistry
/// @notice Lightweight hook management system for Solo Ascend
/// @author Solo Ascend Team
contract HookRegistry is IHookRegistry, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Global hook execution enabled/disabled
    bool private _hooksEnabled = true;

    /// @notice Mapping from phase to array of hook configurations
    mapping(HookPhase => HookConfig[]) private _hooks;

    /// @notice Mapping from phase to hook contract to array index (for O(1) lookup)
    mapping(HookPhase => mapping(address => uint256)) private _hookIndex;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Maximum gas limit for hook execution
    uint32 public constant MAX_HOOK_GAS_LIMIT = 5_000_000;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Modifier to ensure hook execution is enabled.
    modifier whenHooksEnabled() {
        if (!_hooksEnabled) revert HooksDisabled();
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the HookManager
    /// @param admin The address that will be granted owner privileges
    constructor(address admin) Ownable(admin) {}

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHookRegistry
    function executeHooks(HookPhase phase, bytes calldata data) external whenHooksEnabled returns (bool success) {
        HookConfig[] memory hooks = _hooks[phase];
        success = true; // Always return true for failure isolation

        for (uint256 i = 0; i < hooks.length; ) {
            if (!hooks[i].isActive) {
                unchecked {
                    ++i;
                }
                continue;
            }

            try IHook(hooks[i].hookContract).executeHook{gas: hooks[i].gasLimit}(phase, data) returns (
                bool hookSuccess
            ) {
                emit HookExecuted(phase, hooks[i].hookContract, hookSuccess);
                // Note: Individual hook failures don't affect overall success (failure isolation)
            } catch (bytes memory reason) {
                emit HookFailed(phase, hooks[i].hookContract, reason);

                // Extract error message from revert reason (simplified without assembly)
                string memory errorMsg = "";
                if (reason.length > 67) {
                    // Simplified approach: just use empty string instead of complex assembly
                    errorMsg = "Hook execution failed";
                }

                emit HookExecutionFailed(hooks[i].hookContract, phase, errorMsg);
                // Note: Individual hook failures don't affect overall success (failure isolation)
            }
            unchecked {
                ++i;
            }
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHookRegistry
    function registerHook(HookPhase phase, address hookContract, uint8 priority, uint32 gasLimit) external onlyOwner {
        if (hookContract == address(0)) revert InvalidHookContract();

        // Validate gas limit
        if (gasLimit < 1000) revert GasLimitTooLow();
        if (MAX_HOOK_GAS_LIMIT < gasLimit) revert GasLimitTooHigh();

        // Check if hook is already registered
        if (
            _hookIndex[phase][hookContract] != 0 ||
            (_hooks[phase].length > 0 && _hooks[phase][0].hookContract == hookContract)
        ) {
            revert HookAlreadyRegistered();
        }

        HookConfig memory config = HookConfig({
            hookContract: hookContract,
            isActive: true,
            priority: priority,
            gasLimit: gasLimit
        });

        // Insert hook in priority order (lower priority number = higher priority)
        uint256 insertIndex = _hooks[phase].length;
        for (uint256 i = 0; i < _hooks[phase].length; ) {
            if (priority < _hooks[phase][i].priority) {
                insertIndex = i;
                break;
            }
            unchecked {
                ++i;
            }
        }

        // Insert at the correct position
        _hooks[phase].push(config);
        for (uint256 i = _hooks[phase].length - 1; i > insertIndex; ) {
            _hooks[phase][i] = _hooks[phase][i - 1];
            unchecked {
                --i;
            }
        }
        _hooks[phase][insertIndex] = config;

        // Update index mapping
        _updateIndexMapping(phase);

        emit HookRegistered(phase, hookContract, uint256(priority), uint256(gasLimit));
    }

    /// @inheritdoc IHookRegistry
    function unregisterHook(HookPhase phase, address hookContract) external onlyOwner {
        HookConfig[] storage hookList = _hooks[phase];

        // Check if hook exists and list is not empty
        if (hookList.length == 0) {
            revert HookNotFound();
        }

        uint256 index = _hookIndex[phase][hookContract];
        if (index == 0 && hookList[0].hookContract != hookContract) {
            revert HookNotFound();
        }

        // Remove hook by shifting array
        for (uint256 i = index; i < hookList.length - 1; ) {
            hookList[i] = hookList[i + 1];
            unchecked {
                ++i;
            }
        }
        hookList.pop();

        // Update index mapping
        _updateIndexMapping(phase);

        emit HookDeregistered(phase, hookContract);
    }

    /// @notice Toggle hook execution globally
    /// @param enabled Whether to enable hook execution
    function setHooksEnabled(bool enabled) external onlyOwner {
        _hooksEnabled = enabled;
    }

    /// @notice Update hook configuration
    /// @param phase Hook phase
    /// @param hookContract Hook contract address
    /// @param isActive Whether hook is active
    /// @param gasLimit New gas limit
    function updateHookConfig(
        HookPhase phase,
        address hookContract,
        bool isActive,
        uint32 gasLimit
    ) external onlyOwner {
        if (gasLimit < 1000) revert GasLimitTooLow();
        if (MAX_HOOK_GAS_LIMIT < gasLimit) revert GasLimitTooHigh();

        uint256 index = _hookIndex[phase][hookContract];
        if (index == 0 && _hooks[phase][0].hookContract != hookContract) {
            revert HookNotFound();
        }

        _hooks[phase][index].isActive = isActive;
        _hooks[phase][index].gasLimit = gasLimit;

        emit HookConfigUpdated(phase, hookContract, isActive, gasLimit);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get the global hook execution enabled/disabled status
    /// @return enabled Whether hook execution is enabled
    function getHooksEnabled() external view returns (bool) {
        return _hooksEnabled;
    }

    /// @inheritdoc IHookRegistry
    function getHooks(HookPhase phase) external view returns (HookConfig[] memory hooks) {
        return _hooks[phase];
    }

    /// @inheritdoc IHookRegistry
    function hasHooks(HookPhase phase) external view returns (bool) {
        return _hooks[phase].length > 0;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Update index mapping after array modification
    /// @param phase Hook phase to update
    function _updateIndexMapping(HookPhase phase) internal {
        // Clear existing mappings
        for (uint256 i = 0; i < _hooks[phase].length; ) {
            delete _hookIndex[phase][_hooks[phase][i].hookContract];
            unchecked {
                ++i;
            }
        }

        // Rebuild mappings
        for (uint256 i = 0; i < _hooks[phase].length; ) {
            _hookIndex[phase][_hooks[phase][i].hookContract] = i;
            unchecked {
                ++i;
            }
        }
    }
}
