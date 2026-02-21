// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IHeroClassRegistry
/// @notice Interface for the HeroClassRegistry contract
/// @author Solo Ascend Team
interface IHeroClassRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /// @notice Error thrown when the class is already registered
    error ClassAlreadyRegistered(GameConstants.HeroClass classId);
    /// @notice Error thrown when the class is not found
    error ClassNotFound(GameConstants.HeroClass classId);
    /// @notice Error thrown when the class data is invalid
    error InvalidClassData();
    /// @notice Error thrown when there are no active classes
    error NoActiveClasses();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new hero class is registered
    /// @param classId Unique identifier for the class
    /// @param name Display name for the class
    /// @param baseAttributes Base attributes for this class
    event HeroClassRegistered(
        GameConstants.HeroClass indexed classId,
        string name,
        GameConstants.HeroAttributes baseAttributes
    );

    /// @notice Emitted when a hero class's base attributes are updated
    /// @param classId Class ID to update
    /// @param newBaseAttributes New base attributes for the class
    event HeroClassUpdated(GameConstants.HeroClass indexed classId, GameConstants.HeroAttributes newBaseAttributes);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get hero class data
    /// @param classId Class ID to query
    /// @return classData Hero class data
    function getHeroClassData(
        GameConstants.HeroClass classId
    ) external view returns (GameConstants.HeroClassData memory classData);

    /// @notice Get base attributes for a class
    /// @param classId Class ID to query
    /// @return attributes Base attributes for the class
    function getClassBaseAttributes(
        GameConstants.HeroClass classId
    ) external view returns (GameConstants.HeroAttributes memory attributes);

    /// @notice Get total number of active classes
    /// @return count Number of active classes
    function getActiveClassCount() external view returns (uint256 count);

    /// @notice Get all active class IDs
    /// @return activeClasses Array of active class IDs
    function getActiveClasses() external view returns (GameConstants.HeroClass[] memory activeClasses);

    /// @notice Get a random active class ID
    /// @param randomSeed Random seed for class selection
    /// @return classId Random active class ID
    function getRandomClass(uint256 randomSeed) external view returns (GameConstants.HeroClass classId);

    /// @notice Register a new hero class
    /// @param classId Unique identifier for the class
    /// @param name Display name for the class
    /// @param description Class description
    /// @param baseAttributes Base attributes for this class
    function registerHeroClass(
        GameConstants.HeroClass classId,
        string calldata name,
        string calldata description,
        GameConstants.HeroAttributes calldata baseAttributes
    ) external;

    /// @notice Update base attributes for an existing class
    /// @param classId Class to update
    /// @param newBaseAttributes New base attributes
    function updateClassAttributes(
        GameConstants.HeroClass classId,
        GameConstants.HeroAttributes calldata newBaseAttributes
    ) external;
}
