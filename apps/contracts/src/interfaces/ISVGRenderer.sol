// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title ISVGRenderer
/// @notice Interface for on-chain SVG rendering system
/// @author Solo Ascend Team
interface ISVGRenderer {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when attempting to create snapshot for token that already has one
    error SnapshotAlreadyExists(uint256 tokenId);
    /// @notice Error thrown when a class is not found
    error ClassNotFound(GameConstants.HeroClass classId);
    /// @notice Error thrown when hero data is invalid
    error InvalidHeroData();
    /// @notice Error thrown when hero class is not supported
    error UnsupportedClass();
    /// @notice Error thrown when image data exceeds size limits
    error ImageDataTooLarge();
    /// @notice Error thrown when address is invalid
    error InvalidAddress();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when the renderer is updated
    /// @param newRenderer The new renderer address
    event RendererUpdated(address indexed newRenderer);

    /// @notice Emitted when class image data is updated
    /// @param classId The class ID
    /// @param imageData The new image data
    event ClassImageUpdated(uint256 indexed classId, string imageData);

    /// @notice Emitted when HeroAvatarLib library is updated
    /// @param oldLib The previous library address
    /// @param newLib The new library address
    event HeroAvatarLibUpdated(address indexed oldLib, address indexed newLib);

    /// @notice Emitted when a trait snapshot is created for a token
    /// @param tokenId The token ID for which the snapshot was created
    /// @param layerTraits The trait values that were saved in the snapshot
    event TraitSnapshotCreated(uint256 indexed tokenId, uint256[11] layerTraits);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate and save trait snapshot for a token
    /// @param tokenId The token ID to generate traits for
    /// @param classId The hero class to use for trait generation
    /// @return layerTraits The generated trait array that was saved
    function generateAndSaveTraits(
        uint256 tokenId,
        GameConstants.HeroClass classId
    ) external returns (uint256[11] memory layerTraits);

    /// @notice Generate SVG image for a hero
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @return svg Complete SVG markup as string
    function generateSVG(GameConstants.Hero memory hero, uint256 tokenId) external view returns (string memory svg);

    /// @notice Generate metadata JSON for a hero
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @return metadata Complete metadata JSON as string
    function generateMetadata(
        GameConstants.Hero memory hero,
        uint256 tokenId
    ) external view returns (string memory metadata);

    /// @notice Generate metadata JSON for a hero with custom name
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @param customName Custom name for the hero (empty string for default name)
    /// @return metadata Complete metadata JSON as string
    function generateMetadata(
        GameConstants.Hero memory hero,
        uint256 tokenId,
        string calldata customName
    ) external view returns (string memory metadata);

    /// @notice Get base64 encoded data URI for SVG
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @return dataURI Base64 encoded data URI
    function getImageURI(GameConstants.Hero memory hero, uint256 tokenId) external view returns (string memory dataURI);

    /// @notice Get base64 encoded data URI for metadata
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @return dataURI Base64 encoded metadata URI
    function getTokenURI(GameConstants.Hero memory hero, uint256 tokenId) external view returns (string memory dataURI);

    /// @notice Get base64 encoded data URI for metadata with custom name
    /// @param hero Hero data structure
    /// @param tokenId Token ID for the hero
    /// @param customName Custom name for the hero (empty string for default name)
    /// @return dataURI Base64 encoded metadata URI
    function getTokenURI(
        GameConstants.Hero memory hero,
        uint256 tokenId,
        string calldata customName
    ) external view returns (string memory dataURI);

    /// @notice Get border color for hero stage
    /// @param stage Hero stage
    /// @return color Hex color string (e.g., "#FFD700")
    function getStageBorderColor(GameConstants.HeroStage stage) external pure returns (string memory color);
}
