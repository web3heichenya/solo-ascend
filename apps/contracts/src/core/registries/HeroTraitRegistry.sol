// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IHeroTraitRegistry} from "../../interfaces/IHeroTraitRegistry.sol";
import {GameConstants} from "../../libraries/GameConstants.sol";

/// @title HeroTraitRegistry
/// @notice Registry for hero trait layers with deterministic trait selection system
/// @dev This contract manages layered SVG traits for heroes with the following features:
///      - Deterministic trait selection based on tokenId and classId
///      - Support for both required and optional trait layers
///      - Class-specific weapon system with stage variants
///      - Layer bounds system for proper positioning
/// @author Solo Ascend Team
contract HeroTraitRegistry is IHeroTraitRegistry, Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Layer positioning bounds
    mapping(TraitLayer => LayerBounds) private _layerBounds;

    /// @notice Mapping from layer => traitId => Trait data
    mapping(TraitLayer => mapping(uint256 => LayerTrait)) private _layerTraits;

    /// @notice Count of traits per layer
    mapping(TraitLayer => uint256) public override layerTraitsCounts;

    /// @notice Class-specific weapon configurations
    mapping(GameConstants.HeroClass => mapping(uint256 => WeaponTrait)) private _weaponTraits;

    /// @notice Count of weapons per class
    mapping(GameConstants.HeroClass => uint256) public override weaponTraitsCounts;

    /// @notice Required layers that must have a trait
    mapping(TraitLayer => bool) public override requiredLayers;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize HeroTraitRegistry with admin address
    /// @param admin The address that will be granted owner privileges
    constructor(address admin) Ownable(admin) {
        if (admin == address(0)) revert InvalidAddress();
        _initializeLayerBounds();
        _initializeRequiredLayers();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHeroTraitRegistry
    function registerLayerTrait(
        TraitLayer layer,
        string calldata svgData,
        string calldata name
    ) external override onlyOwner {
        if (layer == TraitLayer.WEAPON) revert LayerTraitNotForWeaponLayer();

        uint256 traitId = ++layerTraitsCounts[layer];

        _layerTraits[layer][traitId] = LayerTrait({svgData: svgData, isActive: true, name: name});

        emit LayerTraitRegistered(layer, traitId, name);
    }

    /// @inheritdoc IHeroTraitRegistry
    function registerLayerTraitBatch(
        TraitLayer layer,
        string[] calldata svgDatas,
        string[] calldata names
    ) external override onlyOwner {
        if (layer == TraitLayer.WEAPON) revert LayerTraitNotForWeaponLayer();
        if (svgDatas.length != names.length) revert ArrayLengthMismatch();

        for (uint256 i = 0; i < svgDatas.length; i++) {
            uint256 traitId = ++layerTraitsCounts[layer];

            _layerTraits[layer][traitId] = LayerTrait({svgData: svgDatas[i], isActive: true, name: names[i]});

            emit LayerTraitRegistered(layer, traitId, names[i]);
        }
    }

    /// @inheritdoc IHeroTraitRegistry
    function registerWeaponTrait(
        GameConstants.HeroClass classId,
        string calldata forgingVariant,
        string calldata completedVariant,
        string calldata soloLevelingVariant,
        string calldata name
    ) external override onlyOwner {
        uint256 weaponId = ++weaponTraitsCounts[classId];

        _weaponTraits[classId][weaponId] = WeaponTrait({
            forgingSvg: forgingVariant,
            completedSvg: completedVariant,
            soloLevelingSvg: soloLevelingVariant,
            name: name,
            isActive: true
        });

        emit WeaponTraitRegistered(classId, weaponId, name);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHeroTraitRegistry
    function getLayerTraitSVG(
        TraitLayer layer,
        uint256 traitId
    ) external view override returns (string memory svgData) {
        LayerTrait memory trait = _layerTraits[layer][traitId];
        if (!trait.isActive) revert TraitNotActive();
        return trait.svgData;
    }

    /// @inheritdoc IHeroTraitRegistry
    function getWeaponTraitSVG(
        GameConstants.HeroClass classId,
        uint256 weaponId,
        GameConstants.HeroStage stage
    ) external view override returns (string memory svgData) {
        WeaponTrait memory weapon = _weaponTraits[classId][weaponId];
        if (!weapon.isActive) revert TraitNotActive();
        if (stage == GameConstants.HeroStage.FORGING) {
            return weapon.forgingSvg;
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            return weapon.completedSvg;
        } else {
            return weapon.soloLevelingSvg;
        }
    }

    /// @inheritdoc IHeroTraitRegistry
    function selectRandomLayerTrait(TraitLayer layer, uint256 seed) external view override returns (uint256 traitId) {
        uint256 activeCount = 0;

        // Count active traits
        for (uint256 i = 1; i <= layerTraitsCounts[layer]; i++) {
            if (_layerTraits[layer][i].isActive) {
                activeCount++;
            }
        }

        // Handle empty layers
        if (activeCount == 0) {
            if (requiredLayers[layer]) {
                revert NoActiveTraitsInLayer();
            } else {
                // Optional layer with no traits always returns no trait
                return type(uint256).max;
            }
        }

        // For optional layers, add chance of no trait (20% chance)
        if (!requiredLayers[layer]) {
            uint256 randomCheck = seed % 5; // 0-4, where 0 means no trait
            if (randomCheck == 0) {
                return type(uint256).max; // Indicates no trait
            }
            seed = seed >> 8; // Shift seed for actual trait selection
        }

        // Select random active trait
        uint256 random = seed % activeCount;
        uint256 activeIndex = 0;

        for (uint256 i = 1; i <= layerTraitsCounts[layer]; i++) {
            if (_layerTraits[layer][i].isActive) {
                if (activeIndex == random) {
                    return i;
                }
                activeIndex++;
            }
        }

        revert NoActiveTraitsInLayer();
    }

    /// @inheritdoc IHeroTraitRegistry
    function selectRandomWeaponTrait(
        GameConstants.HeroClass classId,
        uint256 seed
    ) external view override returns (uint256 traitId) {
        uint256 activeCount = 0;
        for (uint256 i = 1; i <= weaponTraitsCounts[classId]; i++) {
            if (_weaponTraits[classId][i].isActive) {
                activeCount++;
            }
        }

        if (activeCount == 0) {
            return type(uint256).max;
        }

        uint256 random = seed % activeCount;
        uint256 activeIndex = 0;

        for (uint256 i = 1; i <= weaponTraitsCounts[classId]; i++) {
            if (_weaponTraits[classId][i].isActive) {
                if (activeIndex == random) {
                    return i;
                }
                activeIndex++;
            }
        }

        revert NoActiveTraitsInLayer();
    }

    /// @inheritdoc IHeroTraitRegistry
    function getHeroTraits(
        uint256 tokenId,
        GameConstants.HeroClass classId
    ) external view override returns (uint256[11] memory layerTraits) {
        // Generate deterministic randomness from tokenId and classId
        uint256 baseSeed = uint256(keccak256(abi.encode(tokenId, classId)));

        // Select traits for each layer (11 layers)
        // SEED DISTRIBUTION STRATEGY:
        // We use bit-shifting to create unique seeds for each layer from the base seed
        // This ensures different layers get different randomness while remaining deterministic
        //
        // How it works:
        // - baseSeed is 256 bits (from keccak256)
        // - Each layer gets 8 bits of unique data: seed >> (layerIndex * 8)
        // - Layer 0: uses bits 255-0   (full seed)
        // - Layer 1: uses bits 255-8   (shifted right 8 bits)
        // - Layer 2: uses bits 255-16  (shifted right 16 bits)
        // - etc...
        // - Layer 11 can use bits 255-88 (shifted right 88 bits)
        //
        // This gives each layer access to different portions of the original
        // cryptographic hash while maintaining deterministic results
        for (uint256 i = 0; i < 11; i++) {
            TraitLayer layer = TraitLayer(i);

            // Create layer-specific seed by right-shifting 8 bits per layer
            uint256 layerSeed = baseSeed >> (i * 8);

            if (layer == TraitLayer.WEAPON) {
                layerTraits[i] = this.selectRandomWeaponTrait(classId, layerSeed);
            } else {
                // Regular trait selection using layer-specific seed
                layerTraits[i] = this.selectRandomLayerTrait(layer, layerSeed);
            }
        }

        return layerTraits;
    }

    /// @inheritdoc IHeroTraitRegistry
    function getLayerTrait(TraitLayer layer, uint256 traitId) external view override returns (LayerTrait memory trait) {
        return _layerTraits[layer][traitId];
    }

    /// @inheritdoc IHeroTraitRegistry
    function getWeaponTrait(
        GameConstants.HeroClass classId,
        uint256 weaponId
    ) external view override returns (WeaponTrait memory weapon) {
        return _weaponTraits[classId][weaponId];
    }

    /// @inheritdoc IHeroTraitRegistry
    function layerBounds(TraitLayer layer) external view override returns (LayerBounds memory bounds) {
        return _layerBounds[layer];
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    ADMIN FUNCTIONS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Update layer positioning bounds for SVG rendering
    /// @dev Layer bounds define where traits can be positioned in the 400x400 canvas
    /// @param layer The layer to update bounds for
    /// @param x X coordinate offset from top-left (0-400)
    /// @param y Y coordinate offset from top-left (0-400)
    /// @param width Maximum width constraint for this layer
    /// @param height Maximum height constraint for this layer
    function setLayerBounds(TraitLayer layer, uint16 x, uint16 y, uint16 width, uint16 height) external onlyOwner {
        _layerBounds[layer] = LayerBounds(x, y, width, height);
        emit LayerBoundsUpdated(layer, x, y, width, height);
    }

    /// @notice Toggle layer trait active status (soft enable/disable)
    /// @dev Inactive traits are excluded from random selection but data is preserved
    /// @param layer The trait layer
    /// @param traitId The trait ID to modify
    /// @param isActive Whether the trait should be active for selection
    function toggleLayerTraitStatus(TraitLayer layer, uint256 traitId, bool isActive) external onlyOwner {
        _layerTraits[layer][traitId].isActive = isActive;
        emit LayerTraitStatusUpdated(layer, traitId, isActive);
    }

    /// @notice Toggle weapon trait active status (soft enable/disable)
    /// @dev Inactive weapons are excluded from random selection but data is preserved
    /// @param classId The hero class
    /// @param weaponId The weapon ID to modify
    /// @param isActive Whether the weapon should be active for selection
    function toggleWeaponTraitStatus(
        GameConstants.HeroClass classId,
        uint256 weaponId,
        bool isActive
    ) external onlyOwner {
        _weaponTraits[classId][weaponId].isActive = isActive;
        emit WeaponTraitStatusUpdated(classId, weaponId, isActive);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize default positioning bounds for all trait layers
    /// @dev Sets up the 400x400 canvas coordinate system with character centered at 200x200
    ///      All bounds are optimized for the v2.0 layer system design
    function _initializeLayerBounds() internal {
        // Updated v2.0 layer bounds from layer-bounds-test.html
        // Canvas is 400x400, character is centered and compact
        // Coordinate system: (0,0) top-left, (400,400) bottom-right

        // BACKGROUND layer - full canvas
        _layerBounds[TraitLayer.BACKGROUND] = LayerBounds(0, 0, 400, 400);

        // Character layers - centered at 200×260, positioned at y=70 for proper balance
        _layerBounds[TraitLayer.BASE] = LayerBounds(100, 70, 200, 260); // Character foundation

        // Head region - positioned within character bounds
        _layerBounds[TraitLayer.EYES] = LayerBounds(165, 95, 70, 16); // Eye level
        _layerBounds[TraitLayer.MOUTH] = LayerBounds(178, 115, 40, 12); // Mouth below eyes, slightly left
        _layerBounds[TraitLayer.FACE_FEATURE] = LayerBounds(160, 75, 80, 50); // Face details (scars, tattoos)
        _layerBounds[TraitLayer.GLASSES] = LayerBounds(160, 90, 80, 22); // Glasses over face features

        // Hair/hat merged layer - positioned above head with overlap (covers 25px of head top)
        _layerBounds[TraitLayer.HAIR_HAT] = LayerBounds(150, 60, 100, 35); // Hair styles or hair+hat combinations

        // Body region - torso armor and clothing (includes arms)
        _layerBounds[TraitLayer.BODY] = LayerBounds(133, 145, 134, 130); // Torso/chest with arms

        // Legs region - leg armor and pants
        _layerBounds[TraitLayer.LEGS] = LayerBounds(160, 265, 80, 70); // Legs/pants

        // Feet region - boots and footwear
        _layerBounds[TraitLayer.FOOT] = LayerBounds(155, 330, 90, 22); // Feet/boots

        // Weapon layer - positioned on right side, vertical orientation
        _layerBounds[TraitLayer.WEAPON] = LayerBounds(270, 125, 65, 170); // Right side weapon
    }

    /// @notice Initialize which layers are required vs optional for hero generation
    /// @dev Required layers must always have a trait selected, optional layers have 20% chance of no trait
    function _initializeRequiredLayers() internal {
        requiredLayers[TraitLayer.BACKGROUND] = true;
        requiredLayers[TraitLayer.BASE] = true;
        requiredLayers[TraitLayer.EYES] = true;
        requiredLayers[TraitLayer.MOUTH] = true;
        requiredLayers[TraitLayer.HAIR_HAT] = true;
        requiredLayers[TraitLayer.BODY] = true;
        requiredLayers[TraitLayer.LEGS] = true;
        requiredLayers[TraitLayer.FOOT] = true;
        requiredLayers[TraitLayer.WEAPON] = true;
        // Optional layers: FACE_FEATURE, GLASSES
    }
}
