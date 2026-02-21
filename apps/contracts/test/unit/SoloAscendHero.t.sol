// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {SoloAscendHero} from "../../src/core/SoloAscendHero.sol";
import {ForgeCoordinator} from "../../src/core/ForgeCoordinator.sol";
import {Treasury} from "../../src/core/Treasury.sol";
import {HeroClassRegistry} from "../../src/core/registries/HeroClassRegistry.sol";
import {ForgeEffectRegistry} from "../../src/core/registries/ForgeEffectRegistry.sol";
import {HookRegistry} from "../../src/core/registries/HookRegistry.sol";
import {HeroMetadataRenderer} from "../../src/utils/HeroMetadataRenderer.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {MockERC6551Registry} from "../mocks/MockERC6551Registry.sol";
import {MockHook} from "../mocks/MockHook.sol";
import {TestHelpers} from "../helpers/TestHelpers.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {ISoloAscendHero} from "../../src/interfaces/ISoloAscendHero.sol";
import {IHookRegistry} from "../../src/interfaces/IHookRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title SoloAscendHeroTest
/// @notice Comprehensive tests for SoloAscendHero contract
contract SoloAscendHeroTest is TestHelpers {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      STATE VARIABLES                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    SoloAscendHero public heroContract;
    ForgeCoordinator public forgeCoordinator;
    Treasury public treasury;
    HeroClassRegistry public heroClassRegistry;
    ForgeEffectRegistry public forgeEffectRegistry;
    HookRegistry public hookRegistry;
    HeroMetadataRenderer public metadataRenderer;
    HeroTraitRegistry public traitRegistry;
    MockERC6551Registry public erc6551Registry;
    MockHook public mockHook;

    address public admin;
    address public erc6551Implementation;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         SETUP                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        admin = address(this);
        erc6551Implementation = address(0x1234);

        // Deploy mock contracts
        erc6551Registry = new MockERC6551Registry();
        mockHook = new MockHook();

        // Deploy registries
        heroClassRegistry = new HeroClassRegistry(admin);
        forgeEffectRegistry = new ForgeEffectRegistry(admin);
        hookRegistry = new HookRegistry(admin);

        // Deploy treasury
        treasury = new Treasury(admin);

        // Deploy HeroTraitRegistry
        traitRegistry = new HeroTraitRegistry(admin);

        // Deploy metadata renderer
        metadataRenderer = new HeroMetadataRenderer(admin, address(heroClassRegistry), address(traitRegistry));

        // Deploy ForgeCoordinator (placeholder for now)
        forgeCoordinator = ForgeCoordinator(address(0x5678));

        // Deploy main hero contract
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

        // Setup hero classes
        _setupHeroClasses();

        // Setup basic traits for testing
        _setupBasicTraits();

        // Fund test accounts
        fundAccount(ALICE, 10 ether);
        fundAccount(BOB, 10 ether);
        fundAccount(CHARLIE, 10 ether);
    }

    function _setupHeroClasses() internal {
        // HeroClassRegistry already initializes default classes in constructor
        // No need to register additional classes for basic testing
    }

    function _setupBasicTraits() internal {
        // Register basic traits for all required layers

        // BACKGROUND traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BACKGROUND,
            '<rect width="400" height="400" fill="#1a1a1a"/>',
            "Dark Background"
        );

        // BASE traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BASE,
            '<rect x="100" y="70" width="200" height="260" fill="#dbb180"/>',
            "Human"
        );

        // EYES traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.EYES,
            '<circle cx="180" cy="105" r="3" fill="#000000"/><circle cx="220" cy="105" r="3" fill="#000000"/>',
            "Normal Eyes"
        );

        // MOUTH traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.MOUTH,
            '<rect x="190" y="125" width="20" height="3" fill="#711010"/>',
            "Normal Mouth"
        );

        // HAIR_HAT traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.HAIR_HAT,
            '<rect x="150" y="60" width="100" height="35" fill="#654321" rx="18"/>',
            "Short Brown Hair"
        );

        // BODY traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.BODY,
            '<rect x="133" y="145" width="134" height="130" fill="#8B4513"/>',
            "Leather Armor"
        );

        // LEGS traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.LEGS,
            '<rect x="160" y="265" width="80" height="70" fill="#654321"/>',
            "Brown Pants"
        );

        // FOOT traits
        traitRegistry.registerLayerTrait(
            IHeroTraitRegistry.TraitLayer.FOOT,
            '<rect x="155" y="330" width="90" height="22" fill="#000000"/>',
            "Black Boots"
        );

        // Register weapons for each class
        for (uint256 i = 0; i <= uint256(GameConstants.HeroClass.PRIEST); i++) {
            traitRegistry.registerWeaponTrait(
                GameConstants.HeroClass(i),
                '<rect x="270" y="125" width="65" height="170" fill="#C0C0C0"/>',
                '<rect x="270" y="125" width="65" height="170" fill="#FFD700"/>',
                '<rect x="270" y="125" width="65" height="170" fill="#FF69B4"/>',
                string(abi.encodePacked("Weapon", vm.toString(i + 1)))
            );
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MINT TESTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testMint_Success() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Verify basic mint results
        assertEq(tokenId, 1, "First token ID should be 1");
        assertEq(heroContract.ownerOf(tokenId), ALICE, "Alice should own the hero");
        assertEq(heroContract.totalSupply(), 1, "Total supply should be 1");
        assertEq(heroContract.hasMinted(ALICE), tokenId, "Alice should be marked as having minted");

        // Verify hero data
        GameConstants.Hero memory hero = heroContract.getHero(tokenId);
        assertTrue(hero.classId <= GameConstants.HeroClass.PRIEST, "Hero should have valid class");
        assertEq(uint8(hero.stage), uint8(GameConstants.HeroStage.FORGING), "Hero should be in FORGING stage");
        assertEq(hero.totalForges, 0, "Hero should have 0 forges initially");
        assertGt(hero.mintTime, 0, "Hero should have mint time set");
        assertEq(hero.lastForgeTime, 0, "Hero should have no last forge time");

        // Verify TBA creation (mock registry should return deterministic address)
        address expectedTBA = erc6551Registry.account(
            erc6551Implementation,
            keccak256(abi.encodePacked("SoloAscendHero", tokenId)),
            block.chainid,
            address(heroContract),
            tokenId
        );
        assertEq(hero.tokenBoundAccount, expectedTBA, "TBA address should match expected");
    }

    function testMint_RevertWhenInsufficientPayment() public {
        vm.prank(ALICE);
        vm.expectRevert(
            abi.encodeWithSelector(ISoloAscendHero.InsufficientPayment.selector, MINT_PRICE, MINT_PRICE - 1)
        );
        heroContract.mint{value: MINT_PRICE - 1}();
    }

    function testMint_RevertWhenAlreadyMinted() public {
        // First mint succeeds
        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();

        // Second mint fails
        vm.prank(ALICE);
        vm.expectRevert(ISoloAscendHero.AlreadyMinted.selector);
        heroContract.mint{value: MINT_PRICE}();
    }

    function testMint_RevertWhenNoPayment() public {
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSelector(ISoloAscendHero.InsufficientPayment.selector, MINT_PRICE, 0));
        heroContract.mint();
    }

    function testMint_EmitsCorrectEvent() public {
        vm.prank(ALICE);

        // We can't predict the exact class name due to randomness, so just check for event emission
        vm.expectEmit(true, true, false, false);
        emit ISoloAscendHero.HeroMinted(ALICE, 1, "");

        heroContract.mint{value: MINT_PRICE}();
    }

    function testMint_HookExecution() public {
        // Register mock hook with higher gas limit
        hookRegistry.registerHook(IHookRegistry.HookPhase.BEFORE_HERO_MINTING, address(mockHook), 100, 100_000);

        hookRegistry.registerHook(IHookRegistry.HookPhase.AFTER_HERO_MINTED, address(mockHook), 100, 100_000);

        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();

        // Verify hooks were called
        assertEq(mockHook.executionCount(), 2, "Both hooks should have been called");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     VIEW FUNCTION TESTS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetHero_ValidHero() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        GameConstants.Hero memory hero = heroContract.getHero(tokenId);

        assertEq(hero.totalForges, 0, "New hero should have 0 forges");
        assertEq(uint8(hero.stage), uint8(GameConstants.HeroStage.FORGING), "New hero should be in FORGING stage");
        assertGt(hero.mintTime, 0, "Hero should have mint time");
    }

    function testGetHero_InvalidHero() public {
        vm.expectRevert(abi.encodeWithSelector(ISoloAscendHero.InvalidHeroId.selector, 999));
        heroContract.getHero(999);
    }

    function testGetHeroName_DefaultName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        string memory name = heroContract.getHeroName(tokenId);
        assertEq(name, "Solo Ascend Hero #1", "Default name should be correct");
    }

    function testGetHeroName_CustomName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, "Custom Hero");

        string memory name = heroContract.getHeroName(tokenId);
        assertEq(name, "Custom Hero", "Custom name should be returned");
    }

    function testHasMinted() public {
        assertEq(heroContract.hasMinted(ALICE), 0, "Alice should not have minted initially");

        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        assertEq(heroContract.hasMinted(ALICE), tokenId, "Alice should have minted after mint");
        assertEq(heroContract.hasMinted(BOB), 0, "Bob should not have minted");
    }

    function testTotalSupply() public {
        assertEq(heroContract.totalSupply(), 0, "Initial supply should be 0");

        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();

        assertEq(heroContract.totalSupply(), 1, "Supply should be 1 after mint");

        vm.prank(BOB);
        heroContract.mint{value: MINT_PRICE}();

        assertEq(heroContract.totalSupply(), 2, "Supply should be 2 after second mint");
    }

    function testGetTokenBoundAccount() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        address tba = heroContract.getTokenBoundAccount(tokenId);

        // Should return the deterministic address from mock registry
        address expected = erc6551Registry.account(
            erc6551Implementation,
            keccak256(abi.encodePacked("SoloAscendHero", tokenId)),
            block.chainid,
            address(heroContract),
            tokenId
        );

        assertEq(tba, expected, "TBA address should match expected");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    HERO NAME TESTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSetHeroName_Success() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        vm.expectEmit(true, true, false, true);
        emit ISoloAscendHero.HeroNameSet(tokenId, ALICE, "My Hero");

        heroContract.setHeroName(tokenId, "My Hero");

        assertEq(heroContract.getHeroName(tokenId), "My Hero", "Hero name should be set");
    }

    function testSetHeroName_RevertWhenNotOwner() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        vm.expectRevert(ISoloAscendHero.UnauthorizedAccess.selector);
        heroContract.setHeroName(tokenId, "Unauthorized");
    }

    function testSetHeroName_RevertWhenInvalidHero() public {
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSelector(ISoloAscendHero.InvalidHeroId.selector, 999));
        heroContract.setHeroName(999, "Invalid");
    }

    function testSetHeroName_RevertWhenEmptyName() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        vm.expectRevert(ISoloAscendHero.InvalidHeroName.selector);
        heroContract.setHeroName(tokenId, "");
    }

    function testSetHeroName_RevertWhenTooLong() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // 33 character string (too long)
        string memory longName = "This name is too long for the hero";

        vm.prank(ALICE);
        vm.expectRevert(ISoloAscendHero.InvalidHeroName.selector);
        heroContract.setHeroName(tokenId, longName);
    }

    function testRevokeCustomName_Success() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        // Set custom name
        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, "Custom Name");

        assertEq(heroContract.getHeroName(tokenId), "Custom Name", "Custom name should be set");

        // Revoke name
        vm.expectEmit(true, true, false, true);
        emit ISoloAscendHero.HeroNameRevoked(tokenId, admin, "Custom Name");

        heroContract.revokeCustomName(tokenId);

        assertEq(heroContract.getHeroName(tokenId), "Solo Ascend Hero #1", "Should return to default name");
    }

    function testRevokeCustomName_RevertWhenNotAdmin() public {
        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to onlyOwner modifier
        heroContract.revokeCustomName(tokenId);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  ADMIN FUNCTION TESTS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSetSVGRenderer_Success() public {
        address newRenderer = address(0x9999);

        heroContract.setSVGRenderer(newRenderer);

        assertEq(heroContract.getSVGRenderer(), newRenderer, "SVG renderer should be updated");
    }

    function testSetSVGRenderer_RevertWhenNotAdmin() public {
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to onlyOwner modifier
        heroContract.setSVGRenderer(address(0x9999));
    }

    function testWithdrawRevenue_Success() public {
        // First, have someone mint to generate revenue
        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();

        uint256 expectedRevenue = MINT_PRICE - TREASURY_FEE;
        uint256 balanceBefore = CHARLIE.balance;

        vm.expectEmit(true, false, false, true);
        emit ISoloAscendHero.RevenueWithdrawn(CHARLIE, expectedRevenue);

        heroContract.withdrawRevenue(CHARLIE, expectedRevenue);

        assertEq(CHARLIE.balance, balanceBefore + expectedRevenue, "Charlie should receive revenue");
    }

    function testWithdrawRevenue_RevertWhenNotAdmin() public {
        vm.prank(ALICE);
        vm.expectRevert(); // Should revert due to onlyOwner modifier
        heroContract.withdrawRevenue(ALICE, 1 ether);
    }

    function testWithdrawRevenue_RevertWhenInsufficientBalance() public {
        vm.expectRevert(ISoloAscendHero.InsufficientTreasuryFunds.selector);
        heroContract.withdrawRevenue(CHARLIE, 1 ether);
    }

    function testWithdrawAllRevenue_Success() public {
        // Have multiple people mint
        vm.prank(ALICE);
        heroContract.mint{value: MINT_PRICE}();

        vm.prank(BOB);
        heroContract.mint{value: MINT_PRICE}();

        uint256 expectedTotal = (MINT_PRICE - TREASURY_FEE) * 2;
        uint256 balanceBefore = CHARLIE.balance;

        heroContract.withdrawAllRevenue(CHARLIE);

        assertEq(CHARLIE.balance, balanceBefore + expectedTotal, "Charlie should receive all revenue");
        assertEq(address(heroContract).balance, 0, "Contract should have no balance left");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      FUZZ TESTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFuzz_MintWithExcessPayment(uint256 payment) public {
        vm.assume(payment >= MINT_PRICE && payment <= 100 ether);

        vm.deal(ALICE, payment);

        uint256 balanceBefore = ALICE.balance;

        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: payment}();

        assertEq(tokenId, 1, "Should mint successfully");
        assertEq(ALICE.balance, balanceBefore - payment, "Should charge full payment amount");
    }

    function testFuzz_SetValidHeroName(string memory name) public {
        bytes memory nameBytes = bytes(name);
        vm.assume(nameBytes.length > 0 && nameBytes.length <= 32);

        vm.prank(ALICE);
        uint256 tokenId = heroContract.mint{value: MINT_PRICE}();

        vm.prank(ALICE);
        heroContract.setHeroName(tokenId, name);

        assertEq(heroContract.getHeroName(tokenId), name, "Hero name should be set correctly");
    }
}
