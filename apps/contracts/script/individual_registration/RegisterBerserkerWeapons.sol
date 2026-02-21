// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterBerserkerWeapons - Complete berserker weapon registration
contract RegisterBerserkerWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.BERSERKER);
        console.log("Current berserker weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Berserker weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Berserker Weapon Registration ===");

        // Register Great Axe (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_berserker_great_axe_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_berserker_great_axe_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_berserker_great_axe_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.BERSERKER, stage1, stage2, stage3, "Great Axe");
            console.log("Registered: Great Axe");
        }

        // Register Spiked Club (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_berserker_spiked_club_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_berserker_spiked_club_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_berserker_spiked_club_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.BERSERKER, stage1, stage2, stage3, "Spiked Club");
            console.log("Registered: Spiked Club");
        }

        // Register Berserker Sword (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_berserker_berserker_sword_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_berserker_berserker_sword_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_berserker_berserker_sword_stage3.txt");

            traitRegistry.registerWeaponTrait(
                GameConstants.HeroClass.BERSERKER,
                stage1,
                stage2,
                stage3,
                "Berserker Sword"
            );
            console.log("Registered: Berserker Sword");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.BERSERKER);
        console.log("Final berserker weapons count:", finalCount);
        console.log("=== Berserker Weapon Registration Completed ===");
    }
}
