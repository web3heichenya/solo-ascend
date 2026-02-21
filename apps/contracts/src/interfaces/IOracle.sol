// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title IOracle
/// @notice Interface for modular randomness oracles
/// @author Solo Ascend Team
interface IOracle {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when request parameters are invalid
    error InvalidRequest();
    /// @notice Error thrown when requested ID is not found
    error RequestNotFound();
    /// @notice Error thrown when trying to fulfill an already fulfilled request
    error RequestAlreadyFulfilled();
    /// @notice Error thrown when insufficient fee is provided
    error InsufficientFee();
    /// @notice Error thrown when oracle is not active
    error OracleNotActive();
    /// @notice Error thrown when address is invalid
    error InvalidAddress();
    /// @notice Error thrown when transfer fails
    error TransferFailed();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when randomness is requested
    /// @param requestId The requestId that the hero/forge coordinator created for this forge
    /// @param vrfRequestId The vrfRequestId that the oracle created for this request
    /// @param heroId The hero requesting randomness
    /// @param requester Address requesting randomness
    event RandomnessRequested(
        bytes32 indexed requestId,
        bytes32 indexed vrfRequestId,
        uint256 indexed heroId,
        address requester
    );
    /// @notice Emitted when randomness request is fulfilled
    /// @param requestId The requestId that the hero/forge coordinator created for this forge
    /// @param randomSeed The random seed (0 if not fulfilled)
    event RandomnessFulfilled(bytes32 indexed requestId, uint256 indexed randomSeed);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Request randomness for hero forging (direct funding)
    /// @param requestId The requestId that the hero/forge coordinator created for this forge
    /// @param heroId The hero requesting randomness
    /// @param requester Address requesting randomness
    /// @param gasLimit The gas limit for the request
    /// @return echoedRequestId Echo of the provided requestId
    function requestRandomness(
        bytes32 requestId,
        uint256 heroId,
        address requester,
        uint32 gasLimit
    ) external payable returns (bytes32 echoedRequestId);

    /// @notice Check if a randomness request is fulfilled
    /// @param requestId The request to check
    /// @return fulfilled Whether the request is fulfilled
    /// @return randomSeed The random seed (0 if not fulfilled)
    function getRandomness(bytes32 requestId) external view returns (bool fulfilled, uint256 randomSeed);

    /// @notice Get the fee required for randomness request
    /// @param gasLimit The gas limit for the request
    /// @return fee The fee amount in wei
    function getFee(uint32 gasLimit) external view returns (uint256 fee);

    /// @notice Check if oracle is active and accepting requests
    /// @return active Whether oracle is active
    function isActive() external view returns (bool active);
}
