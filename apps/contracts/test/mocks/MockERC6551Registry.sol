// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC6551Registry} from "../../src/interfaces/IERC6551Registry.sol";

/// @title MockERC6551Registry
/// @notice Mock implementation of ERC-6551 registry for testing
contract MockERC6551Registry is IERC6551Registry {
    mapping(bytes32 => address) private _accounts;

    /// @notice Create a token bound account
    function createAccount(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external returns (address) {
        bytes32 key = keccak256(abi.encodePacked(implementation, salt, chainId, tokenContract, tokenId));

        // Simulate account creation with deterministic address
        address newAccount = address(uint160(uint256(key)));
        _accounts[key] = newAccount;

        return newAccount;
    }

    /// @notice Get the address of a token bound account
    function account(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external view returns (address) {
        bytes32 key = keccak256(abi.encodePacked(implementation, salt, chainId, tokenContract, tokenId));
        address storedAccount = _accounts[key];

        if (storedAccount != address(0)) {
            return storedAccount;
        }

        // Return deterministic address even if not created yet
        return address(uint160(uint256(key)));
    }
}
