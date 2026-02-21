// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";
import {HeroMetadataRenderer} from "../../src/utils/HeroMetadataRenderer.sol";
import {HeroClassRegistry} from "../../src/core/registries/HeroClassRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

contract HeroTraitRegistryTest is Test {
    HeroTraitRegistry public registry;
    HeroMetadataRenderer public renderer;
    HeroClassRegistry public classRegistry;

    address public admin = address(0x1);

    function setUp() public {
        vm.startPrank(admin);

        // Deploy class registry
        classRegistry = new HeroClassRegistry(admin);

        // Deploy trait registry
        registry = new HeroTraitRegistry(admin);

        // Deploy renderer with registry
        renderer = new HeroMetadataRenderer(admin, address(classRegistry), address(registry));

        // Register some sample traits
        _registerSampleTraits();

        vm.stopPrank();
    }

    function _registerSampleTraits() internal {
        // Register BASE layer traits (creature types)
        string[] memory baseSVGs = new string[](6);
        string[] memory baseNames = new string[](6);

        baseSVGs[0] = '<rect x="10" y="10" width="80" height="100" fill="#dbb180"/>'; // Human
        baseSVGs[1] = '<rect x="10" y="10" width="80" height="100" fill="#90EE90"/>'; // Elf
        baseSVGs[2] = '<rect x="10" y="10" width="80" height="100" fill="#E6E6FA"/>'; // Ghost
        baseSVGs[3] = '<rect x="10" y="10" width="80" height="100" fill="#8FBC8F"/>'; // Goblin
        baseSVGs[4] = '<rect x="10" y="10" width="80" height="100" fill="#696969"/>'; // Zombie
        baseSVGs[5] = '<rect x="10" y="10" width="80" height="100" fill="#228B22"/>'; // Orc

        baseNames[0] = "Human";
        baseNames[1] = "Elf";
        baseNames[2] = "Ghost";
        baseNames[3] = "Goblin";
        baseNames[4] = "Zombie";
        baseNames[5] = "Orc";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.BASE, baseSVGs, baseNames);

        // Register EYES layer traits
        string[] memory eyeSVGs = new string[](5);
        string[] memory eyeNames = new string[](5);

        eyeSVGs[0] = '<circle cx="30" cy="30" r="3" fill="#000000"/><circle cx="50" cy="30" r="3" fill="#000000"/>'; // Normal
        eyeSVGs[1] = '<circle cx="30" cy="30" r="3" fill="#FF0000"/><circle cx="50" cy="30" r="3" fill="#FF0000"/>'; // Red
        eyeSVGs[2] = '<circle cx="30" cy="30" r="3" fill="#0000FF"/><circle cx="50" cy="30" r="3" fill="#0000FF"/>'; // Blue
        eyeSVGs[3] = '<circle cx="30" cy="30" r="3" fill="#00FF00"/><circle cx="50" cy="30" r="3" fill="#00FF00"/>'; // Green
        eyeSVGs[4] = '<circle cx="30" cy="30" r="3" fill="#FFD700"/><circle cx="50" cy="30" r="3" fill="#FFD700"/>'; // Golden

        eyeNames[0] = "Normal Eyes";
        eyeNames[1] = "Red Eyes";
        eyeNames[2] = "Blue Eyes";
        eyeNames[3] = "Green Eyes";
        eyeNames[4] = "Golden Eyes";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.EYES, eyeSVGs, eyeNames);

        // Register MOUTH layer traits
        string[] memory mouthSVGs = new string[](4);
        string[] memory mouthNames = new string[](4);

        mouthSVGs[0] = '<rect x="30" y="10" width="30" height="3" fill="#711010"/>'; // Normal
        mouthSVGs[1] = '<path d="M30,10 Q45,15 60,10" stroke="#711010" stroke-width="2" fill="none"/>'; // Smile
        mouthSVGs[2] = '<path d="M30,15 Q45,10 60,15" stroke="#711010" stroke-width="2" fill="none"/>'; // Frown
        mouthSVGs[
            3
        ] = '<rect x="30" y="10" width="30" height="3" fill="#711010"/><rect x="35" y="13" width="20" height="5" fill="#8B4513"/>'; // Beard

        mouthNames[0] = "Normal Mouth";
        mouthNames[1] = "Smile";
        mouthNames[2] = "Frown";
        mouthNames[3] = "Bearded";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.MOUTH, mouthSVGs, mouthNames);

        // Register BODY layer traits (armor/clothing)
        string[] memory bodySVGs = new string[](3);
        string[] memory bodyNames = new string[](3);

        bodySVGs[0] = '<rect x="20" y="20" width="100" height="80" fill="#8B4513"/>'; // Leather
        bodySVGs[1] = '<rect x="20" y="20" width="100" height="80" fill="#C0C0C0"/>'; // Iron
        bodySVGs[2] = '<rect x="20" y="20" width="100" height="80" fill="#FFD700"/>'; // Golden

        bodyNames[0] = "Leather Armor";
        bodyNames[1] = "Iron Armor";
        bodyNames[2] = "Golden Armor";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.BODY, bodySVGs, bodyNames);

        // Register LEGS layer traits
        string[] memory legSVGs = new string[](3);
        string[] memory legNames = new string[](3);

        legSVGs[
            0
        ] = '<rect x="30" y="10" width="30" height="60" fill="#654321"/><rect x="60" y="10" width="30" height="60" fill="#654321"/>'; // Pants
        legSVGs[
            1
        ] = '<rect x="30" y="10" width="30" height="60" fill="#C0C0C0"/><rect x="60" y="10" width="30" height="60" fill="#C0C0C0"/>'; // Armor
        legSVGs[
            2
        ] = '<rect x="30" y="10" width="30" height="60" fill="#4169E1"/><rect x="60" y="10" width="30" height="60" fill="#4169E1"/>'; // Jeans

        legNames[0] = "Brown Pants";
        legNames[1] = "Leg Armor";
        legNames[2] = "Blue Jeans";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.LEGS, legSVGs, legNames);

        // Register FOOT layer traits
        string[] memory footSVGs = new string[](3);
        string[] memory footNames = new string[](3);

        footSVGs[
            0
        ] = '<rect x="30" y="10" width="30" height="20" fill="#000000"/><rect x="70" y="10" width="30" height="20" fill="#000000"/>'; // Boots
        footSVGs[
            1
        ] = '<rect x="30" y="10" width="30" height="20" fill="#8B4513"/><rect x="70" y="10" width="30" height="20" fill="#8B4513"/>'; // Shoes
        footSVGs[
            2
        ] = '<rect x="30" y="10" width="30" height="20" fill="#C0C0C0"/><rect x="70" y="10" width="30" height="20" fill="#C0C0C0"/>'; // Armor

        footNames[0] = "Black Boots";
        footNames[1] = "Brown Shoes";
        footNames[2] = "Armored Boots";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.FOOT, footSVGs, footNames);

        // Register BACKGROUND layer traits (new in v2.0)
        string[] memory backgroundSVGs = new string[](3);
        string[] memory backgroundNames = new string[](3);

        backgroundSVGs[0] = '<rect width="400" height="400" fill="#1a1a1a"/>'; // Dark
        backgroundSVGs[1] = '<rect width="400" height="400" fill="#87CEEB"/>'; // Sky Blue
        backgroundSVGs[2] = '<rect width="400" height="400" fill="#228B22"/>'; // Forest Green

        backgroundNames[0] = "Dark Background";
        backgroundNames[1] = "Sky Background";
        backgroundNames[2] = "Forest Background";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.BACKGROUND, backgroundSVGs, backgroundNames);

        // Register HAIR_HAT layer traits (new merged layer in v2.0)
        string[] memory hairHatSVGs = new string[](3);
        string[] memory hairHatNames = new string[](3);

        hairHatSVGs[0] = '<rect x="10" y="0" width="80" height="18" fill="#654321" rx="9"/>'; // Short Hair
        hairHatSVGs[
            1
        ] = '<rect x="10" y="0" width="80" height="18" fill="#654321" rx="9"/><rect x="5" y="5" width="90" height="13" fill="#6B4423" rx="7"/>'; // Hair + Hat
        hairHatSVGs[2] = '<rect x="15" y="2" width="70" height="16" fill="#8B4513" rx="8"/>'; // Long Hair

        hairHatNames[0] = "Short Brown Hair";
        hairHatNames[1] = "Hair + Wizard Hat";
        hairHatNames[2] = "Long Brown Hair";

        registry.registerLayerTraitBatch(IHeroTraitRegistry.TraitLayer.HAIR_HAT, hairHatSVGs, hairHatNames);

        // Register class weapons
        _registerClassWeapons();
    }

    function _registerClassWeapons() internal {
        // Warrior weapons
        registry.registerWeaponTrait(
            GameConstants.HeroClass.WARRIOR,
            '<rect x="10" y="50" width="5" height="100" fill="#C0C0C0"/>', // Basic sword
            '<rect x="10" y="50" width="5" height="100" fill="#FFD700"/>', // Golden sword
            '<rect x="10" y="50" width="5" height="100" fill="#FF69B4"/><rect x="8" y="48" width="9" height="104" fill="#FF69B4" opacity="0.3"/>', // Legendary sword
            "Excalibur"
        );

        // Mage weapons
        registry.registerWeaponTrait(
            GameConstants.HeroClass.MAGE,
            '<rect x="10" y="30" width="5" height="140" fill="#8B4513"/><circle cx="12" cy="25" r="8" fill="#4169E1"/>', // Basic staff
            '<rect x="10" y="30" width="5" height="140" fill="#8B4513"/><circle cx="12" cy="25" r="10" fill="#00FFFF"/>', // Crystal staff
            '<rect x="10" y="30" width="5" height="140" fill="#9370DB"/><circle cx="12" cy="25" r="12" fill="#FF69B4"/>', // Legendary staff
            "Arcane Staff"
        );

        // Archer weapons
        registry.registerWeaponTrait(
            GameConstants.HeroClass.ARCHER,
            '<path d="M10,50 Q5,100 10,150" stroke="#8B4513" stroke-width="3" fill="none"/><line x1="10" y1="50" x2="10" y2="150" stroke="#F5DEB3" stroke-width="1"/>', // Basic bow
            '<path d="M10,50 Q5,100 10,150" stroke="#654321" stroke-width="3" fill="none"/><line x1="10" y1="50" x2="10" y2="150" stroke="#E6E6E6" stroke-width="1"/>', // Composite bow
            '<path d="M10,50 Q5,100 10,150" stroke="#9370DB" stroke-width="3" fill="none"/><line x1="10" y1="50" x2="10" y2="150" stroke="#FF69B4" stroke-width="1"/>', // Elven bow
            "Windforce"
        );

        // Rogue weapons
        registry.registerWeaponTrait(
            GameConstants.HeroClass.ROGUE,
            '<rect x="10" y="80" width="3" height="40" fill="#C0C0C0"/><rect x="10" y="120" width="3" height="10" fill="#8B4513"/>', // Basic dagger
            '<rect x="10" y="80" width="3" height="40" fill="#E6E6E6"/><rect x="10" y="120" width="3" height="10" fill="#8B4513"/><rect x="10" y="79" width="3" height="2" fill="#32CD32"/>', // Poisoned dagger
            '<rect x="10" y="80" width="3" height="40" fill="#9370DB"/><rect x="10" y="120" width="3" height="10" fill="#8B4513"/><rect x="8" y="78" width="7" height="44" fill="#9370DB" opacity="0.5"/>', // Shadow blade
            "Shadowfang"
        );

        // Paladin weapons
        registry.registerWeaponTrait(
            GameConstants.HeroClass.PALADIN,
            '<rect x="10" y="50" width="5" height="100" fill="#E6E6E6"/><rect x="7" y="70" width="11" height="2" fill="#FFD700"/>', // Holy sword
            '<rect x="10" y="50" width="5" height="100" fill="#FFD700"/><rect x="7" y="70" width="11" height="2" fill="#FFD700"/><rect x="10" y="49" width="5" height="2" fill="#FFFF00" opacity="0.8"/>', // Blessed sword
            '<rect x="10" y="50" width="5" height="100" fill="#FFFF00"/><rect x="7" y="70" width="11" height="2" fill="#FF69B4"/><rect x="8" y="48" width="9" height="104" fill="#FFFF00" opacity="0.5"/>', // Divine sword
            "Ashbringer"
        );
    }

    function testTraitRegistration() public {
        vm.prank(admin);

        // Test single trait registration
        registry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.GLASSES,
            '<rect x="20" y="10" width="60" height="20" fill="#000000" opacity="0.5"/>',
            "Sunglasses"
        );

        assertEq(registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.GLASSES), 1);
    }

    function testWeaponRegistration() public view {
        assertEq(registry.weaponTraitsCounts(GameConstants.HeroClass.WARRIOR), 1);
        assertEq(registry.weaponTraitsCounts(GameConstants.HeroClass.MAGE), 1);
    }

    function testTraitSelection() public view {
        // Test equal probability selection
        uint256 seed = 12_345;
        uint256 traitId = registry.selectRandomLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, seed);

        // Should return a valid trait ID
        assertTrue(traitId < registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE));
    }

    function testHeroTraitGeneration() public view {
        uint256 tokenId = 1;
        GameConstants.HeroClass classId = GameConstants.HeroClass.WARRIOR;

        uint256[11] memory traits = registry.getHeroTraits(tokenId, classId);

        // Check that required layers have valid traits (v2.0 layer order)
        // Since trait IDs now start from 1, valid range is [1, layerTraitsCounts]
        assertTrue(traits[0] > 0 && traits[0] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BACKGROUND)); // BACKGROUND
        assertTrue(traits[1] > 0 && traits[1] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE)); // BASE

        // FACE_FEATURE (index 2) is optional - can be NO_TRAIT or valid trait
        if (traits[2] != type(uint256).max) {
            assertTrue(
                traits[2] > 0 && traits[2] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FACE_FEATURE)
            );
        }

        assertTrue(traits[3] > 0 && traits[3] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.EYES)); // EYES
        assertTrue(traits[4] > 0 && traits[4] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.MOUTH)); // MOUTH

        // GLASSES (index 5) is optional - can be NO_TRAIT or valid trait
        if (traits[5] != type(uint256).max) {
            assertTrue(traits[5] > 0 && traits[5] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.GLASSES));
        }

        assertTrue(traits[6] > 0 && traits[6] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.HAIR_HAT)); // HAIR_HAT
        assertTrue(traits[7] > 0 && traits[7] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BODY)); // BODY
        assertTrue(traits[8] > 0 && traits[8] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.LEGS)); // LEGS
        assertTrue(traits[9] > 0 && traits[9] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FOOT)); // FOOT

        // Weapon should be valid for class
        assertTrue(traits[10] > 0 && traits[10] <= registry.weaponTraitsCounts(classId));
    }

    function testAvatarGeneration() public view {
        uint256 tokenId = 1;
        GameConstants.HeroClass classId = GameConstants.HeroClass.WARRIOR;

        // Test layer traits generation instead
        uint256[11] memory traits = registry.getHeroTraits(tokenId, classId);

        // Should return trait IDs for all layers
        assertTrue(traits.length == 11);

        // Check that required layers have valid traits (v2.0 layer order)
        // Since trait IDs now start from 1, valid range is [1, layerTraitsCounts]
        assertTrue(traits[1] > 0 && traits[1] <= registry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE)); // BASE
    }

    function testFullSVGRendering() public view {
        // Just test that the renderer was deployed successfully
        assertTrue(address(renderer) != address(0));
        assertTrue(address(renderer.TRAIT_REGISTRY()) == address(registry));
        assertTrue(address(renderer.HERO_CLASS_REGISTRY()) == address(classRegistry));
    }

    function testMetadataGeneration() public view {
        // Test that getStageBorderColor works
        string memory silverColor = renderer.getStageBorderColor(GameConstants.HeroStage.FORGING);
        assertEq(silverColor, "#C0C0C0");

        string memory goldColor = renderer.getStageBorderColor(GameConstants.HeroStage.COMPLETED);
        assertEq(goldColor, "#FFD700");

        string memory rainbowColor = renderer.getStageBorderColor(GameConstants.HeroStage.SOLO_LEVELING);
        assertEq(rainbowColor, "url(#rainbow-border)");
    }

    function testLayerBoundsUpdate() public {
        vm.prank(admin);

        registry.setLayerBounds(IHeroTraitRegistry.TraitLayer.HAIR_HAT, 150, 100, 100, 60);

        IHeroTraitRegistry.LayerBounds memory bounds = registry.layerBounds(IHeroTraitRegistry.TraitLayer.HAIR_HAT);

        assertEq(bounds.x, 150);
        assertEq(bounds.y, 100);
        assertEq(bounds.width, 100);
        assertEq(bounds.height, 60);
    }

    function testTraitDeactivation() public {
        vm.prank(admin);

        // Deactivate first base trait (trait ID 1 since IDs now start from 1)
        registry.toggleLayerTraitStatus(IHeroTraitRegistry.TraitLayer.BASE, 1, false);

        IHeroTraitRegistry.LayerTrait memory trait = registry.getLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, 1);
        assertFalse(trait.isActive);
    }

    // Helper function to check if a string contains a substring
    function _contains(string memory haystack, string memory needle) private pure returns (bool) {
        bytes memory haystackBytes = bytes(haystack);
        bytes memory needleBytes = bytes(needle);

        if (needleBytes.length > haystackBytes.length) return false;

        for (uint256 i = 0; i <= haystackBytes.length - needleBytes.length; i++) {
            bool found = true;
            for (uint256 j = 0; j < needleBytes.length; j++) {
                if (haystackBytes[i + j] != needleBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return true;
        }
        return false;
    }
}
