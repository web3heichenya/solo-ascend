// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IForgeItemNFT
/// @notice Interface for the ForgeItemNFT contract
/// @author Solo Ascend Team
interface IForgeItemNFT is IERC721 {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the caller is not authorized to mint
    error UnauthorizedMinter();
    /// @notice Error thrown when the forge item is invalid
    error InvalidForgeItem();
    /// @notice Error thrown when the transfer is blocked
    error TransferBlocked();
    /// @notice Error thrown when the item does not exist
    error ItemNotExists();
    /// @notice Error thrown when the address is invalid
    error InvalidAddress();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Check if address is authorized minter
    /// @param minter Address to check
    /// @return authorized Whether address can mint
    function isAuthorizedMinter(address minter) external view returns (bool authorized);

    /// @notice Get forge effect registry address
    /// @return registry ForgeEffectRegistry contract address
    function getForgeEffectRegistry() external view returns (address registry);

    /// @notice Get forge coordinator address
    /// @return coordinator ForgeCoordinator contract address
    function getForgeCoordinator() external view returns (address coordinator);

    /// @notice Get forge item data
    /// @param tokenId Token ID to query
    /// @return ForgeEffect data
    function getForgeItem(uint256 tokenId) external view returns (GameConstants.ForgeEffect memory);

    /// @notice Check if token exists
    /// @param tokenId Token ID to check
    /// @return True if token exists
    function exists(uint256 tokenId) external view returns (bool);

    /// @notice Get total supply of forge items
    /// @return Total number of minted items (including burned)
    function getTotalMinted() external view returns (uint256);

    /// @notice Mint a new forge item
    /// @param to Address to mint to
    /// @param effectType Type of forge effect
    /// @param attribute Hero attribute (for ATTRIBUTE/ENHANCE effects)
    /// @param value Effect value
    /// @return tokenId The newly minted token ID
    function mint(
        address to,
        GameConstants.ForgeEffectType effectType,
        GameConstants.HeroAttribute attribute,
        uint32 value
    ) external returns (uint256 tokenId);

    /// @notice Set authorized minter
    /// @param minter Address to authorize/deauthorize
    /// @param authorized Whether to authorize or deauthorize
    function setAuthorizedMinter(address minter, bool authorized) external;
}
