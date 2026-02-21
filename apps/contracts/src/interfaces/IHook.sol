// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IHookRegistry} from "./IHookRegistry.sol";

/// @title IHook
/// @notice Interface that all hook contracts must implement
/// @author Solo Ascend Team
interface IHook {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the hero contract is invalid
    error InvalidHeroContract();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Execute hook logic
    /// @param phase The hook phase being executed
    /// @param data Encoded context data for the hook
    /// @return success Whether the hook executed successfully
    function executeHook(IHookRegistry.HookPhase phase, bytes calldata data) external returns (bool success);

    /// @notice Get hook metadata
    /// @return name Human-readable name of the hook
    /// @return version Version of the hook implementation
    function getHookInfo() external view returns (string memory name, string memory version);
}
