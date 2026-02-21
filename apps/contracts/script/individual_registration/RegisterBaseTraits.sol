// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterBaseTraits - Complete base trait registration
contract RegisterBaseTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE);
        console.log("Current base traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("Base traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Base Trait Registration ===");

        // Register Human (1/5)
        if (currentCount < 1) {
            string memory humanData = vm.readFile("script/data/base_human.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, humanData, "Human");
            console.log("Registered: Human");
        }

        // Register Elf (2/5)
        if (currentCount < 2) {
            string memory elfData = vm.readFile("script/data/base_elf.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, elfData, "Elf");
            console.log("Registered: Elf");
        }

        // Register Undead (3/5)
        if (currentCount < 3) {
            string memory undeadData = vm.readFile("script/data/base_undead.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, undeadData, "Undead");
            console.log("Registered: Undead");
        }

        // Register Orc (4/5)
        if (currentCount < 4) {
            string memory orcData = vm.readFile("script/data/base_orc.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, orcData, "Orc");
            console.log("Registered: Orc");
        }

        // Register Frost Clan (5/5)
        if (currentCount < 5) {
            string memory frostclanData = vm.readFile("script/data/base_frost_clan.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.BASE, frostclanData, "Frost Clan");
            console.log("Registered: Frost Clan");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.BASE);
        console.log("Final base traits count:", finalCount);
        console.log("=== Base Trait Registration Completed ===");
    }
}
