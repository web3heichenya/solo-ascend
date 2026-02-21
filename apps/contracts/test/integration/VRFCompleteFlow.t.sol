// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {ChainlinkVRFDirectOracle} from "../../src/oracles/ChainlinkVRFDirectOracle.sol";
import {IOracle} from "../../src/interfaces/IOracle.sol";
import {IForgeCoordinator} from "../../src/interfaces/IForgeCoordinator.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title Complete VRF Flow Test
/// @notice Tests the complete flow from ForgeCoordinator to VRF fulfillment
contract VRFCompleteFlowTest is Test {
    ChainlinkVRFDirectOracle public oracle;
    MockForgeCoordinator public forgeCoordinator;
    MockVRFWrapper public vrfWrapper;

    address public owner = address(0x1);
    address public user = address(0x2);

    uint256 public constant HERO_ID = 1;
    uint256 public constant ORACLE_ID = 2;
    uint32 public constant GAS_LIMIT = 200_000;

    // Track VRF request for testing
    uint256 public lastVrfRequestId;
    bytes32 public lastInternalRequestId;

    function setUp() public {
        vm.startPrank(owner);

        // Deploy mock VRF wrapper
        vrfWrapper = new MockVRFWrapper();

        // Deploy mock forge coordinator first (with placeholder oracle)
        forgeCoordinator = new MockForgeCoordinator(address(1));

        // Deploy oracle with both addresses
        oracle = new ChainlinkVRFDirectOracle(owner, address(vrfWrapper), address(forgeCoordinator));

        // Update forge coordinator with new oracle
        forgeCoordinator.setOracle(address(oracle));

        // Set the VRF wrapper's oracle for callbacks
        vrfWrapper.setOracle(address(oracle));

        vm.stopPrank();
    }

    /// @notice Test the complete flow as described
    function testCompleteVRFFlow() public {
        console.log("=== Testing Complete VRF Flow ===");
        console.log("");

        // Step 1: User initiates forge through ForgeCoordinator
        console.log("Step 1: ForgeCoordinator.initiateForgeAndRequestAuto()");

        vm.startPrank(user);
        vm.deal(user, 1 ether);

        // Get fee from oracle
        uint256 fee = oracle.getFee(GAS_LIMIT);
        console.log("  Required fee:", fee);

        // Call ForgeCoordinator to initiate
        bytes32 requestId = forgeCoordinator.initiateForgeAndRequestAuto{value: fee}(
            HERO_ID,
            user,
            ORACLE_ID,
            GAS_LIMIT
        );

        console.log("  Generated request ID:");
        console.logBytes32(requestId);

        vm.stopPrank();

        // Step 2: Check that Oracle received the request
        console.log("\nStep 2: Oracle.requestRandomness() was called");
        _checkOracleState(requestId);

        // Step 3: Check that VRF wrapper received the request
        console.log("\nStep 3: VRF_WRAPPER.requestRandomWordsInNative() was called");
        uint256 vrfRequestId = vrfWrapper.getLastRequestId();
        console.log("  VRF Request ID generated:", vrfRequestId);

        // Step 4: Simulate Chainlink VRF processing
        console.log("\nStep 4: Chainlink VRF processing (simulated)");
        uint256 randomWord = uint256(keccak256(abi.encode(vrfRequestId, "random")));
        console.log("  Generated random word:", randomWord);

        // Step 5: VRF Wrapper calls back to Oracle
        console.log("\nStep 5: VRF_WRAPPER.fulfillRandomWords()");

        vm.startPrank(address(vrfWrapper));

        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = randomWord;

        // This should trigger the complete flow
        console.log("  Calling oracle.fulfillRandomWords()");
        oracle.rawFulfillRandomWords(vrfRequestId, randomWords);

        vm.stopPrank();

        // Step 6: Verify Oracle processed the fulfillment
        console.log("\nStep 6: Oracle.fulfillRandomWords() processed");
        _checkOracleStateAfterFulfillment(requestId);

        // Step 7: Verify ForgeCoordinator received the callback
        console.log("\nStep 7: ForgeCoordinator.fulfillForge() was called");
        _checkForgeCoordinatorState(requestId);

        console.log("\n=== Flow completed successfully! ===");
    }

    /// @notice Test using the actual generated request ID throughout the flow
    function testWithActualGeneratedRequestId() public {
        console.log("=== Testing With Actual Generated Request ID ===");

        // Step 1: Create a request and capture all IDs
        vm.startPrank(user);
        vm.deal(user, 1 ether);

        uint256 fee = oracle.getFee(GAS_LIMIT);
        bytes32 internalRequestId = forgeCoordinator.initiateForgeAndRequestAuto{value: fee}(
            HERO_ID,
            user,
            ORACLE_ID,
            GAS_LIMIT
        );

        vm.stopPrank();

        // Capture the VRF request ID that was generated
        uint256 vrfRequestId = vrfWrapper.getLastRequestId();

        console.log("Generated IDs:");
        console.log("  Internal Request ID:");
        console.logBytes32(internalRequestId);
        console.log("  VRF Request ID:", vrfRequestId);

        // Step 2: Verify the mapping exists
        bytes32 mappedInternalId = oracle.getVrfRequestToInternal(vrfRequestId);
        console.log("\nMapping verification:");
        console.log("  VRF Request ID", vrfRequestId, "maps to:");
        console.logBytes32(mappedInternalId);
        require(mappedInternalId == internalRequestId, "Mapping should exist");

        // Step 3: Check state before fulfillment
        (bool fulfilledBefore, uint256 seedBefore) = oracle.getRandomness(internalRequestId);
        console.log("\nState before fulfillment:");
        console.log("  Fulfilled:", fulfilledBefore);
        console.log("  Random seed:", seedBefore);
        require(!fulfilledBefore, "Should not be fulfilled yet");

        // Step 4: Fulfill using the actual VRF request ID
        vm.startPrank(address(vrfWrapper));

        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = 12_345_678;

        console.log("\nFulfilling with VRF Request ID:", vrfRequestId);
        oracle.rawFulfillRandomWords(vrfRequestId, randomWords);

        vm.stopPrank();

        // Step 5: Verify state after fulfillment
        (bool fulfilledAfter, uint256 seedAfter) = oracle.getRandomness(internalRequestId);
        console.log("\nState after fulfillment:");
        console.log("  Fulfilled:", fulfilledAfter);
        console.log("  Random seed:", seedAfter);
        require(fulfilledAfter, "Should be fulfilled now");
        require(seedAfter == randomWords[0], "Random seed should match");

        // Step 6: Verify ForgeCoordinator was updated
        IForgeCoordinator.ForgeRequest memory forgeRequest = forgeCoordinator.getForgeRequest(internalRequestId);
        console.log("\nForgeCoordinator state:");
        console.log("  Fulfilled:", forgeRequest.fulfilled);
        console.log("  Random seed:", forgeRequest.randomSeed);
        require(forgeRequest.fulfilled, "Forge should be fulfilled");

        console.log("\n[SUCCESS] All validations passed!");
    }

    /// @notice Test double fulfillment
    function testDoubleFulfillment() public {
        console.log("=== Testing Double Fulfillment ===");

        // Create and fulfill a request
        vm.startPrank(user);
        vm.deal(user, 1 ether);

        uint256 fee = oracle.getFee(GAS_LIMIT);
        forgeCoordinator.initiateForgeAndRequestAuto{value: fee}(HERO_ID, user, ORACLE_ID, GAS_LIMIT);

        vm.stopPrank();

        uint256 vrfRequestId = vrfWrapper.getLastRequestId();
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = 12_345;

        // First fulfillment
        vm.startPrank(address(vrfWrapper));
        oracle.rawFulfillRandomWords(vrfRequestId, randomWords);
        vm.stopPrank();

        console.log("First fulfillment successful");

        // Second fulfillment should fail
        vm.startPrank(address(vrfWrapper));
        vm.expectRevert(IOracle.RequestAlreadyFulfilled.selector);
        oracle.rawFulfillRandomWords(vrfRequestId, randomWords);
        vm.stopPrank();

        console.log("Second fulfillment correctly rejected");
    }

    function _checkOracleState(bytes32 requestId) private view {
        (bool fulfilled, uint256 randomSeed) = oracle.getRandomness(requestId);
        console.log("  Oracle request state:");
        console.log("    Fulfilled:", fulfilled);
        console.log("    Random seed:", randomSeed);

        // Check VRF mapping
        uint256 vrfRequestId = vrfWrapper.getLastRequestId();
        bytes32 mappedInternalId = oracle.getVrfRequestToInternal(vrfRequestId);
        console.log("  VRF request ID maps to internal ID:");
        console.logBytes32(mappedInternalId);
        require(mappedInternalId == requestId, "Mapping mismatch");
    }

    function _checkOracleStateAfterFulfillment(bytes32 requestId) private view {
        (bool fulfilled, uint256 randomSeed) = oracle.getRandomness(requestId);
        console.log("  Oracle request state after fulfillment:");
        console.log("    Fulfilled:", fulfilled);
        console.log("    Random seed:", randomSeed);
        require(fulfilled, "Request should be fulfilled");
        require(randomSeed != 0, "Random seed should be set");
    }

    function _checkForgeCoordinatorState(bytes32 requestId) private view {
        IForgeCoordinator.ForgeRequest memory request = forgeCoordinator.getForgeRequest(requestId);
        console.log("  ForgeCoordinator state:");
        console.log("    Fulfilled:", request.fulfilled);
        console.log("    Random seed:", request.randomSeed);
        console.log("    Effect ID:", request.effectId);
        require(request.fulfilled, "Forge request should be fulfilled");
    }
}

