// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterBodyTraits - Complete body trait registration
contract RegisterBodyTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BODY);
        console.log("Current body traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Body traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Body Trait Registration ===");

        // Register Cloth Tunic (1/5)
        if (currentCount < 1) {
            string memory clothtunicData = vm.readFile("script/data/body_cloth_tunic.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, clothtunicData, "Cloth Tunic");
            console.log("Registered: Cloth Tunic");
        }

        // Register Iron Cuirass (2/5)
        if (currentCount < 2) {
            string memory ironcuirassData = vm.readFile("script/data/body_iron_cuirass.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, ironcuirassData, "Iron Cuirass");
            console.log("Registered: Iron Cuirass");
        }

        // Register Gold Robe Runes (3/5)
        if (currentCount < 3) {
            string memory goldroberunesData = vm.readFile("script/data/body_gold_robe_runes.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, goldroberunesData, "Gold Robe Runes");
            console.log("Registered: Gold Robe Runes");
        }

        // Register Leather Vest (4/5)
        if (currentCount < 4) {
            string memory leathervestData = vm.readFile("script/data/body_leather_vest.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, leathervestData, "Leather Vest");
            console.log("Registered: Leather Vest");
        }

        // Register Diamond Plate (5/5)
        if (currentCount < 5) {
            string memory diamondplateData = vm.readFile("script/data/body_diamond_plate.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BODY, diamondplateData, "Diamond Plate");
            console.log("Registered: Diamond Plate");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BODY);
        console.log("Final body traits count:", finalCount);
        console.log("=== Body Trait Registration Completed ===");
    }
}
