// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title IHookRegistry
/// @notice Interface for managing and executing hooks in the Solo Ascend system
/// @author Solo Ascend Team
interface IHookRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the hook is already registered
    error HookAlreadyRegistered();
    /// @notice Error thrown when the hook is not found
    error HookNotFound();
    /// @notice Error thrown when the hook contract is invalid
    error InvalidHookContract();
    /// @notice Error thrown when the hooks are disabled
    error HooksDisabled();
    /// @notice Error thrown when the gas limit is too low
    error GasLimitTooLow();
    /// @notice Error thrown when the gas limit is too high
    error GasLimitTooHigh();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new hook is registered
    /// @param phase Hook execution phase
    /// @param hookAddress Hook contract address
    /// @param priority Execution priority
    /// @param gasLimit Maximum gas limit for hook execution
    event HookRegistered(HookPhase indexed phase, address indexed hookAddress, uint256 priority, uint256 gasLimit);

    /// @notice Emitted when a hook is updated
    /// @param phase Hook execution phase
    /// @param hookContract Hook contract address
    /// @param isActive Whether hook is currently active
    /// @param gasLimit Maximum gas limit for hook execution
    event HookConfigUpdated(HookPhase indexed phase, address indexed hookContract, bool isActive, uint256 gasLimit);

    /// @notice Emitted when a hook is unregistered
    /// @param phase Hook execution phase
    /// @param hookAddress Hook contract address
    event HookDeregistered(HookPhase indexed phase, address indexed hookAddress);

    /// @notice Emitted when a hook is executed successfully
    /// @param phase Hook execution phase
    /// @param hookContract Hook contract address
    /// @param success Whether hook executed successfully
    event HookExecuted(HookPhase indexed phase, address indexed hookContract, bool success);
    /// @notice Emitted when a hook execution fails
    /// @param phase Hook execution phase
    /// @param hookContract Hook contract address
    /// @param reason Reason for hook failure
    event HookFailed(HookPhase indexed phase, address indexed hookContract, bytes reason);
    /// @notice Emitted when hook execution fails with a specific reason
    /// @param hookContract Hook contract address
    /// @param phase Hook execution phase
    /// @param reason Reason for hook failure
    event HookExecutionFailed(address indexed hookContract, HookPhase phase, string reason);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Hook execution phases
    enum HookPhase {
        BEFORE_HERO_MINTING, // Before hero minting
        AFTER_HERO_MINTED, // After hero minted
        BEFORE_EFFECT_GENERATION, // Before effect generation
        AFTER_EFFECT_GENERATED, // After effect generated
        FORGE_INITIATION, // Before forge initiation
        HERO_STAGE_CHANGED, // Hero stage changed
        HERO_ATTRIBUTE_UPDATED // Hero attribute updated
    }

    /// @notice Configuration data for a registered hook
    /// @param hookContract Contract implementing the hook
    /// @param isActive Whether hook is currently active
    /// @param priority Execution priority (0-255, lower = higher priority)
    /// @param gasLimit Maximum gas limit for hook execution
    struct HookConfig {
        address hookContract;
        bool isActive;
        uint8 priority;
        uint32 gasLimit;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Register a hook for a specific phase
    /// @param phase Hook execution phase
    /// @param hookContract Contract implementing IHook interface
    /// @param priority Execution priority (lower number = higher priority)
    /// @param gasLimit Maximum gas limit for hook execution
    function registerHook(HookPhase phase, address hookContract, uint8 priority, uint32 gasLimit) external;

    /// @notice Unregister a hook
    /// @param phase Hook execution phase
    /// @param hookContract Hook contract address
    function unregisterHook(HookPhase phase, address hookContract) external;

    /// @notice Execute all hooks for a specific phase
    /// @param phase Hook execution phase
    /// @param data Encoded data to pass to hooks
    /// @return success Whether all hooks executed successfully
    function executeHooks(HookPhase phase, bytes calldata data) external returns (bool success);

    /// @notice Get the global hook execution enabled/disabled status
    /// @return enabled Whether hook execution is enabled
    function getHooksEnabled() external view returns (bool);

    /// @notice Get hooks for a specific phase
    /// @param phase Hook execution phase
    /// @return hooks Array of hook configurations
    function getHooks(HookPhase phase) external view returns (HookConfig[] memory hooks);

    /// @notice Check if hooks are registered for a phase
    /// @param phase Hook execution phase
    /// @return hasHooks Whether any hooks are registered
    function hasHooks(HookPhase phase) external view returns (bool hasHooks);
}
