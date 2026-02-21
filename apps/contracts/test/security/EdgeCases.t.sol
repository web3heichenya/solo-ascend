// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {ForgeCoordinator} from "../../src/core/ForgeCoordinator.sol";
import {SoloAscendHero} from "../../src/core/SoloAscendHero.sol";
import {Treasury} from "../../src/core/Treasury.sol";
import {HeroClassRegistry} from "../../src/core/registries/HeroClassRegistry.sol";
import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {OracleRegistry} from "../../src/core/registries/OracleRegistry.sol";
import {HookRegistry} from "../../src/core/registries/HookRegistry.sol";
import {ForgeItemRegistry} from "../../src/core/registries/ForgeItemRegistry.sol";
import {HeroMetadataRenderer} from "../../src/utils/HeroMetadataRenderer.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockOracle} from "../mocks/MockOracle.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {TestHelpers} from "../helpers/TestHelpers.sol";
import {ForgeEffectSetup} from "../helpers/ForgeEffectSetup.sol";
import {ForgeItemSetup} from "../helpers/ForgeItemSetup.sol";
import {TraitSetup} from "../helpers/TraitSetup.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title EdgeCasesTest
/// @notice Tests for edge cases and boundary conditions
contract EdgeCasesTest is TestHelpers {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      STATE VARIABLES                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    ForgeCoordinator public forgeCoordinator;
    SoloAscendHero public heroContract;
    Treasury public treasury;
    HeroClassRegistry public heroClassRegistry;
    ForgeEffectRegistry public forgeEffectRegistry;
    OracleRegistry public oracleRegistry;
    HookRegistry public hookRegistry;
    ForgeItemRegistry public forgeItemRegistry;
    HeroMetadataRenderer public metadataRenderer;
    HeroTraitRegistry public traitRegistry;
    MockERC6551Registry public erc6551Registry;
    MockOracle public mockOracle;
    MockHook public mockHook;

    address public admin;
    address public erc6551Implementation;
    uint256 public oracleId;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         SETUP                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        admin = address(this);
        erc6551Implementation = address(0x1234);

        // Deploy mock contracts
        erc6551Registry = new MockERC6551Registry();
        mockOracle = new MockOracle();
        mockHook = new MockHook();

        // Deploy registries
        heroClassRegistry = new HeroClassRegistry(admin);
        forgeEffectRegistry = new ForgeEffectRegistry(admin);
        oracleRegistry = new OracleRegistry(admin);
        hookRegistry = new HookRegistry(admin);
        forgeItemRegistry = new ForgeItemRegistry(admin);

        // Deploy treasury
        treasury = new Treasury(admin);

        // Deploy HeroTraitRegistry
        traitRegistry = new HeroTraitRegistry(admin);

        // Deploy metadata renderer
        metadataRenderer = new HeroMetadataRenderer(admin, address(heroClassRegistry), address(traitRegistry));

        // Deploy ForgeCoordinator
        forgeCoordinator = new ForgeCoordinator(
            admin,
            address(forgeEffectRegistry),
            address(forgeItemRegistry),
            address(oracleRegistry),
            address(hookRegistry),
            address(treasury)
        );

        // Deploy hero contract
        heroContract = new SoloAscendHero(
            admin,
            address(heroClassRegistry),
            address(forgeCoordinator),
            address(forgeEffectRegistry),
            address(hookRegistry),
            address(treasury),
            address(erc6551Registry),
            erc6551Implementation,
            address(metadataRenderer)
        );

        // Set hero contract in coordinator
        forgeCoordinator.setHeroContract(address(heroContract));

        // Setup forge effects
        ForgeEffectSetup.setupDefaultForgeEffects(forgeEffectRegistry);

        // Setup forge item contracts
        ForgeItemSetup.setupDefaultForgeItemContracts(
            forgeItemRegistry,
            address(forgeEffectRegistry),
            address(forgeCoordinator)
        );

        // Setup oracle
        _setupOracle();

        // Setup basic traits for testing
        TraitSetup.setupBasicTraits(traitRegistry);

        // Fund test accounts
        fundAccount(ALICE, 10 ether);
        fundAccount(BOB, 10 ether);
        fundAccount(CHARLIE, 10 ether);
    }

    function _setupOracle() internal {
        oracleId = 1;

        GameConstants.ForgeQuality[] memory supportedQualities = new GameConstants.ForgeQuality[](4);
        supportedQualities[0] = GameConstants.ForgeQuality.SILVER;
        supportedQualities[1] = GameConstants.ForgeQuality.GOLD;
        supportedQualities[2] = GameConstants.ForgeQuality.RAINBOW;
        supportedQualities[3] = GameConstants.ForgeQuality.MYTHIC;

        uint256[] memory distributionWeights = new uint256[](4);
        distributionWeights[0] = 7000;
        distributionWeights[1] = 2000;
        distributionWeights[2] = 900;
        distributionWeights[3] = 100;

        oracleRegistry.registerOracle(
            oracleId,
            "MockOracle",
            "Mock oracle for testing",
            address(mockOracle),
            10_000,
            supportedQualities,
            distributionWeights
        );

        mockOracle.setFixedRandomSeed(12_345);
        mockOracle.setAutoFulfill(false);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   BOUNDARY VALUE TESTS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testZeroGasLimitForge() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);

        // Test with zero gas limit - should return only the oracle's fixed fee
        uint32 zeroGasLimit = 0;
        uint256 cost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, zeroGasLimit);

        // Cost should be just the fixed fee (10,000) since oracle fee for gasLimit=0 is 0
        assertEq(cost, 10_000, "Zero gas limit should only charge fixed fee");

        // Should be able to perform forge with zero gas limit
        vm.prank(ALICE);
        heroContract.performDailyForge{value: cost}(tokenId, oracleId, zeroGasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should accept zero gas limit forge");
    }

    function testMaximumGasLimitForge() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);

        // Test with maximum uint32 gas limit
        uint32 maxGasLimit = type(uint32).max;
        uint256 cost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, maxGasLimit);

        assertTrue(cost > 0, "Should calculate cost for max gas limit");

        // Should be able to forge with max gas limit if we have enough ETH
        uint256 aliceBalance = ALICE.balance;
        if (cost <= aliceBalance) {
            vm.prank(ALICE);
            heroContract.performDailyForge{value: cost}(tokenId, oracleId, maxGasLimit);
            assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should handle max gas limit");
        }
    }

    function testExtremelyLongHeroName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Create extremely long name (1000 characters)
        string memory longName = "";
        for (uint256 i = 0; i < 100; i++) {
            longName = string(abi.encodePacked(longName, "0123456789"));
        }

        // Should either succeed or fail gracefully
        vm.prank(ALICE);
        try heroContract.setHeroName(tokenId, longName) {
            // If it succeeds, name should be set
            assertEq(heroContract.getHeroName(tokenId), longName, "Long name should be set");
        } catch {
            // If it fails, that's also acceptable for extremely long names
        }
    }

    function testEmptyHeroName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Try to set empty name
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert with InvalidName or similar
        heroContract.setHeroName(tokenId, "");
    }

    function testUnicodeHeroName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Test unicode characters
        string memory unicodeName = unicode"英雄🗡️⚔️🛡️";

        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, unicodeName);

        assertEq(heroContract.getHeroName(tokenId), unicodeName, "Unicode name should be supported");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   TIME MANIPULATION TESTS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testForgeCooldownBoundary() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // First forge (no cooldown for first forge)
        advanceTime(1 days);
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Fulfill the first forge
        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Now test cooldown boundary - advance time to exactly 1 day - 1 second (should fail)
        advanceTime(1 days - 1);

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to cooldown
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Advance 1 more second to exactly 1 day (should succeed)
        advanceTime(1);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should forge at exact cooldown boundary");
    }

    function testMultipleForgeCooldowns() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // First forge
        advanceTime(1 days);
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId1 = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId1, 5000, address(forgeCoordinator));

        // Try second forge immediately (should fail)
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to cooldown
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        // Second forge after cooldown
        advanceTime(1 days);
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId2 = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId2, 6000, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 2, "Should have completed 2 forges");
    }

    function testTimeOverflow() public {
        // Test behavior when time values are very large but don't cause overflow
        uint256 largeTimestamp = type(uint256).max - 1 days - 1000; // Leave room for 1 day advancement
        vm.warp(largeTimestamp);

        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Should handle large timestamps without overflow
        advanceTime(1 days);

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should handle large timestamps");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   CONCURRENT ACCESS TESTS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testConcurrentMinting() public {
        // Simulate concurrent minting from multiple accounts
        uint256[] memory tokenIds = new uint256[](3);

        vm.prank(ALICE);
        tokenIds[0] = heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        tokenIds[1] = heroContract.mint{value: MINT_PRICE}();

        vm.prank(CHARLIE);
        tokenIds[2] = heroContract.mint{value: MINT_PRICE}();

        // All should have unique sequential IDs
        assertEq(tokenIds[0], 1, "First token should be ID 1");
        assertEq(tokenIds[1], 2, "Second token should be ID 2");
        assertEq(tokenIds[2], 3, "Third token should be ID 3");

        // Verify ownership
        assertEq(heroContract.ownerOf(tokenIds[0]), ALICE, "Alice should own token 1");
        assertEq(heroContract.ownerOf(tokenIds[1]), BOB, "Bob should own token 2");
        assertEq(heroContract.ownerOf(tokenIds[2]), CHARLIE, "Charlie should own token 3");
    }

    function testConcurrentForging() public {
        // Mint heroes for multiple users
        vm.prank(ALICE);
        uint256 tokenId1 = heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        uint256 tokenId2 = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId1, oracleId, gasLimit);

        // Concurrent forging
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId1, oracleId, gasLimit);

        vm.prank(BOB);
        heroContract.performDailyForge{value: forgeCost}(tokenId2, oracleId, gasLimit);

        // Both should have pending forges
        assertTrue(forgeCoordinator.hasPendingForge(tokenId1), "Alice's hero should have pending forge");
        assertTrue(forgeCoordinator.hasPendingForge(tokenId2), "Bob's hero should have pending forge");

        // Fulfill both
        bytes32 requestId1 = forgeCoordinator.getPendingRequest(tokenId1);
        bytes32 requestId2 = forgeCoordinator.getPendingRequest(tokenId2);

        mockOracle.fulfillRandomnessWithSeed(requestId1, 5000, address(forgeCoordinator));
        mockOracle.fulfillRandomnessWithSeed(requestId2, 6000, address(forgeCoordinator));

        // Both should be completed
        assertFalse(forgeCoordinator.hasPendingForge(tokenId1), "Alice's forge should be completed");
        assertFalse(forgeCoordinator.hasPendingForge(tokenId2), "Bob's forge should be completed");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   RESOURCE EXHAUSTION TESTS                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testMassiveMinting() public {
        // Test minting many heroes in succession
        uint256 mintCount = 50; // Reduced for gas efficiency

        for (uint256 i = 0; i < mintCount; i++) {
            address minter = address(uint160(0x1000 + i));
            fundAccount(minter, 1 ether);

            vm.prank(minter);
            uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

            assertEq(tokenId, i + 1, "Token ID should be sequential");
            assertEq(heroContract.ownerOf(tokenId), minter, "Ownership should be correct");
        }

        assertEq(heroContract.totalSupply(), mintCount, "Total supply should match mint count");
    }

    function testMassiveForging() public {
        // Mint several heroes and forge them many times
        uint256[] memory tokenIds = new uint256[](5);

        for (uint256 i = 0; i < 5; i++) {
            address minter = address(uint160(0x2000 + i));
            fundAccount(minter, 10 ether);

            vm.prank(minter);
            tokenIds[i] = heroContract.mint{value: MINT_PRICE}();
        }

        uint32 gasLimit = 100_000;

        // Perform multiple forges for each hero
        for (uint256 forgeRound = 0; forgeRound < 5; forgeRound++) {
            advanceTime(1 days);

            for (uint256 i = 0; i < tokenIds.length; i++) {
                address owner = heroContract.ownerOf(tokenIds[i]);
                uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenIds[i], oracleId, gasLimit);

                vm.prank(owner);
                heroContract.performDailyForge{value: forgeCost}(tokenIds[i], oracleId, gasLimit);

                bytes32 requestId = forgeCoordinator.getPendingRequest(tokenIds[i]);
                mockOracle.fulfillRandomnessWithSeed(requestId, 5000 + i + forgeRound, address(forgeCoordinator));
            }
        }

        // Verify all heroes completed their forges
        for (uint256 i = 0; i < tokenIds.length; i++) {
            assertEq(heroContract.getHero(tokenIds[i]).totalForges, 5, "Each hero should have completed 5 forges");
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   STATE CORRUPTION TESTS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testForgeStateConsistency() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Initiate forge
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Verify consistent state
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should have pending forge");
        assertNotEq(requestId, bytes32(0), "Request ID should exist");

        // Fulfill forge
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Verify state is properly cleared
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Should not have pending forge");
        assertEq(forgeCoordinator.getPendingRequest(tokenId), bytes32(0), "Pending request should be cleared");
        assertEq(heroContract.getHero(tokenId).totalForges, 1, "Forge count should be incremented");
    }

    function testTransferDuringPendingForge() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Initiate forge
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Should have pending forge");

        // Transfer token to Bob while forge is pending
        vm.prank(ALICE);
        heroContract.transferFrom(ALICE, BOB, tokenId);

        // Verify ownership transfer
        assertEq(heroContract.ownerOf(tokenId), BOB, "Bob should now own the token");

        // Forge should still be pending (state should be preserved)
        assertTrue(forgeCoordinator.hasPendingForge(tokenId), "Forge should still be pending after transfer");

        // Fulfill forge
        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        // Forge should complete normally
        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Forge should be completed");
        assertEq(heroContract.getHero(tokenId).totalForges, 1, "Forge count should be updated");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   ORACLE EDGE CASES                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testOracleInactiveAfterRequest() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Initiate forge
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);

        // Deactivate oracle after request is made
        oracleRegistry.deactivateOracle(oracleId);

        // Oracle should still be able to fulfill existing request
        mockOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        assertFalse(forgeCoordinator.hasPendingForge(tokenId), "Forge should be completed even with inactive oracle");
    }

    function testOracleZeroFee() public {
        // Register oracle with zero fixed fee and MockOracle's dynamic fee
        uint256 zeroFeeOracleId = 2;
        GameConstants.ForgeQuality[] memory qualities = new GameConstants.ForgeQuality[](1);
        qualities[0] = GameConstants.ForgeQuality.SILVER;
        uint256[] memory weights = new uint256[](1);
        weights[0] = 10_000;

        MockOracle zeroFeeOracle = new MockOracle();
        zeroFeeOracle.setFixedRandomSeed(54_321);
        zeroFeeOracle.setAutoFulfill(false);

        oracleRegistry.registerOracle(
            zeroFeeOracleId,
            "ZeroFeeOracle",
            "Oracle with zero fixed fee",
            address(zeroFeeOracle),
            0, // Zero fixed fee
            qualities,
            weights
        );

        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, zeroFeeOracleId, gasLimit);

        // Cost should be 0 (fixed fee) + gasLimit * 1 gwei (oracle fee)
        uint256 expectedCost = uint256(gasLimit) * 1 gwei;
        assertEq(forgeCost, expectedCost, "Should charge only oracle fee for zero fixed fee oracle");

        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, zeroFeeOracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        zeroFeeOracle.fulfillRandomnessWithSeed(requestId, 5000, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 1, "Should complete forge with zero fixed fee oracle");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   RANDOM EDGE CASES                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDuplicateRandomSeed() public {
        // Test that same random seed on different forges doesn't cause issues
        vm.prank(ALICE);
        uint256 tokenId1 = heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        uint256 tokenId2 = heroContract.mint{value: MINT_PRICE}();

        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId1, oracleId, gasLimit);

        // First forge
        advanceTime(1 days);
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId1, oracleId, gasLimit);

        bytes32 requestId1 = forgeCoordinator.getPendingRequest(tokenId1);
        mockOracle.fulfillRandomnessWithSeed(requestId1, 12_345, address(forgeCoordinator));

        // Second forge with same seed
        vm.prank(BOB);
        heroContract.performDailyForge{value: forgeCost}(tokenId2, oracleId, gasLimit);

        bytes32 requestId2 = forgeCoordinator.getPendingRequest(tokenId2);
        mockOracle.fulfillRandomnessWithSeed(requestId2, 12_345, address(forgeCoordinator)); // Same seed

        // Both forges should complete successfully
        assertEq(heroContract.getHero(tokenId1).totalForges, 1, "First forge should complete");
        assertEq(heroContract.getHero(tokenId2).totalForges, 1, "Second forge should complete");
    }

    function testExtremeRandomValues() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        advanceTime(1 days);
        uint32 gasLimit = 100_000;
        uint256 forgeCost = forgeCoordinator.calculateForgeCost(tokenId, oracleId, gasLimit);

        // Test with maximum uint256 random value
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        bytes32 requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, type(uint256).max, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 1, "Should handle maximum random value");

        // Test with zero random value
        advanceTime(1 days);
        vm.prank(ALICE);
        heroContract.performDailyForge{value: forgeCost}(tokenId, oracleId, gasLimit);

        requestId = forgeCoordinator.getPendingRequest(tokenId);
        mockOracle.fulfillRandomnessWithSeed(requestId, 0, address(forgeCoordinator));

        assertEq(heroContract.getHero(tokenId).totalForges, 2, "Should handle zero random value");
    }

    function testInvalidTokenBoundAccountCreation() public {
        // Test TBA creation with edge cases
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        address tba = heroContract.getTokenBoundAccount(tokenId);
        assertNotEq(tba, address(0), "TBA should be created");

        // Test that we can get hero ID from TBA
        uint256 retrievedId = forgeCoordinator.getHeroIdByAccount(tba);
        assertEq(retrievedId, tokenId, "Should retrieve correct hero ID from TBA");

        // Test with non-existent token
        vm.expectRevert(); // Should revert when trying to get TBA for non-existent token
        heroContract.getTokenBoundAccount(999);
    }
}
