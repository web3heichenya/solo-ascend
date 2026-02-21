// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterPriestWeapons - Complete priest weapon registration
contract RegisterPriestWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.PRIEST);
        console.log("Current priest weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Priest weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Priest Weapon Registration ===");

        // Register Holy Staff (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_priest_holy_staff_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_priest_holy_staff_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_priest_holy_staff_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.PRIEST, stage1, stage2, stage3, "Holy Staff");
            console.log("Registered: Holy Staff");
        }

        // Register Chalice (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_priest_chalice_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_priest_chalice_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_priest_chalice_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.PRIEST, stage1, stage2, stage3, "Chalice");
            console.log("Registered: Chalice");
        }

        // Register Holy Tome (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_priest_holy_tome_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_priest_holy_tome_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_priest_holy_tome_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.PRIEST, stage1, stage2, stage3, "Holy Tome");
            console.log("Registered: Holy Tome");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.PRIEST);
        console.log("Final priest weapons count:", finalCount);
        console.log("=== Priest Weapon Registration Completed ===");
    }
}
