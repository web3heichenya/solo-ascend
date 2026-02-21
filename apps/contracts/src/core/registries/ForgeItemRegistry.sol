// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {GameConstants} from "../../libraries/GameConstants.sol";
import {IForgeItemRegistry} from "../../interfaces/IForgeItemRegistry.sol";

/// @title ForgeItemRegistry
/// @notice Registry for managing forge item NFT contracts by quality
/// @author Solo Ascend Team
contract ForgeItemRegistry is Ownable, IForgeItemRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Mapping from quality to forge item NFT contract
    mapping(GameConstants.ForgeQuality => address) private _forgeItemContracts;

    /// @notice Mapping from forge item contract address to whether it is authorized
    mapping(address => bool) private _isAuthorizedForgeItem;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTRUCTOR                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize forge item registry
    /// @param admin Contract admin address
    constructor(address admin) Ownable(admin) {}

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeItemRegistry
    function registerForgeItemContract(
        GameConstants.ForgeQuality quality,
        address contractAddress
    ) external override onlyOwner {
        if (contractAddress == address(0)) revert InvalidQuality();
        if (_forgeItemContracts[quality] != address(0)) revert ContractAlreadyRegistered();

        _forgeItemContracts[quality] = contractAddress;
        _isAuthorizedForgeItem[contractAddress] = true;

        emit ForgeItemContractRegistered(quality, contractAddress);
    }

    /// @inheritdoc IForgeItemRegistry
    function updateForgeItemContract(
        GameConstants.ForgeQuality quality,
        address newContractAddress
    ) external override onlyOwner {
        if (newContractAddress == address(0)) revert InvalidQuality();

        address oldContract = _forgeItemContracts[quality];
        if (oldContract == address(0)) revert ContractNotRegistered();

        _forgeItemContracts[quality] = newContractAddress;
        _isAuthorizedForgeItem[newContractAddress] = true;
        _isAuthorizedForgeItem[oldContract] = false;

        emit ForgeItemContractUpdated(quality, oldContract, newContractAddress);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeItemRegistry
    function forgeItemContracts(
        GameConstants.ForgeQuality quality
    ) external view override returns (address contractAddress) {
        return _forgeItemContracts[quality];
    }

    /// @inheritdoc IForgeItemRegistry
    function getForgeItemContract(GameConstants.ForgeQuality quality) external view override returns (address) {
        address forgeContract = _forgeItemContracts[quality];
        if (forgeContract == address(0)) revert ContractNotRegistered();
        return forgeContract;
    }

    /// @inheritdoc IForgeItemRegistry
    function hasContract(GameConstants.ForgeQuality quality) external view override returns (bool) {
        return address(_forgeItemContracts[quality]) != address(0);
    }

    /// @inheritdoc IForgeItemRegistry
    function getAllContracts()
        external
        view
        override
        returns (address silver, address gold, address rainbow, address mythic)
    {
        return (
            _forgeItemContracts[GameConstants.ForgeQuality.SILVER],
            _forgeItemContracts[GameConstants.ForgeQuality.GOLD],
            _forgeItemContracts[GameConstants.ForgeQuality.RAINBOW],
            _forgeItemContracts[GameConstants.ForgeQuality.MYTHIC]
        );
    }

    /// @notice Check if a forge item contract is authorized
    /// @param contractAddress Forge item contract address
    /// @return isAuthorized Whether the contract is authorized
    function isAuthorizedForgeItem(address contractAddress) external view returns (bool) {
        return _isAuthorizedForgeItem[contractAddress];
    }
}
