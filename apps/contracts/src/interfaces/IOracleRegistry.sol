// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IOracleRegistry
/// @notice Interface for the OracleRegistry contract
/// @author Solo Ascend Team
interface IOracleRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the oracle is already registered
    error OracleAlreadyRegistered(uint256 oracleId);
    /// @notice Error thrown when the oracle is not found
    error OracleNotFound(uint256 oracleId);
    /// @notice Error thrown when the oracle is inactive
    error OracleInactive(uint256 oracleId);
    /// @notice Error thrown when the implementation is invalid
    error InvalidImplementation();
    /// @notice Error thrown when the oracle data is invalid
    error InvalidOracleData();
    /// @notice Error thrown when the quality is not supported
    error QualityNotSupported(uint256 oracleId, GameConstants.ForgeQuality quality);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new oracle is registered
    /// @param oracleId Unique identifier for the oracle
    /// @param name Display name for the oracle
    /// @param implementation Implementation contract address
    event OracleRegistered(uint256 indexed oracleId, string name, address indexed implementation);

    /// @notice Emitted when an oracle's implementation is updated
    /// @param oracleId Unique identifier for the oracle
    /// @param newImplementation New implementation address
    event OracleUpdated(uint256 indexed oracleId, address indexed newImplementation);

    /// @notice Emitted when an oracle is deactivated
    /// @param oracleId Unique identifier for the oracle
    event OracleDeactivated(uint256 indexed oracleId);

    /// @notice Emitted when an oracle is reactivated
    /// @param oracleId Unique identifier for the oracle
    event OracleReactivated(uint256 indexed oracleId);

    /// @notice Emitted when an oracle's quality support is updated
    /// @param oracleId Unique identifier for the oracle
    /// @param quality Forge quality
    /// @param supported Whether quality is supported
    event QualitySupportUpdated(uint256 indexed oracleId, GameConstants.ForgeQuality quality, bool supported);

    /// @notice Emitted when an oracle's quality distribution weight is updated
    /// @param oracleId Unique identifier for the oracle
    /// @param quality Forge quality
    /// @param weight Distribution weight
    event QualityDistributionUpdated(uint256 indexed oracleId, GameConstants.ForgeQuality quality, uint256 weight);

    /// @notice Emitted when an oracle's fees are updated
    /// @param oracleId Unique identifier for the oracle
    /// @param fixedFee Fixed fee for using this oracle
    event OracleFeesUpdated(uint256 indexed oracleId, uint256 fixedFee);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Oracle data
    /// @param name Oracle name
    /// @param description Oracle description
    /// @param implementation Oracle contract address
    /// @param isActive Whether oracle is active
    /// @param createdAt Registration timestamp
    /// @param fixedFee Fixed fee (0 for free oracles)
    /// @param variableFeeRate Variable fee rate in basis points
    struct OracleData {
        string name;
        string description;
        address implementation;
        bool isActive;
        uint64 createdAt;
        uint256 fixedFee;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Check if oracle ID is registered
    /// @param oracleId Oracle ID
    /// @return registered Whether oracle is registered
    function isOracleRegistered(uint256 oracleId) external view returns (bool registered);

    /// @notice Get oracle data
    /// @param oracleId Oracle ID
    /// @return oracleData Oracle information
    function getOracle(uint256 oracleId) external view returns (OracleData memory oracleData);

    /// @notice Get oracle implementation address
    /// @param oracleId Oracle ID
    /// @return implementation Implementation contract address
    function getOracleImplementation(uint256 oracleId) external view returns (address implementation);

    /// @notice Check if oracle supports quality
    /// @param oracleId Oracle ID
    /// @param quality Forge quality
    /// @return supported Whether oracle supports this quality
    function getQualitySupport(
        uint256 oracleId,
        GameConstants.ForgeQuality quality
    ) external view returns (bool supported);

    /// @notice Get quality distribution weight
    /// @param oracleId Oracle ID
    /// @param quality Forge quality
    /// @return weight Distribution weight
    function getQualityWeight(
        uint256 oracleId,
        GameConstants.ForgeQuality quality
    ) external view returns (uint256 weight);

    /// @notice Check if an oracle implementation is authorized
    /// @param oracleAddress Oracle implementation address
    /// @return authorized Whether the oracle is authorized
    function isAuthorizedOracle(address oracleAddress) external view returns (bool authorized);

    /// @notice Calculate total fee for using an oracle
    /// @param oracleId Oracle ID
    /// @param gasLimit Gas limit for the request
    /// @return totalFee Total fee required
    function calculateFee(uint256 oracleId, uint32 gasLimit) external view returns (uint256 totalFee);

    /// @notice Determine forge quality based on oracle and random seed
    /// @param oracleId Oracle ID
    /// @param randomSeed Random seed
    /// @param totalForges Total forges performed by hero
    /// @return quality Determined forge quality
    function determineQuality(
        uint256 oracleId,
        uint256 randomSeed,
        uint256 totalForges
    ) external view returns (GameConstants.ForgeQuality quality);

    /// @notice Register a new oracle
    /// @param oracleId Unique identifier for the oracle
    /// @param name Display name for the oracle
    /// @param description Oracle description
    /// @param implementation Contract implementing IOracle
    /// @param fixedFee Fixed fee for using this oracle
    /// @param supportedQualities Array of qualities this oracle supports
    /// @param distributionWeights Array of distribution weights for each quality
    function registerOracle(
        uint256 oracleId,
        string calldata name,
        string calldata description,
        address implementation,
        uint256 fixedFee,
        GameConstants.ForgeQuality[] calldata supportedQualities,
        uint256[] calldata distributionWeights
    ) external;

    /// @notice Update oracle implementation
    /// @param oracleId Oracle to update
    /// @param newImplementation New implementation address
    function updateOracleImplementation(uint256 oracleId, address newImplementation) external;

    /// @notice Update quality support for an oracle
    /// @param oracleId Oracle to update
    /// @param quality Quality to update
    /// @param supported Whether quality is supported
    /// @param weight Distribution weight (ignored if not supported)
    function setQualitySupport(
        uint256 oracleId,
        GameConstants.ForgeQuality quality,
        bool supported,
        uint256 weight
    ) external;

    /// @notice Update oracle fees
    /// @param oracleId Oracle to update
    /// @param fixedFee New fixed fee
    function updateOracleFees(uint256 oracleId, uint256 fixedFee) external;

    /// @notice Deactivate an oracle
    /// @param oracleId Oracle to deactivate
    function deactivateOracle(uint256 oracleId) external;

    /// @notice Reactivate an oracle
    /// @param oracleId Oracle to reactivate
    function reactivateOracle(uint256 oracleId) external;
}
