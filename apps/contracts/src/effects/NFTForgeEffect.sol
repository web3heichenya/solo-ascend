// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IForgeEffect} from "../interfaces/IForgeEffect.sol";
import {GameConstants} from "../libraries/GameConstants.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";

/// @title NFTForgeEffect
/// @notice NFT reward forge effect - mints from a specific NFT collection
/// @author Solo Ascend Team
contract NFTForgeEffect is IForgeEffect, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the NFT collection is not set
    error NFTCollectionNotSet();
    /// @notice Error thrown when the NFT minting fails
    error NFTMintingFailed();
    /// @notice Error thrown when the effect has already been used
    error EffectAlreadyUsed();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when an NFT reward is created for a hero owner
    /// @param recipient The address that received the NFT reward
    /// @param nftCollection The contract address of the NFT collection
    /// @param tokenId The token ID of the NFT reward
    /// @param quality The quality level that determined the NFT reward
    event NFTRewardCreated(
        address indexed recipient,
        address indexed nftCollection,
        uint256 tokenId,
        GameConstants.ForgeQuality quality
    );

    /// @notice Emitted when the NFT collection contract is updated
    /// @param oldCollection The address of the previous NFT collection
    /// @param newCollection The address of the new NFT collection
    event NFTCollectionSet(address indexed oldCollection, address indexed newCollection);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Current NFT collection contract address
    address private _nftCollection;

    /// @notice Generated effects storage
    mapping(uint256 => GameConstants.ForgeEffect) private _effects;

    /// @notice Quality weights for probability distribution
    mapping(GameConstants.ForgeQuality => uint256) private _qualityWeights;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTANTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Reference to forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Minimum forges required to generate NFT effects
    uint256 public constant MIN_FORGES_REQUIRED = 0;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the NFT Forge Effect contract
    /// @param admin The admin address that will own this contract
    /// @param coordinator Address of the forge coordinator
    constructor(address admin, address coordinator) Ownable(admin) {
        if (coordinator == address(0)) revert InvalidCoordinator();

        FORGE_COORDINATOR = IForgeCoordinator(coordinator);

        // Initialize quality weights
        _initializeQualityWeights();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function generateEffect(
        uint256 /* randomSeed */,
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view returns (GameConstants.ForgeEffect memory effect) {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();
        if (getQualityWeight(quality) == 0) revert InvalidQuality();

        effect = GameConstants.ForgeEffect({
            effectType: GameConstants.ForgeEffectType.NFT,
            quality: quality,
            attribute: GameConstants.HeroAttribute.HP, // Not used for NFT effects
            value: 1,
            createdAt: uint64(block.timestamp),
            isLocked: false
        });
    }

    /// @inheritdoc IForgeEffect
    function executeEffect(
        uint256 heroId,
        GameConstants.ForgeEffect calldata effect,
        uint256 effectId
    ) external override {
        if (msg.sender != address(FORGE_COORDINATOR)) revert InvalidCoordinator();

        // TODO: Mint NFT reward to hero owner

        _effects[effectId] = effect;

        emit EffectApplied(heroId, effectId, effect.value);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Set the NFT collection contract address
    /// @param collection Address of the NFT collection contract
    function setNFTCollection(address collection) external onlyOwner {
        address oldCollection = _nftCollection;
        _nftCollection = collection;
        emit NFTCollectionSet(oldCollection, collection);
    }

    /// @notice Set quality weight for probability distribution
    /// @param quality The quality level to set weight for
    /// @param weight The new weight value
    function setQualityWeight(GameConstants.ForgeQuality quality, uint256 weight) external onlyOwner {
        _qualityWeights[quality] = weight;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IForgeEffect
    function isAvailable(
        GameConstants.ForgeQuality quality,
        uint256 /* totalForges */
    ) external view override returns (bool available) {
        return getQualityWeight(quality) > 0;
    }

    /// @inheritdoc IForgeEffect
    function getQualityWeight(GameConstants.ForgeQuality quality) public view override returns (uint256 weight) {
        return _qualityWeights[quality];
    }

    /// @notice Get effect data
    /// @param effectId Effect ID
    /// @return effect Effect data
    function getEffect(uint256 effectId) external view returns (GameConstants.ForgeEffect memory effect) {
        return _effects[effectId];
    }

    /// @notice Get current NFT collection address
    /// @return collection Current NFT collection address
    function getCurrentNFTCollection() external view returns (address collection) {
        return _nftCollection;
    }

    /// @inheritdoc IForgeEffect
    function getEffectType() external pure override returns (GameConstants.ForgeEffectType) {
        return GameConstants.ForgeEffectType.NFT;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize quality weights with default values
    function _initializeQualityWeights() internal {
        _qualityWeights[GameConstants.ForgeQuality.SILVER] = 0;
        _qualityWeights[GameConstants.ForgeQuality.GOLD] = 10;
        _qualityWeights[GameConstants.ForgeQuality.RAINBOW] = 10;
        _qualityWeights[GameConstants.ForgeQuality.MYTHIC] = 0;
    }
}
