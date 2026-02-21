// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterMageWeapons - Complete mage weapon registration
contract RegisterMageWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.MAGE);
        console.log("Current mage weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Mage weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Mage Weapon Registration ===");

        // Register Crystal Staff (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_mage_crystal_staff_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_mage_crystal_staff_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_mage_crystal_staff_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.MAGE, stage1, stage2, stage3, "Crystal Staff");
            console.log("Registered: Crystal Staff");
        }

        // Register Spellbook (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_mage_spellbook_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_mage_spellbook_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_mage_spellbook_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.MAGE, stage1, stage2, stage3, "Spellbook");
            console.log("Registered: Spellbook");
        }

        // Register Orb Focus (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_mage_orb_focus_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_mage_orb_focus_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_mage_orb_focus_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.MAGE, stage1, stage2, stage3, "Orb Focus");
            console.log("Registered: Orb Focus");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.MAGE);
        console.log("Final mage weapons count:", finalCount);
        console.log("=== Mage Weapon Registration Completed ===");
    }
}
