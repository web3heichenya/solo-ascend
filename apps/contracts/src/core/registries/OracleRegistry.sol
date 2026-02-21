// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {GameConstants} from "../../libraries/GameConstants.sol";
import {IOracleRegistry} from "../../interfaces/IOracleRegistry.sol";
import {IOracle} from "../../interfaces/IOracle.sol";

/// @title OracleRegistry
/// @notice Dynamic registry for oracle providers and their quality support
/// @author Solo Ascend Team
contract OracleRegistry is Ownable, IOracleRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Mapping from oracle ID to oracle data
    mapping(uint256 => OracleData) private _oracles;

    /// @notice Mapping from oracle implementation address to whether it is authorized
    mapping(address => bool) private _isAuthorizedOracle;

    /// @notice Mapping from oracle ID to supported qualities
    mapping(uint256 => mapping(GameConstants.ForgeQuality => bool)) private _oracleSupportsQuality;

    /// @notice Mapping from oracle ID to quality distribution weights
    mapping(uint256 => mapping(GameConstants.ForgeQuality => uint256)) private _qualityDistribution;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the OracleRegistry
    /// @param admin The address that will be granted owner privileges
    constructor(address admin) Ownable(admin) {}

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IOracleRegistry
    function registerOracle(
        uint256 oracleId,
        string calldata name,
        string calldata description,
        address implementation,
        uint256 fixedFee,
        GameConstants.ForgeQuality[] calldata supportedQualities,
        uint256[] calldata distributionWeights
    ) external override onlyOwner {
        if (isOracleRegistered(oracleId)) revert OracleAlreadyRegistered(oracleId);
        if (implementation == address(0)) revert InvalidImplementation();
        if (bytes(name).length == 0) revert InvalidOracleData();
        if (supportedQualities.length != distributionWeights.length) revert InvalidOracleData();

        _oracles[oracleId] = OracleData({
            name: name,
            description: description,
            implementation: implementation,
            isActive: true,
            createdAt: uint64(block.timestamp),
            fixedFee: fixedFee
        });

        _isAuthorizedOracle[implementation] = true;

        // Set supported qualities and distribution weights
        for (uint256 i = 0; i < supportedQualities.length; ++i) {
            _oracleSupportsQuality[oracleId][supportedQualities[i]] = true;
            _qualityDistribution[oracleId][supportedQualities[i]] = distributionWeights[i];

            emit QualitySupportUpdated(oracleId, supportedQualities[i], true);
            emit QualityDistributionUpdated(oracleId, supportedQualities[i], distributionWeights[i]);
        }

        emit OracleRegistered(oracleId, name, implementation);
    }

    /// @inheritdoc IOracleRegistry
    function updateOracleImplementation(uint256 oracleId, address newImplementation) external override onlyOwner {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);
        if (newImplementation == address(0)) revert InvalidImplementation();
        address oldImplementation = _oracles[oracleId].implementation;
        _oracles[oracleId].implementation = newImplementation;
        _isAuthorizedOracle[oldImplementation] = false;
        _isAuthorizedOracle[newImplementation] = true;

        emit OracleUpdated(oracleId, newImplementation);
    }

    /// @inheritdoc IOracleRegistry
    function setQualitySupport(
        uint256 oracleId,
        GameConstants.ForgeQuality quality,
        bool supported,
        uint256 weight
    ) external override onlyOwner {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        _oracleSupportsQuality[oracleId][quality] = supported;

        if (supported) {
            _qualityDistribution[oracleId][quality] = weight;
            emit QualityDistributionUpdated(oracleId, quality, weight);
        } else {
            _qualityDistribution[oracleId][quality] = 0;
        }

        emit QualitySupportUpdated(oracleId, quality, supported);
    }

    /// @inheritdoc IOracleRegistry
    function updateOracleFees(uint256 oracleId, uint256 fixedFee) external override onlyOwner {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        _oracles[oracleId].fixedFee = fixedFee;

        emit OracleFeesUpdated(oracleId, fixedFee);
    }

    /// @inheritdoc IOracleRegistry
    function deactivateOracle(uint256 oracleId) external override onlyOwner {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        _oracles[oracleId].isActive = false;

        emit OracleDeactivated(oracleId);
    }

    /// @inheritdoc IOracleRegistry
    function reactivateOracle(uint256 oracleId) external override onlyOwner {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        _oracles[oracleId].isActive = true;

        emit OracleReactivated(oracleId);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       VIEW FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IOracleRegistry
    function getOracle(uint256 oracleId) external view override returns (OracleData memory oracleData) {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);
        return _oracles[oracleId];
    }

    /// @inheritdoc IOracleRegistry
    function getOracleImplementation(uint256 oracleId) external view override returns (address implementation) {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);
        return _oracles[oracleId].implementation;
    }

    /// @inheritdoc IOracleRegistry
    function getQualitySupport(
        uint256 oracleId,
        GameConstants.ForgeQuality quality
    ) external view override returns (bool supported) {
        if (!isOracleRegistered(oracleId)) return false;
        return _oracleSupportsQuality[oracleId][quality];
    }

    /// @inheritdoc IOracleRegistry
    function getQualityWeight(
        uint256 oracleId,
        GameConstants.ForgeQuality quality
    ) external view override returns (uint256 weight) {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);
        return _qualityDistribution[oracleId][quality];
    }

    /// @inheritdoc IOracleRegistry
    function calculateFee(uint256 oracleId, uint32 gasLimit) external view override returns (uint256 totalFee) {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        OracleData storage oracle = _oracles[oracleId];
        uint256 fee = IOracle(oracle.implementation).getFee(gasLimit);
        totalFee = oracle.fixedFee + fee;
    }

    /// @inheritdoc IOracleRegistry
    function determineQuality(
        uint256 oracleId,
        uint256 randomSeed,
        uint256 totalForges
    ) external view override returns (GameConstants.ForgeQuality quality) {
        if (!isOracleRegistered(oracleId)) revert OracleNotFound(oracleId);

        uint256 totalWeight = _calculateTotalWeight(oracleId);
        if (totalWeight == 0) revert QualityNotSupported(oracleId, GameConstants.ForgeQuality.SILVER);

        quality = _selectQualityByWeight(oracleId, randomSeed, totalWeight);
        if (quality == GameConstants.ForgeQuality.SILVER && !_oracleSupportsQuality[oracleId][quality]) {
            quality = _getFirstSupportedQuality(oracleId);
        }
        if (quality == GameConstants.ForgeQuality.MYTHIC && totalForges < 33) {
            quality = GameConstants.ForgeQuality.RAINBOW;
        }

        return quality;
    }

    /// @inheritdoc IOracleRegistry
    function isOracleRegistered(uint256 oracleId) public view override returns (bool registered) {
        return 0 < _oracles[oracleId].createdAt;
    }

    /// @notice Check if an oracle implementation is authorized
    /// @param oracleAddress Oracle implementation address
    /// @return authorized Whether the oracle is authorized
    function isAuthorizedOracle(address oracleAddress) external view returns (bool authorized) {
        return _isAuthorizedOracle[oracleAddress];
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Calculate total weight for all supported qualities
    /// @param oracleId Oracle ID
    /// @return totalWeight Sum of all quality weights
    function _calculateTotalWeight(uint256 oracleId) internal view returns (uint256 totalWeight) {
        for (uint256 i = 0; i < uint256(GameConstants.ForgeQuality.MYTHIC) + 1; ++i) {
            GameConstants.ForgeQuality q = GameConstants.ForgeQuality(i);
            if (_oracleSupportsQuality[oracleId][q]) {
                totalWeight += _qualityDistribution[oracleId][q];
            }
        }
    }

    /// @notice Select quality based on weighted random selection
    /// @param oracleId Oracle ID
    /// @param randomSeed Random seed
    /// @param totalWeight Total weight for normalization
    /// @return quality Selected quality (or SILVER if none found)
    function _selectQualityByWeight(
        uint256 oracleId,
        uint256 randomSeed,
        uint256 totalWeight
    ) internal view returns (GameConstants.ForgeQuality quality) {
        uint256 randomValue = randomSeed % totalWeight;
        uint256 currentWeight = 0;

        for (uint256 i = 0; i < uint256(GameConstants.ForgeQuality.MYTHIC) + 1; ++i) {
            GameConstants.ForgeQuality q = GameConstants.ForgeQuality(i);
            if (_oracleSupportsQuality[oracleId][q]) {
                currentWeight += _qualityDistribution[oracleId][q];
                if (randomValue < currentWeight) {
                    return q;
                }
            }
        }

        // Return SILVER as default if no quality was selected
        return GameConstants.ForgeQuality.SILVER;
    }

    /// @notice Get the first supported quality as fallback
    /// @param oracleId Oracle ID
    /// @return quality First supported quality
    function _getFirstSupportedQuality(uint256 oracleId) internal view returns (GameConstants.ForgeQuality quality) {
        for (uint256 i = 0; i < uint256(GameConstants.ForgeQuality.MYTHIC) + 1; ++i) {
            GameConstants.ForgeQuality q = GameConstants.ForgeQuality(i);
            if (_oracleSupportsQuality[oracleId][q]) {
                return q;
            }
        }
        revert QualityNotSupported(oracleId, GameConstants.ForgeQuality.SILVER);
    }
}