/// @notice Mock VRF Wrapper
contract MockVRFWrapper {
    uint256 private requestIdCounter = 1;
    uint256 public lastRequestId;
    address public oracle;

    function setOracle(address _oracle) external {
        oracle = _oracle;
    }

    function calculateRequestPriceNative(uint32, uint32) external pure returns (uint256) {
        return 0.001 ether; // Fixed price for testing
    }

    function requestRandomWordsInNative(
        uint32, // callbackGasLimit
        uint16, // requestConfirmations
        uint32, // numWords
        bytes calldata // extraArgs
    ) external payable returns (uint256 requestId) {
        console.log("  MockVRFWrapper: Request received");
        console.log("    Value:", msg.value);

        requestId = requestIdCounter++;
        lastRequestId = requestId;

        console.log("    Generated VRF request ID:", requestId);

        // In real scenario, Chainlink would process this and call back later
        // For testing, we store it for manual triggering

        return requestId;
    }

    function getLastRequestId() external view returns (uint256) {
        return lastRequestId;
    }
}

/// @notice Mock Forge Coordinator
contract MockForgeCoordinator {
    mapping(bytes32 => IForgeCoordinator.ForgeRequest) private forgeRequests;
    address public oracle;
    uint256 private requestCounter;

    constructor(address _oracle) {
        oracle = _oracle;
    }

    function setOracle(address _oracle) external {
        oracle = _oracle;
    }

    function initiateForgeAndRequestAuto(
        uint256 heroId,
        address requester,
        uint256 oracleId,
        uint32 gasLimit
    ) external payable returns (bytes32 requestId) {
        console.log("  MockForgeCoordinator: Initiating forge");

        // Generate internal request ID
        requestId = keccak256(abi.encode(heroId, requester, requestCounter++));

        // Store forge request
        forgeRequests[requestId] = IForgeCoordinator.ForgeRequest({
            heroId: heroId,
            oracleId: oracleId,
            totalForges: 1,
            randomSeed: 0,
            effectId: 0,
            requester: requester,
            requestTime: uint64(block.timestamp),
            fulfilled: false
        });

        console.log("  Calling Oracle.requestRandomness()");

        // Step 2: Call Oracle.requestRandomness()
        bytes32 returnedId = IOracle(oracle).requestRandomness{value: msg.value}(
            requestId,
            heroId,
            requester,
            gasLimit
        );

        require(returnedId == requestId, "Request ID mismatch");

        return requestId;
    }

    function getForgeRequest(bytes32 requestId) external view returns (IForgeCoordinator.ForgeRequest memory) {
        return forgeRequests[requestId];
    }

    function fulfillForge(
        bytes32 requestId,
        uint256 randomSeed
    )
        external
        returns (
            GameConstants.ForgeEffectType effectTypeId,
            uint256 effectId,
            GameConstants.HeroAttributes memory newAttributes,
            GameConstants.HeroStage newStage
        )
    {
        console.log("  MockForgeCoordinator.fulfillForge() called");
        console.log("    Request ID:");
        console.logBytes32(requestId);
        console.log("    Random seed:", randomSeed);

        require(msg.sender == oracle, "Only oracle can fulfill");
        require(forgeRequests[requestId].heroId != 0, "Request not found");
        require(!forgeRequests[requestId].fulfilled, "Already fulfilled");

        // Update request
        forgeRequests[requestId].fulfilled = true;
        forgeRequests[requestId].randomSeed = randomSeed;
        forgeRequests[requestId].effectId = 1; // Mock effect ID

        // Return mock values
        effectTypeId = GameConstants.ForgeEffectType.ATTRIBUTE;
        effectId = 1;
        newAttributes = GameConstants.HeroAttributes({
            hp: 100,
            hpRegen: 10,
            ad: 10,
            ap: 10,
            attackSpeed: 10,
            crit: 10,
            armor: 10,
            mr: 10,
            cdr: 10,
            moveSpeed: 10,
            lifesteal: 10,
            tenacity: 10,
            penetration: 10,
            mana: 100,
            manaRegen: 10,
            intelligence: 10
        });
        newStage = GameConstants.HeroStage.FORGING;

        return (effectTypeId, effectId, newAttributes, newStage);
    }
}
