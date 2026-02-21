// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title TestHelpers
/// @notice Helper functions for testing Solo Ascend contracts
contract TestHelpers is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    address constant ALICE = address(0x1);
    address constant BOB = address(0x2);
    address constant CHARLIE = address(0x3);
    address constant DAVE = address(0x4);
    address constant EVE = address(0x5);

    uint256 constant MINT_PRICE = GameConstants.MINT_PRICE;
    uint256 constant TREASURY_FEE = GameConstants.TREASURY_FEE;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      HELPER FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Fund an address with ETH
    function fundAccount(address account, uint256 amount) internal {
        vm.deal(account, amount);
    }

    /// @notice Fund multiple accounts with ETH
    function fundAccounts(address[] memory accounts, uint256 amount) internal {
        for (uint256 i = 0; i < accounts.length; i++) {
            vm.deal(accounts[i], amount);
        }
    }

    /// @notice Advance time by specified seconds
    function advanceTime(uint256 seconds_) internal {
        vm.warp(block.timestamp + seconds_);
    }

    /// @notice Advance time to next day (24 hours)
    function advanceToNextDay() internal {
        vm.warp(block.timestamp + 1 days);
    }

    /// @notice Generate a random seed based on current state
    function generateRandomSeed(uint256 nonce) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, nonce)));
    }

    /// @notice Create array of addresses for testing
    function createAddressArray(uint256 count) internal pure returns (address[] memory) {
        address[] memory addresses = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            addresses[i] = address(uint160(i + 100)); // Start from 100 to avoid zero address
        }
        return addresses;
    }

    /// @notice Create hero attributes for testing
    function createTestHeroAttributes() internal pure returns (GameConstants.HeroAttributes memory) {
        return
            GameConstants.HeroAttributes({
                hp: 1000,
                hpRegen: 10,
                ad: 100,
                ap: 80,
                attackSpeed: 150,
                crit: 20,
                armor: 50,
                mr: 40,
                cdr: 10,
                moveSpeed: 300,
                lifesteal: 15,
                tenacity: 50,
                penetration: 30,
                mana: 500,
                manaRegen: 20,
                intelligence: 75
            });
    }

    /// @notice Create hero class data for testing
    function createTestHeroClassData(string memory name) internal view returns (GameConstants.HeroClassData memory) {
        return
            GameConstants.HeroClassData({
                name: name,
                description: "Test class description",
                baseAttributes: createTestHeroAttributes(),
                createdAt: uint64(block.timestamp)
            });
    }

    /// @notice Assert hero attributes are equal
    function assertEqHeroAttributes(
        GameConstants.HeroAttributes memory actual,
        GameConstants.HeroAttributes memory expected,
        string memory message
    ) internal pure {
        assertEq(actual.hp, expected.hp, string(abi.encodePacked(message, ": hp mismatch")));
        assertEq(actual.hpRegen, expected.hpRegen, string(abi.encodePacked(message, ": hpRegen mismatch")));
        assertEq(actual.ad, expected.ad, string(abi.encodePacked(message, ": ad mismatch")));
        assertEq(actual.ap, expected.ap, string(abi.encodePacked(message, ": ap mismatch")));
        assertEq(actual.attackSpeed, expected.attackSpeed, string(abi.encodePacked(message, ": attackSpeed mismatch")));
        assertEq(actual.crit, expected.crit, string(abi.encodePacked(message, ": crit mismatch")));
        assertEq(actual.armor, expected.armor, string(abi.encodePacked(message, ": armor mismatch")));
        assertEq(actual.mr, expected.mr, string(abi.encodePacked(message, ": mr mismatch")));
        assertEq(actual.cdr, expected.cdr, string(abi.encodePacked(message, ": cdr mismatch")));
        assertEq(actual.moveSpeed, expected.moveSpeed, string(abi.encodePacked(message, ": moveSpeed mismatch")));
    }

    /// @notice Check if address is a contract
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    /// @notice Expect custom error with parameters
    function expectCustomError(bytes4 selector, bytes memory data) internal {
        vm.expectRevert(abi.encodeWithSelector(selector, data));
    }

    /// @notice Get current block timestamp
    function getCurrentTimestamp() internal view returns (uint256) {
        return block.timestamp;
    }

    /// @notice Calculate percentage of value
    function calculatePercentage(uint256 value, uint256 percentage) internal pure returns (uint256) {
        return (value * percentage) / 10_000; // Using basis points
    }
}
