// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "solady/utils/Base64.sol";
import {IHeroClassRegistry} from "../interfaces/IHeroClassRegistry.sol";
import {IHeroTraitRegistry} from "../interfaces/IHeroTraitRegistry.sol";
import {ISVGRenderer} from "../interfaces/ISVGRenderer.sol";
import {GameConstants} from "../libraries/GameConstants.sol";

/// @title HeroMetadataRenderer
/// @notice Layer-based on-chain SVG renderer and metadata generator for hero NFTs
/// @dev This contract provides complete NFT metadata and image generation with:
///      - Layer-based SVG composition system
///      - Stage-dependent weapon rendering
///      - Dynamic border generation based on hero stage
///      - Complete JSON metadata with trait attributes
///      - Base64 encoded data URIs for images and metadata
/// @author Solo Ascend Team
contract HeroMetadataRenderer is ISVGRenderer, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         LIBRARIES                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    using Strings for uint256;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Stores trait snapshots for each token to ensure stable rendering
    mapping(uint256 => uint256[11]) private _tokenTraitSnapshots;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Trait registry for managing layers
    IHeroTraitRegistry public immutable TRAIT_REGISTRY;

    /// @notice Hero class registry reference
    IHeroClassRegistry public immutable HERO_CLASS_REGISTRY;

    /// @notice SVG header with namespace and viewBox for 400x400 canvas
    string private constant _SVG_HEADER = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">';

    /// @notice SVG footer to close the SVG element
    string private constant _SVG_FOOTER = "</svg>";

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the HeroMetadataRenderer with required contract references
    /// @dev Validates that all contract addresses are non-zero and sets immutable references
    /// @param admin The address that will be granted owner privileges
    /// @param heroClassRegistry The address of the HeroClassRegistry contract
    /// @param traitRegistry The address of the HeroTraitRegistry contract
    constructor(address admin, address heroClassRegistry, address traitRegistry) Ownable(admin) {
        if (heroClassRegistry == address(0)) revert InvalidAddress();
        if (traitRegistry == address(0)) revert InvalidAddress();

        HERO_CLASS_REGISTRY = IHeroClassRegistry(heroClassRegistry);
        TRAIT_REGISTRY = IHeroTraitRegistry(traitRegistry);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate and save trait snapshot for a token
    /// @dev This function should be called when minting a new hero to ensure
    ///      stable trait rendering even when new traits are added to the system
    /// @param tokenId The token ID to generate traits for
    /// @param classId The hero class to use for trait generation
    /// @return layerTraits The generated trait array that was saved
    function generateAndSaveTraits(
        uint256 tokenId,
        GameConstants.HeroClass classId
    ) external returns (uint256[11] memory layerTraits) {
        // Check if snapshot already exists
        bool hasSnapshot = _checkSnapshotExists(tokenId);
        if (hasSnapshot) {
            revert SnapshotAlreadyExists(tokenId);
        }

        // Generate trait snapshot using current trait registry state
        layerTraits = TRAIT_REGISTRY.getHeroTraits(tokenId, classId);

        // Save the snapshot
        _tokenTraitSnapshots[tokenId] = layerTraits;

        emit TraitSnapshotCreated(tokenId, layerTraits);
        return layerTraits;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ISVGRenderer
    function generateSVG(
        GameConstants.Hero calldata hero,
        uint256 tokenId
    ) external view override returns (string memory svg) {
        // Get clip path definitions for layer constraints
        string memory clipDefs = _getClipPathDefs();

        // Get the layered hero avatar
        string memory heroLayers = _getHeroAvatar(hero.classId, tokenId, hero.stage);

        // Generate border based on stage
        string memory border = _generateBorder(hero.stage);

        // Combine all elements
        return
            string(
                abi.encodePacked(
                    _SVG_HEADER,
                    clipDefs,
                    _generateBackground(),
                    '<g transform="translate(200,200) scale(1.0)" transform-origin="center">',
                    heroLayers,
                    "</g>",
                    border,
                    _SVG_FOOTER
                )
            );
    }

    /// @inheritdoc ISVGRenderer
    function generateMetadata(
        GameConstants.Hero calldata hero,
        uint256 tokenId
    ) external view override returns (string memory metadata) {
        // Get trait details for metadata (use snapshot if available)
        uint256[11] memory layerTraits = _getHeroTraitsWithSnapshot(tokenId, hero.classId);

        return
            string(
                abi.encodePacked(
                    '{"name":"Solo Ascend Hero #',
                    tokenId.toString(),
                    '","description":"A uniquely generated hero in the Solo Ascend universe with layered traits and progression.",'
                    '"image":"',
                    this.getImageURI(hero, tokenId),
                    '","attributes":[',
                    _generateTraits(hero, layerTraits),
                    "]}"
                )
            );
    }

    /// @inheritdoc ISVGRenderer
    function generateMetadata(
        GameConstants.Hero calldata hero,
        uint256 tokenId,
        string calldata customName
    ) external view override returns (string memory metadata) {
        string memory heroName;
        if (bytes(customName).length > 0) {
            heroName = customName;
        } else {
            heroName = string(abi.encodePacked("Solo Ascend Hero #", tokenId.toString()));
        }

        uint256[11] memory layerTraits = _getHeroTraitsWithSnapshot(tokenId, hero.classId);

        return
            string(
                abi.encodePacked(
                    '{"name":"',
                    heroName,
                    '","description":"A uniquely generated hero in the Solo Ascend universe with layered traits and progression.",'
                    '"image":"',
                    this.getImageURI(hero, tokenId),
                    '","attributes":[',
                    _generateTraits(hero, layerTraits),
                    "]}"
                )
            );
    }

    /// @inheritdoc ISVGRenderer
    function getImageURI(
        GameConstants.Hero calldata hero,
        uint256 tokenId
    ) external view override returns (string memory dataURI) {
        string memory svg = this.generateSVG(hero, tokenId);
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
    }

    /// @inheritdoc ISVGRenderer
    function getTokenURI(
        GameConstants.Hero calldata hero,
        uint256 tokenId
    ) external view override returns (string memory dataURI) {
        string memory metadata = this.generateMetadata(hero, tokenId);
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(metadata))));
    }

    /// @inheritdoc ISVGRenderer
    function getTokenURI(
        GameConstants.Hero calldata hero,
        uint256 tokenId,
        string calldata customName
    ) external view override returns (string memory dataURI) {
        string memory metadata = this.generateMetadata(hero, tokenId, customName);
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(metadata))));
    }

    /// @inheritdoc ISVGRenderer
    function getStageBorderColor(GameConstants.HeroStage stage) external pure override returns (string memory color) {
        if (stage == GameConstants.HeroStage.FORGING) return "#C0C0C0"; // Silver
        if (stage == GameConstants.HeroStage.COMPLETED) return "#FFD700"; // Gold
        if (stage == GameConstants.HeroStage.SOLO_LEVELING) return "url(#rainbow-border)"; // Rainbow gradient
        return "#C0C0C0"; // Default silver
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate complete layered avatar SVG for a hero
    /// @dev Composes all 11 trait layers in correct rendering order with positioning and clipping
    /// @param classId Hero class ID for weapon selection
    /// @param tokenId Token ID for deterministic trait selection
    /// @param stage Hero stage for weapon variant selection
    /// @return avatarSVG Complete layered SVG string ready for embedding
    function _getHeroAvatar(
        GameConstants.HeroClass classId,
        uint256 tokenId,
        GameConstants.HeroStage stage
    ) internal view returns (string memory avatarSVG) {
        // Get trait IDs for all layers (11 layers)
        // Priority: use snapshot if exists, otherwise generate from trait registry
        uint256[11] memory layerTraits = _getHeroTraitsWithSnapshot(tokenId, classId);

        // Build SVG by compositing layers in order
        // Order: BACKGROUND, BASE, EYES, MOUTH, FACE_FEATURE, GLASSES, HAIR_HAT, BODY, LEGS, FOOT, WEAPON
        string memory layers = "";

        // Process each layer (11 layers total)
        for (uint256 i = 0; i < 11; i++) {
            string memory layerSVG = _getLayerSVG(IHeroTraitRegistry.TraitLayer(i), layerTraits[i], classId, stage);

            if (bytes(layerSVG).length > 0) {
                layers = string(abi.encodePacked(layers, layerSVG));
            }
        }

        return layers;
    }

    /// @notice Generate SVG for a specific trait layer with proper positioning and clipping
    /// @dev Handles both regular traits and special weapon logic, applies layer bounds and clipping
    /// @param layer The trait layer type (0-10 for the 11 layers)
    /// @param traitId The selected trait ID (type(uint256).max means no trait for optional layers)
    /// @param classId Hero class (needed for weapon trait selection)
    /// @param stage Hero stage (determines weapon variant to render)
    /// @return layerSVG Complete SVG group element with positioning and clipping applied
    function _getLayerSVG(
        IHeroTraitRegistry.TraitLayer layer,
        uint256 traitId,
        GameConstants.HeroClass classId,
        GameConstants.HeroStage stage
    ) internal view returns (string memory layerSVG) {
        // Skip if no trait selected (for optional layers)
        if (traitId == type(uint256).max) {
            return "";
        }

        // Get layer bounds for proper positioning
        IHeroTraitRegistry.LayerBounds memory bounds = TRAIT_REGISTRY.layerBounds(layer);

        string memory svgContent;

        if (layer == IHeroTraitRegistry.TraitLayer.WEAPON) {
            // Special handling for weapons (class and stage specific)
            svgContent = TRAIT_REGISTRY.getWeaponTraitSVG(classId, traitId, stage);
        } else {
            // Regular trait layers
            svgContent = TRAIT_REGISTRY.getLayerTraitSVG(layer, traitId);
        }

        // Wrap in group with proper positioning (v2.0 coordinate system)
        // Since outer group centers with translate(200,200), layer bounds are relative to that center
        if (bytes(svgContent).length > 0) {
            // Calculate relative position from center (200,200)
            int256 relativeX = int256(uint256(bounds.x)) - 200;
            int256 relativeY = int256(uint256(bounds.y)) - 200;

            return
                string(
                    abi.encodePacked(
                        '<g transform="translate(',
                        Strings.toStringSigned(relativeX),
                        ",",
                        Strings.toStringSigned(relativeY),
                        ')" ',
                        'clip-path="url(#layer-',
                        uint256(layer).toString(),
                        '-clip)">',
                        svgContent,
                        "</g>"
                    )
                );
        }

        return "";
    }

    /// @notice Generate SVG clip path definitions for all trait layers
    /// @dev Creates clipPath elements that constrain each layer to its designated bounds
    /// @return clipDefs SVG defs element containing clipPath definitions for layers 0-10
    function _getClipPathDefs() internal view returns (string memory clipDefs) {
        string memory defs = "<defs>";

        for (uint256 i = 0; i < 11; i++) {
            IHeroTraitRegistry.LayerBounds memory bounds = TRAIT_REGISTRY.layerBounds(IHeroTraitRegistry.TraitLayer(i));

            defs = string(
                abi.encodePacked(
                    defs,
                    '<clipPath id="layer-',
                    i.toString(),
                    '-clip">',
                    '<rect x="0" y="0" width="',
                    uint256(bounds.width).toString(),
                    '" height="',
                    uint256(bounds.height).toString(),
                    '"/>',
                    "</clipPath>"
                )
            );
        }

        return string(abi.encodePacked(defs, "</defs>"));
    }

    /// @notice Generate fallback background when no background trait is available
    /// @dev Provides dark background as fallback, actual backgrounds come from BACKGROUND layer traits
    /// @return SVG rect element with dark background fill
    function _generateBackground() internal pure returns (string memory) {
        return '<rect width="400" height="400" fill="#1a1a1a"/>';
    }

    /// @notice Generate stage-appropriate border SVG with animations
    /// @dev Creates different border styles based on hero stage:
    ///      - FORGING: Silver static border
    ///      - COMPLETED: Gold static border
    ///      - SOLO_LEVELING: Animated rainbow gradient border
    /// @param stage The hero's current stage
    /// @return borderSVG Complete SVG border element with animations if applicable
    function _generateBorder(GameConstants.HeroStage stage) internal pure returns (string memory borderSVG) {
        if (stage == GameConstants.HeroStage.FORGING) {
            // Silver border for forging
            return '<rect x="2" y="2" width="396" height="396" fill="none" stroke="#C0C0C0" stroke-width="4"/>';
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Gold border for completed
            return '<rect x="2" y="2" width="396" height="396" fill="none" stroke="#FFD700" stroke-width="4"/>';
        } else {
            // Animated rainbow border for solo leveling
            return
                string(
                    abi.encodePacked(
                        "<defs>",
                        '<linearGradient id="rainbow-border" x1="0%" y1="0%" x2="100%" y2="100%">',
                        '<stop offset="0%" style="stop-color:#FF69B4">',
                        '<animate attributeName="stop-color" values="#FF69B4;#9370DB;#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4" dur="3s" repeatCount="indefinite"/>',
                        "</stop>",
                        '<stop offset="25%" style="stop-color:#9370DB">',
                        '<animate attributeName="stop-color" values="#9370DB;#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB" dur="3s" repeatCount="indefinite"/>',
                        "</stop>",
                        '<stop offset="50%" style="stop-color:#4169E1">',
                        '<animate attributeName="stop-color" values="#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1" dur="3s" repeatCount="indefinite"/>',
                        "</stop>",
                        '<stop offset="75%" style="stop-color:#00FFFF">',
                        '<animate attributeName="stop-color" values="#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1;#00FFFF" dur="3s" repeatCount="indefinite"/>',
                        "</stop>",
                        '<stop offset="100%" style="stop-color:#00FF00">',
                        '<animate attributeName="stop-color" values="#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1;#00FFFF;#00FF00" dur="3s" repeatCount="indefinite"/>',
                        "</stop>",
                        "</linearGradient>",
                        "</defs>",
                        '<rect x="2" y="2" width="396" height="396" fill="none" stroke="url(#rainbow-border)" stroke-width="4"/>'
                    )
                );
        }
    }

    /// @notice Generate complete JSON traits array for NFT metadata
    /// @dev Combines hero stats, layer traits, and game attributes into OpenSea-compatible format
    /// @param hero The hero data structure with class, stage, and attributes
    /// @param layerTraits Array of trait IDs for all 11 layers
    /// @return JSON string containing all trait objects for metadata
    function _generateTraits(
        GameConstants.Hero memory hero,
        uint256[11] memory layerTraits
    ) internal view returns (string memory) {
        string memory traits = string(
            abi.encodePacked(
                '{"trait_type":"Class","value":"',
                GameConstants.getHeroClassName(hero.classId),
                '"},',
                '{"trait_type":"Stage","value":"',
                GameConstants.getStageName(hero.stage),
                '"},',
                '{"trait_type":"Total Forges","value":',
                uint256(hero.totalForges).toString(),
                "},"
            )
        );

        // Add layer traits
        traits = string(abi.encodePacked(traits, _generateLayerTraits(layerTraits, hero.classId)));

        // Add attribute traits
        traits = string(abi.encodePacked(traits, ",", _generateAttributeTraits(hero.attributes)));

        return traits;
    }

    /// @notice Generate JSON trait objects for all visible layer traits
    /// @dev Converts trait IDs to human-readable names and creates trait objects
    ///      Skips optional layers that have no selected trait (type(uint256).max)
    /// @param layerTraits Array of trait IDs for all 11 layers
    /// @param classId Hero class needed for weapon trait name resolution
    /// @return JSON string containing trait objects for all visible layers
    function _generateLayerTraits(
        uint256[11] memory layerTraits,
        GameConstants.HeroClass classId
    ) internal view returns (string memory) {
        string memory traits = "";
        // Updated v2.0 layer names: BACKGROUND, BASE, EYES, MOUTH, FACE_FEATURE, GLASSES, HAIR_HAT, BODY, LEGS, FOOT, WEAPON
        string[11] memory layerNames = [
            "Background",
            "Base",
            "Face Feature",
            "Eyes",
            "Mouth",
            "Glasses",
            "Hair Hat",
            "Body",
            "Legs",
            "Foot",
            "Weapon"
        ];

        for (uint256 i = 0; i < 11; i++) {
            // Skip traits that weren't randomly selected (optional layers)
            if (layerTraits[i] != type(uint256).max) {
                string memory traitName;

                if (i == 10) {
                    traitName = _getWeaponTraitName(classId, layerTraits[i]);
                } else {
                    traitName = _getLayerTraitName(IHeroTraitRegistry.TraitLayer(i), layerTraits[i]);
                }

                // Only add trait to metadata if name exists and is not empty
                if (bytes(traitName).length > 0) {
                    traits = string(
                        abi.encodePacked(traits, '{"trait_type":"', layerNames[i], '","value":"', traitName, '"},')
                    );
                }
            }
            // Note: Optional layers without selected traits (type(uint256).max) are automatically excluded from metadata
        }

        return traits;
    }

    /// @notice Resolve trait ID to human-readable name from registry
    /// @dev Safely retrieves trait name with error handling for missing/inactive traits
    /// @param layer The trait layer type
    /// @param traitId The trait ID to resolve
    /// @return name Human-readable trait name or empty string if not found/inactive
    function _getLayerTraitName(
        IHeroTraitRegistry.TraitLayer layer,
        uint256 traitId
    ) internal view returns (string memory name) {
        try TRAIT_REGISTRY.getLayerTrait(layer, traitId) returns (IHeroTraitRegistry.LayerTrait memory trait) {
            if (trait.isActive) {
                return trait.name;
            }
            // solhint-disable-next-line no-empty-blocks
        } catch {
            // Trait doesn't exist, ignore error
        }
        return "";
    }

    /// @notice Resolve weapon ID to human-readable name from registry
    /// @dev Safely retrieves weapon name with error handling for missing weapons
    /// @param classId Hero class for weapon lookup
    /// @param weaponId Weapon ID within that class
    /// @return name Human-readable weapon name or empty string if not found
    function _getWeaponTraitName(
        GameConstants.HeroClass classId,
        uint256 weaponId
    ) internal view returns (string memory name) {
        try TRAIT_REGISTRY.getWeaponTrait(classId, weaponId) returns (IHeroTraitRegistry.WeaponTrait memory weapon) {
            return weapon.name;
            // solhint-disable-next-line no-empty-blocks
        } catch {
            // Weapon doesn't exist, ignore error
        }
        return "";
    }

    /// @notice Generate JSON trait objects for all hero game attributes
    /// @dev Converts numeric attributes to trait objects for display in NFT marketplaces
    /// @param attributes Complete hero attributes structure with combat stats
    /// @return JSON string containing trait objects for all 16 game attributes
    function _generateAttributeTraits(
        GameConstants.HeroAttributes memory attributes
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"trait_type":"HP","value":',
                    uint256(attributes.hp).toString(),
                    "},",
                    '{"trait_type":"HP Regen","value":',
                    uint256(attributes.hpRegen).toString(),
                    "},",
                    '{"trait_type":"AD","value":',
                    uint256(attributes.ad).toString(),
                    "},",
                    '{"trait_type":"AP","value":',
                    uint256(attributes.ap).toString(),
                    "},",
                    '{"trait_type":"Attack Speed","value":',
                    uint256(attributes.attackSpeed).toString(),
                    "},",
                    '{"trait_type":"Critical Strike","value":',
                    uint256(attributes.crit).toString(),
                    "},",
                    '{"trait_type":"Armor","value":',
                    uint256(attributes.armor).toString(),
                    "},",
                    '{"trait_type":"Magic Resistance","value":',
                    uint256(attributes.mr).toString(),
                    "},",
                    '{"trait_type":"Cooldown Reduction","value":',
                    uint256(attributes.cdr).toString(),
                    "},",
                    '{"trait_type":"Move Speed","value":',
                    uint256(attributes.moveSpeed).toString(),
                    "},",
                    '{"trait_type":"Lifesteal","value":',
                    uint256(attributes.lifesteal).toString(),
                    "},",
                    '{"trait_type":"Tenacity","value":',
                    uint256(attributes.tenacity).toString(),
                    "},",
                    '{"trait_type":"Penetration","value":',
                    uint256(attributes.penetration).toString(),
                    "},",
                    '{"trait_type":"Mana","value":',
                    uint256(attributes.mana).toString(),
                    "},",
                    '{"trait_type":"Mana Regen","value":',
                    uint256(attributes.manaRegen).toString(),
                    "},",
                    '{"trait_type":"Intelligence","value":',
                    uint256(attributes.intelligence).toString(),
                    "}"
                )
            );
    }

    /// @notice Check if a trait snapshot exists for the given token
    /// @dev Checks if the snapshot array has any non-zero values or type(uint256).max
    /// @param tokenId Token ID to check for snapshot existence
    /// @return exists True if snapshot exists, false otherwise
    function _checkSnapshotExists(uint256 tokenId) internal view returns (bool exists) {
        uint256[11] memory snapshot = _tokenTraitSnapshots[tokenId];

        for (uint256 i = 0; i < 11; i++) {
            if (snapshot[i] != 0) {
                return true;
            }
        }

        return false;
    }

    /// @notice Get hero traits with snapshot priority
    /// @dev If snapshot exists, use it; otherwise generate traits from registry
    /// @param tokenId Token ID to get traits for
    /// @param classId Hero class for trait generation
    /// @return layerTraits Array of trait IDs for all 11 layers
    function _getHeroTraitsWithSnapshot(
        uint256 tokenId,
        GameConstants.HeroClass classId
    ) internal view returns (uint256[11] memory layerTraits) {
        // Check if snapshot exists
        if (_checkSnapshotExists(tokenId)) {
            // Use saved snapshot
            return _tokenTraitSnapshots[tokenId];
        } else {
            // Generate traits from registry (backward compatibility)
            return TRAIT_REGISTRY.getHeroTraits(tokenId, classId);
        }
    }
}
