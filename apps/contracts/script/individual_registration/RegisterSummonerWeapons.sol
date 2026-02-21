// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterSummonerWeapons - Complete summoner weapon registration
contract RegisterSummonerWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.SUMMONER);
        console.log("Current summoner weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Summoner weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Summoner Weapon Registration ===");

        // Register Summon Staff (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_summoner_summon_staff_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_summoner_summon_staff_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_summoner_summon_staff_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.SUMMONER, stage1, stage2, stage3, "Summon Staff");
            console.log("Registered: Summon Staff");
        }

        // Register Pact Tome (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_summoner_pact_tome_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_summoner_pact_tome_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_summoner_pact_tome_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.SUMMONER, stage1, stage2, stage3, "Pact Tome");
            console.log("Registered: Pact Tome");
        }

        // Register Bone Bell (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_summoner_bone_bell_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_summoner_bone_bell_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_summoner_bone_bell_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.SUMMONER, stage1, stage2, stage3, "Bone Bell");
            console.log("Registered: Bone Bell");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.SUMMONER);
        console.log("Final summoner weapons count:", finalCount);
        console.log("=== Summoner Weapon Registration Completed ===");
    }
}
