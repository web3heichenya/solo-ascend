// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterEyesTraits - Complete eyes trait registration
contract RegisterEyesTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.EYES);
        console.log("Current eyes traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Eyes traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Eyes Trait Registration ===");

        // Register Blue Spark (1/5)
        if (currentCount < 1) {
            string memory bluesparkData = vm.readFile("script/data/eyes_blue_spark.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, bluesparkData, "Blue Spark");
            console.log("Registered: Blue Spark");
        }

        // Register Red Glow (2/5)
        if (currentCount < 2) {
            string memory redglowData = vm.readFile("script/data/eyes_red_glow.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, redglowData, "Red Glow");
            console.log("Registered: Red Glow");
        }

        // Register Void Black (3/5)
        if (currentCount < 3) {
            string memory voidblackData = vm.readFile("script/data/eyes_void_black.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, voidblackData, "Void Black");
            console.log("Registered: Void Black");
        }

        // Register Purple Mystic (4/5)
        if (currentCount < 4) {
            string memory purplemysticData = vm.readFile("script/data/eyes_purple_mystic.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, purplemysticData, "Purple Mystic");
            console.log("Registered: Purple Mystic");
        }

        // Register Yellow Cat (5/5)
        if (currentCount < 5) {
            string memory yellowcatData = vm.readFile("script/data/eyes_yellow_cat.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.EYES, yellowcatData, "Yellow Cat");
            console.log("Registered: Yellow Cat");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.EYES);
        console.log("Final eyes traits count:", finalCount);
        console.log("=== Eyes Trait Registration Completed ===");
    }
}
