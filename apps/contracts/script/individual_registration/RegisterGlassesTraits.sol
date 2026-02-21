// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterGlassesTraits - Complete glasses trait registration
contract RegisterGlassesTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.GLASSES);
        console.log("Current glasses traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Glasses traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Glasses Trait Registration ===");

        // Register Monocle (1/5)
        if (currentCount < 1) {
            string memory monocleData = vm.readFile("script/data/glasses_monocle.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.GLASSES, monocleData, "Monocle");
            console.log("Registered: Monocle");
        }

        // Register Round Glasses (2/5)
        if (currentCount < 2) {
            string memory roundglassesData = vm.readFile("script/data/glasses_round_glasses.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.GLASSES, roundglassesData, "Round Glasses");
            console.log("Registered: Round Glasses");
        }

        // Register Square Goggles (3/5)
        if (currentCount < 3) {
            string memory squaregogglesData = vm.readFile("script/data/glasses_square_goggles.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.GLASSES,
                squaregogglesData,
                "Square Goggles"
            );
            console.log("Registered: Square Goggles");
        }

        // Register Visor Tech (4/5)
        if (currentCount < 4) {
            string memory visortechData = vm.readFile("script/data/glasses_visor_tech.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.GLASSES, visortechData, "Visor Tech");
            console.log("Registered: Visor Tech");
        }

        // Register Eye Patch (5/5)
        if (currentCount < 5) {
            string memory eyepatchData = vm.readFile("script/data/glasses_eye_patch.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.GLASSES, eyepatchData, "Eye Patch");
            console.log("Registered: Eye Patch");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.GLASSES);
        console.log("Final glasses traits count:", finalCount);
        console.log("=== Glasses Trait Registration Completed ===");
    }
}
