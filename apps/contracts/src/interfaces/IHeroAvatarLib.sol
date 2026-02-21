// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title IHeroAvatarLib
/// @notice Interface for HeroAvatarLib library that generates SVG avatars
/// @author Solo Ascend Team
interface IHeroAvatarLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get CryptoPunks-style avatar SVG for a hero based on class and stage
    /// @param classId Hero class ID (0-4: Warrior, Mage, Archer, Rogue, Paladin)
    /// @param tokenId The token ID of the hero (used for variation)
    /// @param stage Hero stage (FORGING, COMPLETED, SOLO_LEVELING)
    /// @return avatarSVG Complete SVG string for the full-body hero avatar with stage-specific equipment
    function getHeroAvatar(
        GameConstants.HeroClass classId,
        uint256 tokenId,
        GameConstants.HeroStage stage
    ) external pure returns (string memory avatarSVG);
}
