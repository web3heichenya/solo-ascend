// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterLegsTraits - Complete legs trait registration
contract RegisterLegsTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.LEGS);
        console.log("Current legs traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Legs traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Legs Trait Registration ===");

        // Register Cloth Pants (1/5)
        if (currentCount < 1) {
            string memory clothpantsData = vm.readFile("script/data/legs_cloth_pants.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, clothpantsData, "Cloth Pants");
            console.log("Registered: Cloth Pants");
        }

        // Register Iron Greaves (2/5)
        if (currentCount < 2) {
            string memory irongreavesData = vm.readFile("script/data/legs_iron_greaves.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, irongreavesData, "Iron Greaves");
            console.log("Registered: Iron Greaves");
        }

        // Register Robe Tails Blue (3/5)
        if (currentCount < 3) {
            string memory robetailsblueData = vm.readFile("script/data/legs_robe_tails_blue.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, robetailsblueData, "Robe Tails Blue");
            console.log("Registered: Robe Tails Blue");
        }

        // Register Chain Leggings (4/5)
        if (currentCount < 4) {
            string memory chainleggingsData = vm.readFile("script/data/legs_chain_leggings.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, chainleggingsData, "Chain Leggings");
            console.log("Registered: Chain Leggings");
        }

        // Register Shorts Simple (5/5)
        if (currentCount < 5) {
            string memory shortssimpleData = vm.readFile("script/data/legs_shorts_simple.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.LEGS, shortssimpleData, "Shorts Simple");
            console.log("Registered: Shorts Simple");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.LEGS);
        console.log("Final legs traits count:", finalCount);
        console.log("=== Legs Trait Registration Completed ===");
    }
}
