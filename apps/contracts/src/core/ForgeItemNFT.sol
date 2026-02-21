// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {IForgeEffectRegistry} from "../interfaces/IForgeEffectRegistry.sol";
import {IForgeItemNFT} from "../interfaces/IForgeItemNFT.sol";
import {GameConstants} from "../libraries/GameConstants.sol";
import {ForgeItemMetadataLib} from "../libraries/ForgeItemMetadataLib.sol";

/// @title ForgeItemNFT
/// @notice NFT contract for forge items of specific quality
/// @author Solo Ascend Team
contract ForgeItemNFT is ERC721Royalty, Ownable, ReentrancyGuard, IForgeItemNFT {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Current token ID counter
    uint256 private _nextTokenId = 1;

    /// @notice Mapping from token ID to forge item data
    mapping(uint256 => GameConstants.ForgeEffect) private _forgeItems;

    /// @notice Authorized minters (ForgeCoordinator and effect contracts)
    mapping(address => bool) private _authorizedMinters;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Quality of this forge item contract
    GameConstants.ForgeQuality public immutable QUALITY;

    /// @notice Whether items of this quality are soulbound (non-transferable)
    bool public immutable IS_SOULBOUND;

    /// @notice Forge effect registry for dynamic names
    IForgeEffectRegistry public immutable FORGE_EFFECT_REGISTRY;

    /// @notice Forge coordinator for handling attribute updates on transfers and NFT hooks
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Throws if caller is not an authorized minter.
    modifier onlyAuthorizedMinter() {
        if (!_authorizedMinters[msg.sender]) revert UnauthorizedMinter();
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTRUCTOR                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize forge item NFT contract.
    /// @param name NFT collection name.
    /// @param symbol NFT collection symbol.
    /// @param quality Quality of forge items in this contract.
    /// @param admin Contract admin address.
    /// @param forgeEffectRegistry Address of the forge effect registry.
    /// @param forgeCoordinator Address of the forge coordinator.
    constructor(
        string memory name,
        string memory symbol,
        GameConstants.ForgeQuality quality,
        address admin,
        address forgeEffectRegistry,
        address forgeCoordinator
    ) ERC721(name, symbol) Ownable(admin) {
        if (forgeCoordinator == address(0)) revert InvalidAddress();
        if (forgeEffectRegistry == address(0)) revert InvalidAddress();

        QUALITY = quality;
        // Silver and Gold are soulbound, Rainbow and Mythic are tradeable
        IS_SOULBOUND = (quality == GameConstants.ForgeQuality.SILVER || quality == GameConstants.ForgeQuality.GOLD);
        FORGE_EFFECT_REGISTRY = IForgeEffectRegistry(forgeEffectRegistry);
        FORGE_COORDINATOR = IForgeCoordinator(forgeCoordinator);
        _authorizedMinters[forgeCoordinator] = true;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      PUBLIC FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeItemNFT
    function mint(
        address to,
        GameConstants.ForgeEffectType effectType,
        GameConstants.HeroAttribute attribute,
        uint32 value
    ) external override onlyAuthorizedMinter returns (uint256 tokenId) {
        tokenId = _nextTokenId;
        unchecked {
            ++_nextTokenId;
        }

        // Create forge effect data
        _forgeItems[tokenId] = GameConstants.ForgeEffect({
            effectType: effectType,
            quality: QUALITY,
            attribute: attribute,
            value: value,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });

        _update(to, tokenId, address(0));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeItemNFT
    function setAuthorizedMinter(address minter, bool authorized) external override onlyOwner {
        _authorizedMinters[minter] = authorized;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       VIEW FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeItemNFT
    function getForgeItem(uint256 tokenId) external view override returns (GameConstants.ForgeEffect memory) {
        if (_ownerOf(tokenId) == address(0)) revert ItemNotExists();
        return _forgeItems[tokenId];
    }

    /// @inheritdoc IForgeItemNFT
    function exists(uint256 tokenId) public view override returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /// @inheritdoc IForgeItemNFT
    function getTotalMinted() external view override returns (uint256) {
        unchecked {
            return _nextTokenId - 1;
        }
    }

    /// @notice Override tokenURI for dynamic metadata
    /// @param tokenId Token ID
    /// @return Metadata URI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) revert ItemNotExists();

        return _generateTokenURI(tokenId);
    }

    /// @inheritdoc IForgeItemNFT
    function isAuthorizedMinter(address minter) external view override returns (bool authorized) {
        return _authorizedMinters[minter];
    }

    /// @inheritdoc IForgeItemNFT
    function getForgeEffectRegistry() external view override returns (address registry) {
        return address(FORGE_EFFECT_REGISTRY);
    }

    /// @inheritdoc IForgeItemNFT
    function getForgeCoordinator() external view override returns (address coordinator) {
        return address(FORGE_COORDINATOR);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate token URI with dynamic metadata
    /// @param tokenId Token ID
    /// @return JSON metadata string
    function _generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        GameConstants.ForgeEffect memory item = _forgeItems[tokenId];

        string memory effectTypeName = _getEffectTypeString(item.effectType);
        string memory forgerName = _getForgerName(item.effectType);

        return ForgeItemMetadataLib.generateTokenURI(tokenId, item, effectTypeName, forgerName);
    }

    /// @notice Get forger name based on effect type
    /// @param effectType Effect type
    /// @return Forger name
    function _getForgerName(GameConstants.ForgeEffectType effectType) internal view returns (string memory) {
        // Try to get name from registry first if available
        if (address(FORGE_EFFECT_REGISTRY) != address(0)) {
            IForgeEffectRegistry.EffectTypeData memory effectTypeData = FORGE_EFFECT_REGISTRY.getEffectType(effectType);
            if (bytes(effectTypeData.name).length > 0) {
                return string(abi.encodePacked(effectTypeData.name, " Forger"));
            }
        }

        // Fallback to library constants
        return GameConstants.getForgerName(effectType);
    }

    /// @notice Get effect type string
    /// @param effectType Effect type
    /// @return Effect type string
    function _getEffectTypeString(GameConstants.ForgeEffectType effectType) internal view returns (string memory) {
        // Try to get name from registry first if available
        if (address(FORGE_EFFECT_REGISTRY) != address(0)) {
            IForgeEffectRegistry.EffectTypeData memory effectTypeData = FORGE_EFFECT_REGISTRY.getEffectType(effectType);
            if (bytes(effectTypeData.name).length > 0) {
                return effectTypeData.name;
            }
        }

        // Fallback to library constants
        return GameConstants.getEffectTypeName(effectType);
    }

    /// @notice Override update function for soulbound items and enumerable
    /// @param to To address
    /// @param tokenId Token ID
    /// @param auth Authorization address
    /// @return Previous owner
    function _update(address to, uint256 tokenId, address auth) internal override(ERC721) returns (address) {
        address from = _ownerOf(tokenId);

        // Block transfers for soulbound items (except minting and burning)
        if (IS_SOULBOUND && from != address(0) && to != address(0)) {
            revert TransferBlocked();
        }

        // Block transfers for locked items (Mythic after use)
        if (_forgeItems[tokenId].isLocked && from != address(0) && to != address(0)) {
            revert TransferBlocked();
        }

        if (address(FORGE_COORDINATOR) != address(0) && tokenId < _nextTokenId) {
            // Call hook in ForgeCoordinator when _update occurs
            GameConstants.ForgeEffect memory effect = _forgeItems[tokenId];
            FORGE_COORDINATOR.handleForgeItemUpdate(from, to, tokenId, effect.effectType);
            // Mythic items are locked after use
            if (effect.quality == GameConstants.ForgeQuality.MYTHIC && _isHeroTBA(to)) {
                _forgeItems[tokenId].isLocked = true;
            }
        }

        return super._update(to, tokenId, auth);
    }

    /// @notice Check if address is a hero's token-bound account
    /// @param addr Address to check
    /// @return True if address is a hero TBA
    function _isHeroTBA(address addr) internal view returns (bool) {
        if (address(FORGE_COORDINATOR) == address(0) || addr == address(0)) {
            return false;
        }

        // Query the coordinator to check if this address is a TBA
        uint256 heroId = FORGE_COORDINATOR.getHeroIdByAccount(addr);
        return heroId != 0;
    }
}
