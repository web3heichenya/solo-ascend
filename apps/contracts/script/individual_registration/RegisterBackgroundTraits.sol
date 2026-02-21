// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterBackgroundTraits - Complete background trait registration
contract RegisterBackgroundTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BACKGROUND);
        console.log("Current background traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Background traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Background Trait Registration ===");

        // Register Forest Dawn (1/5)
        if (currentCount < 1) {
            string memory forestdawnData = vm.readFile("script/data/background_forest_dawn.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BACKGROUND, forestdawnData, "Forest Dawn");
            console.log("Registered: Forest Dawn");
        }

        // Register Basalt Lavafield (2/5)
        if (currentCount < 2) {
            string memory basaltlavafieldData = vm.readFile("script/data/background_basalt_lavafield.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.BACKGROUND,
                basaltlavafieldData,
                "Basalt Lavafield"
            );
            console.log("Registered: Basalt Lavafield");
        }

        // Register Cavern Torchlight (3/5)
        if (currentCount < 3) {
            string memory caverntorchlightData = vm.readFile("script/data/background_cavern_torchlight.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.BACKGROUND,
                caverntorchlightData,
                "Cavern Torchlight"
            );
            console.log("Registered: Cavern Torchlight");
        }

        // Register Mountain Sunset (4/5)
        if (currentCount < 4) {
            string memory mountainsunsetData = vm.readFile("script/data/background_mountain_sunset.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.BACKGROUND,
                mountainsunsetData,
                "Mountain Sunset"
            );
            console.log("Registered: Mountain Sunset");
        }

        // Register Underwater Ruins (5/5)
        if (currentCount < 5) {
            string memory underwaterruinsData = vm.readFile("script/data/background_underwater_ruins.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.BACKGROUND,
                underwaterruinsData,
                "Underwater Ruins"
            );
            console.log("Registered: Underwater Ruins");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BACKGROUND);
        console.log("Final background traits count:", finalCount);
        console.log("=== Background Trait Registration Completed ===");
    }
}
