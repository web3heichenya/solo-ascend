// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterMouthTraits - Complete mouth trait registration
contract RegisterMouthTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.MOUTH);
        console.log("Current mouth traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Mouth traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Mouth Trait Registration ===");

        // Register Grit Teeth (1/5)
        if (currentCount < 1) {
            string memory gritteethData = vm.readFile("script/data/mouth_grit_teeth.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, gritteethData, "Grit Teeth");
            console.log("Registered: Grit Teeth");
        }

        // Register Surprised Open (2/5)
        if (currentCount < 2) {
            string memory surprisedopenData = vm.readFile("script/data/mouth_surprised_open.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, surprisedopenData, "Surprised Open");
            console.log("Registered: Surprised Open");
        }

        // Register Simple Smile (3/5)
        if (currentCount < 3) {
            string memory simplesmileData = vm.readFile("script/data/mouth_smile_simple.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, simplesmileData, "Simple Smile");
            console.log("Registered: Simple Smile");
        }

        // Register Neutral Line (4/5)
        if (currentCount < 4) {
            string memory neutrallineData = vm.readFile("script/data/mouth_neutral_line.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, neutrallineData, "Neutral Line");
            console.log("Registered: Neutral Line");
        }

        // Register Fangs Vampire (5/5)
        if (currentCount < 5) {
            string memory fangsvampireData = vm.readFile("script/data/mouth_fangs_vampire.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.MOUTH, fangsvampireData, "Fangs Vampire");
            console.log("Registered: Fangs Vampire");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.MOUTH);
        console.log("Final mouth traits count:", finalCount);
        console.log("=== Mouth Trait Registration Completed ===");
    }
}
