// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title IERC6551Registry
/// @author Solo Ascend Team
/// @notice Interface for ERC-6551 Token Bound Account Registry
interface IERC6551Registry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Creates a token bound account for a non-fungible token
    /// @param implementation The address of the account implementation contract
    /// @param salt A value used to create a deterministic account address
    /// @param chainId The chain ID of the network where the NFT exists
    /// @param tokenContract The contract address of the NFT
    /// @param tokenId The token ID of the NFT
    /// @return account The address of the created token bound account
    function createAccount(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external returns (address account);

    /// @notice Computes the token bound account address for a non-fungible token
    /// @param implementation The address of the account implementation contract
    /// @param salt A value used to create a deterministic account address
    /// @param chainId The chain ID of the network where the NFT exists
    /// @param tokenContract The contract address of the NFT
    /// @param tokenId The token ID of the NFT
    /// @return account The computed address of the token bound account
    function account(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external view returns (address account);
}
