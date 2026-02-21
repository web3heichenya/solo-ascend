// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterFootTraits - Complete foot trait registration
contract RegisterFootTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FOOT);
        console.log("Current foot traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Foot traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Foot Trait Registration ===");

        // Register Leather Boots (1/5)
        if (currentCount < 1) {
            string memory leatherbootsData = vm.readFile("script/data/foot_leather_boots.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FOOT, leatherbootsData, "Leather Boots");
            console.log("Registered: Leather Boots");
        }

        // Register Iron Sabatons (2/5)
        if (currentCount < 2) {
            string memory ironsabatonsData = vm.readFile("script/data/foot_iron_sabatons.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FOOT, ironsabatonsData, "Iron Sabatons");
            console.log("Registered: Iron Sabatons");
        }

        // Register Gold Rune Shoes (3/5)
        if (currentCount < 3) {
            string memory goldruneshoesData = vm.readFile("script/data/foot_gold_rune_shoes.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FOOT, goldruneshoesData, "Gold Rune Shoes");
            console.log("Registered: Gold Rune Shoes");
        }

        // Register Sandals Strapped (4/5)
        if (currentCount < 4) {
            string memory sandalsstrappedData = vm.readFile("script/data/foot_sandals_strapped.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.FOOT,
                sandalsstrappedData,
                "Sandals Strapped"
            );
            console.log("Registered: Sandals Strapped");
        }

        // Register Armored Greaves (5/5)
        if (currentCount < 5) {
            string memory armoredgreavesData = vm.readFile("script/data/foot_armored_greaves.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.FOOT, armoredgreavesData, "Armored Greaves");
            console.log("Registered: Armored Greaves");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.FOOT);
        console.log("Final foot traits count:", finalCount);
        console.log("=== Foot Trait Registration Completed ===");
    }
}
