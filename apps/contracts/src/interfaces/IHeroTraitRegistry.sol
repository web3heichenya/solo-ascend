// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IHeroTraitRegistry
/// @notice Interface for hero trait registry that manages layered SVG traits with deterministic selection
/// @dev Defines the contract interface for:
///      - Layer-based trait registration and management
///      - Deterministic trait selection using tokenId/classId seeds
///      - Class-specific weapon system with stage variants
///      - SVG rendering bounds and positioning system
/// @author Solo Ascend Team
interface IHeroTraitRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when the address is invalid
    error InvalidAddress();
    /// @notice Error thrown when the layer is invalid
    error InvalidLayer();
    /// @notice Error thrown when array lengths don't match
    error ArrayLengthMismatch();
    /// @notice Error thrown when the trait is not active
    error TraitNotActive();
    /// @notice Error thrown when there are no active traits in the layer
    error NoActiveTraitsInLayer();
    /// @notice Error thrown when weapon trait is used for non-weapon layer
    error WeaponTraitOnlyForWeaponLayer();
    /// @notice Error thrown when layer trait is used for weapon layer
    error LayerTraitNotForWeaponLayer();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a layer trait is registered
    /// @param layer The trait layer
    /// @param traitId The trait ID
    /// @param name The trait name
    event LayerTraitRegistered(TraitLayer indexed layer, uint256 indexed traitId, string name);

    /// @notice Emitted when a weapon trait is registered
    /// @param classId The hero class
    /// @param weaponId The weapon ID
    /// @param name The weapon name
    event WeaponTraitRegistered(GameConstants.HeroClass indexed classId, uint256 indexed weaponId, string name);

    /// @notice Emitted when a trait is deactivated
    /// @param layer The trait layer
    /// @param traitId The trait ID
    /// @param isActive The status to set
    event LayerTraitStatusUpdated(TraitLayer indexed layer, uint256 indexed traitId, bool isActive);

    /// @notice Emitted when a weapon trait is activated
    /// @param classId The hero class
    /// @param weaponId The weapon ID
    /// @param isActive The status to set
    event WeaponTraitStatusUpdated(GameConstants.HeroClass indexed classId, uint256 indexed weaponId, bool isActive);

    /// @notice Emitted when layer bounds are updated
    /// @param layer The trait layer
    /// @param x X coordinate offset
    /// @param y Y coordinate offset
    /// @param width Width constraint
    /// @param height Height constraint
    event LayerBoundsUpdated(TraitLayer indexed layer, uint16 x, uint16 y, uint16 width, uint16 height);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           ENUMS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Different layers that compose the final hero image (excluding BORDER)
    enum TraitLayer {
        BACKGROUND, // Layer 0: Full canvas background (400x400) - REQUIRED
        BASE, // Layer 1: Base creature type (human, elf, ghost, goblin, zombie, orc) - REQUIRED
        FACE_FEATURE, // Layer 2: Scars, tattoos, etc.
        EYES, // Layer 3: Eye types - REQUIRED
        MOUTH, // Layer 4: Mouth and facial expressions - REQUIRED
        GLASSES, // Layer 5: Glasses/eyewear (renders over face features)
        HAIR_HAT, // Layer 6: Hairstyles OR hair+headwear combinations - REQUIRED
        BODY, // Layer 7: Armor, clothing - REQUIRED
        LEGS, // Layer 8: Leg armor, pants - REQUIRED
        FOOT, // Layer 9: Boots, shoes - REQUIRED
        WEAPON // Layer 10: Class-specific weapons (3 stages) - REQUIRED
    }
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Layer bounds to ensure proper positioning
    struct LayerBounds {
        uint16 x; // X coordinate offset
        uint16 y; // Y coordinate offset
        uint16 width; // Width constraint
        uint16 height; // Height constraint
    }

    /// @notice Trait data for a specific layer variant
    struct LayerTrait {
        string svgData; // The SVG data for this trait
        bool isActive; // Whether this trait is currently active
        string name; // Name of the trait (e.g., "Warrior Helmet")
    }

    /// @notice Weapon configuration for class-specific weapons
    struct WeaponTrait {
        string forgingSvg; // SVG data for FORGING stage
        string completedSvg; // SVG data for COMPLETED stage
        string soloLevelingSvg; // SVG data for SOLO_LEVELING stage
        string name; // Weapon name
        bool isActive; // Whether this weapon is currently active
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Register a new layer trait for a specific layer (non-weapon)
    /// @param layer The layer this trait belongs to
    /// @param svgData The SVG data for this trait
    /// @param name The name of this trait
    function registerLayerTrait(TraitLayer layer, string calldata svgData, string calldata name) external;

    /// @notice Register a batch of layer traits for efficiency (non-weapon)
    /// @param layer The layer these traits belong to
    /// @param svgDatas Array of SVG data
    /// @param names Array of trait names
    function registerLayerTraitBatch(TraitLayer layer, string[] calldata svgDatas, string[] calldata names) external;

    /// @notice Register a weapon trait for a specific class
    /// @param classId The hero class this weapon belongs to
    /// @param forgingVariant SVG for FORGING stage
    /// @param completedVariant SVG for COMPLETED stage
    /// @param soloLevelingVariant SVG for SOLO_LEVELING stage
    /// @param name Weapon name
    function registerWeaponTrait(
        GameConstants.HeroClass classId,
        string calldata forgingVariant,
        string calldata completedVariant,
        string calldata soloLevelingVariant,
        string calldata name
    ) external;

    /// @notice Update layer bounds for proper positioning
    /// @param layer The layer to update
    /// @param x X coordinate offset
    /// @param y Y coordinate offset
    /// @param width Width constraint
    /// @param height Height constraint
    function setLayerBounds(TraitLayer layer, uint16 x, uint16 y, uint16 width, uint16 height) external;

    /// @notice Deactivate a trait (soft delete)
    /// @param layer The trait layer
    /// @param traitId The trait to deactivate
    /// @param isActive The status to set
    function toggleLayerTraitStatus(TraitLayer layer, uint256 traitId, bool isActive) external;

    /// @notice Activate a weapon trait (soft delete)
    /// @param classId The hero class
    /// @param weaponId The weapon ID
    /// @param isActive The status to set
    function toggleWeaponTraitStatus(GameConstants.HeroClass classId, uint256 weaponId, bool isActive) external;

    /// @notice Get layer trait SVG data for rendering
    /// @param layer The trait layer
    /// @param traitId The specific trait ID
    /// @return svgData The SVG data for this trait
    function getLayerTraitSVG(TraitLayer layer, uint256 traitId) external view returns (string memory svgData);

    /// @notice Get weapon trait SVG for a specific class and stage
    /// @param classId The hero class
    /// @param weaponId The weapon ID within that class
    /// @param stage The hero's current stage
    /// @return svgData The weapon SVG for the given stage
    function getWeaponTraitSVG(
        GameConstants.HeroClass classId,
        uint256 weaponId,
        GameConstants.HeroStage stage
    ) external view returns (string memory svgData);

    /// @notice Get all traits for a hero based on tokenId and classId
    /// @param tokenId The hero's token ID (used for randomness)
    /// @param classId The hero's class
    /// @return layerTraits Array of trait IDs for each layer (11 layers)
    function getHeroTraits(
        uint256 tokenId,
        GameConstants.HeroClass classId
    ) external view returns (uint256[11] memory layerTraits);

    /// @notice Select a random layer trait based on equal probability
    /// @param layer The trait layer
    /// @param seed Random seed for selection
    /// @return traitId The selected trait ID (returns type(uint256).max for empty optional layers)
    function selectRandomLayerTrait(TraitLayer layer, uint256 seed) external view returns (uint256 traitId);

    /// @notice Select a random weapon trait based on equal probability
    /// @param classId The hero class
    /// @param seed Random seed for selection
    /// @return traitId The selected trait ID (returns type(uint256).max for empty optional layers)
    function selectRandomWeaponTrait(
        GameConstants.HeroClass classId,
        uint256 seed
    ) external view returns (uint256 traitId);

    /// @notice Get layer trait data
    /// @param layer The trait layer
    /// @param traitId The trait ID
    /// @return trait The trait data
    function getLayerTrait(TraitLayer layer, uint256 traitId) external view returns (LayerTrait memory trait);

    /// @notice Get weapon trait data
    /// @param classId The hero class
    /// @param weaponId The weapon ID
    /// @return weapon The weapon configuration
    function getWeaponTrait(
        GameConstants.HeroClass classId,
        uint256 weaponId
    ) external view returns (WeaponTrait memory weapon);

    /// @notice Get trait count for a layer
    /// @param layer The trait layer
    /// @return count Number of traits in the layer
    function layerTraitsCounts(TraitLayer layer) external view returns (uint256 count);

    /// @notice Get weapon count for a class
    /// @param classId The hero class
    /// @return count Number of weapons for the class
    function weaponTraitsCounts(GameConstants.HeroClass classId) external view returns (uint256 count);

    /// @notice Get layer bounds
    /// @param layer The trait layer
    /// @return bounds The layer bounds
    function layerBounds(TraitLayer layer) external view returns (LayerBounds memory bounds);

    /// @notice Check if layer is required
    /// @param layer The trait layer
    /// @return required Whether the layer is required
    function requiredLayers(TraitLayer layer) external view returns (bool required);
}
