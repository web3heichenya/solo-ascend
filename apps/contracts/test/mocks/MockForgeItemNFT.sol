// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IForgeItemNFT} from "../../src/interfaces/IForgeItemNFT.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title MockForgeItemNFT
/// @notice Mock implementation of IForgeItemNFT for testing
contract MockForgeItemNFT is ERC721, IForgeItemNFT {
    mapping(address => bool) public authorizedMinters;
    mapping(uint256 => GameConstants.ForgeEffect) public forgeItems;

    address public forgeEffectRegistry;
    address public forgeCoordinator;
    uint256 private _nextTokenId = 1;
    uint256 public totalMinted;

    constructor(
        string memory name,
        string memory symbol,
        address _forgeEffectRegistry,
        address _forgeCoordinator
    ) ERC721(name, symbol) {
        forgeEffectRegistry = _forgeEffectRegistry;
        forgeCoordinator = _forgeCoordinator;
        authorizedMinters[_forgeCoordinator] = true;
    }

    function isAuthorizedMinter(address minter) external view override returns (bool) {
        return authorizedMinters[minter];
    }

    function getForgeEffectRegistry() external view override returns (address) {
        return forgeEffectRegistry;
    }

    function getForgeCoordinator() external view override returns (address) {
        return forgeCoordinator;
    }

    function getForgeItem(uint256 tokenId) external view override returns (GameConstants.ForgeEffect memory) {
        if (!_exists(tokenId)) revert ItemNotExists();
        return forgeItems[tokenId];
    }

    function exists(uint256 tokenId) external view override returns (bool) {
        return _exists(tokenId);
    }

    function getTotalMinted() external view override returns (uint256) {
        return totalMinted;
    }

    function mint(
        address to,
        GameConstants.ForgeEffectType effectType,
        GameConstants.HeroAttribute attribute,
        uint32 value
    ) external override returns (uint256 tokenId) {
        if (!authorizedMinters[msg.sender]) revert UnauthorizedMinter();
        // Allow minting to address(0) for consumable effects - mint to this contract instead for record keeping
        address actualRecipient = to == address(0) ? address(this) : to;

        tokenId = _nextTokenId++;
        totalMinted++;

        _mint(actualRecipient, tokenId);

        forgeItems[tokenId] = GameConstants.ForgeEffect({
            effectType: effectType,
            quality: GameConstants.ForgeQuality.SILVER, // Default to silver for testing
            attribute: attribute,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        return tokenId;
    }

    function setAuthorizedMinter(address minter, bool authorized) external override {
        // For testing, anyone can set authorized minters
        authorizedMinters[minter] = authorized;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}
