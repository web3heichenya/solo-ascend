// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IForgeItemRegistry
/// @notice Interface for the ForgeItemRegistry contract
/// @author Solo Ascend Team
interface IForgeItemRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the quality is invalid
    error InvalidQuality();
    /// @notice Error thrown when the contract is not registered
    error ContractNotRegistered();
    /// @notice Error thrown when the contract is already registered
    error ContractAlreadyRegistered();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a forge item contract is registered for a quality level
    /// @param quality The forge quality
    /// @param contractAddress The registered forge item contract address
    event ForgeItemContractRegistered(GameConstants.ForgeQuality indexed quality, address indexed contractAddress);

    /// @notice Emitted when a forge item contract is updated for a quality level
    /// @param quality The forge quality
    /// @param oldContract The old forge item contract address
    /// @param newContract The new forge item contract address
    event ForgeItemContractUpdated(GameConstants.ForgeQuality quality, address oldContract, address newContract);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get forge item contract mapping
    /// @param quality The forge quality
    /// @return contractAddress The registered forge item contract address
    function forgeItemContracts(GameConstants.ForgeQuality quality) external view returns (address contractAddress);

    /// @notice Get forge item contract for specific quality
    /// @param quality The forge quality
    /// @return ForgeItemNFT contract address
    function getForgeItemContract(GameConstants.ForgeQuality quality) external view returns (address);

    /// @notice Check if quality has registered contract
    /// @param quality The forge quality to check
    /// @return True if contract is registered
    function hasContract(GameConstants.ForgeQuality quality) external view returns (bool);

    /// @notice Get all registered forge item contracts
    /// @return silver Silver quality contract
    /// @return gold Gold quality contract
    /// @return rainbow Rainbow quality contract
    /// @return mythic Mythic quality contract
    function getAllContracts() external view returns (address silver, address gold, address rainbow, address mythic);

    /// @notice Check if a forge item contract is authorized
    /// @param contractAddress Forge item contract address
    /// @return isAuthorized Whether the contract is authorized
    function isAuthorizedForgeItem(address contractAddress) external view returns (bool);

    /// @notice Register forge item contract for a quality
    /// @param quality The forge quality
    /// @param contractAddress The NFT contract address
    function registerForgeItemContract(GameConstants.ForgeQuality quality, address contractAddress) external;

    /// @notice Update forge item contract for a quality
    /// @param quality The forge quality
    /// @param newContractAddress The new NFT contract address
    function updateForgeItemContract(GameConstants.ForgeQuality quality, address newContractAddress) external;
}
