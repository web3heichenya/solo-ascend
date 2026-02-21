// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterFaceFeatureTraits - Complete facefeature trait registration
contract RegisterFaceFeatureTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FACE_FEATURE);
        console.log("Current facefeature traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("FaceFeature traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing FaceFeature Trait Registration ===");

        // Register Blue Tattoo (1/5)
        if (currentCount < 1) {
            string memory bluetattooData = vm.readFile("script/data/face_feature_blue_tattoo.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FACE_FEATURE, bluetattooData, "Blue Tattoo");
            console.log("Registered: Blue Tattoo");
        }

        // Register Scar Cheek (2/5)
        if (currentCount < 2) {
            string memory scarcheekData = vm.readFile("script/data/face_feature_scar_cheek.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FACE_FEATURE, scarcheekData, "Scar Cheek");
            console.log("Registered: Scar Cheek");
        }

        // Register Warpaint Red (3/5)
        if (currentCount < 3) {
            string memory warpaintredData = vm.readFile("script/data/face_feature_warpaint_red.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.FACE_FEATURE,
                warpaintredData,
                "Warpaint Red"
            );
            console.log("Registered: Warpaint Red");
        }

        // Register Freckles (4/5)
        if (currentCount < 4) {
            string memory frecklesData = vm.readFile("script/data/face_feature_freckles.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FACE_FEATURE, frecklesData, "Freckles");
            console.log("Registered: Freckles");
        }

        // Register Tribal White (5/5)
        if (currentCount < 5) {
            string memory tribalwhiteData = vm.readFile("script/data/face_feature_tribal_white.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.FACE_FEATURE,
                tribalwhiteData,
                "Tribal White"
            );
            console.log("Registered: Tribal White");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FACE_FEATURE);
        console.log("Final facefeature traits count:", finalCount);
        console.log("=== FaceFeature Trait Registration Completed ===");
    }
}
