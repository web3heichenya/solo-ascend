// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {GameConstants} from "./GameConstants.sol";

/// @title ForgeItemMetadataLib
/// @notice Library for generating forge item metadata and SVG images
/// @author Solo Ascend Team
library ForgeItemMetadataLib {
    using Strings for uint256;

    /// @notice Generate token URI with dynamic metadata
    /// @param tokenId Token ID
    /// @param item Forge effect data
    /// @param effectTypeName Effect type name from registry or fallback
    /// @param forgerName Forger name from registry or fallback
    /// @return JSON metadata string
    function generateTokenURI(
        uint256 tokenId,
        GameConstants.ForgeEffect memory item,
        string memory effectTypeName,
        string memory forgerName
    ) internal pure returns (string memory) {
        string memory name = generateName(tokenId, forgerName);
        string memory description = generateDescription(item, effectTypeName);
        string memory image = generateSVG(item, effectTypeName);

        string memory json = string(
            abi.encodePacked(
                '{"name":"',
                name,
                '",',
                '"description":"',
                description,
                '",',
                '"image":"data:image/svg+xml;base64,',
                Base64.encode(bytes(image)),
                '",',
                '"attributes":',
                generateAttributes(item, effectTypeName),
                "}"
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }

    /// @notice Generate forge item name
    /// @param tokenId Token ID
    /// @param forgerName Forger name
    /// @return Name string
    function generateName(uint256 tokenId, string memory forgerName) internal pure returns (string memory) {
        return string(abi.encodePacked(forgerName, " #", tokenId.toString()));
    }

    /// @notice Generate description based on effect
    /// @param item Forge effect data
    /// @param effectTypeName Effect type name
    /// @return Description string
    function generateDescription(
        GameConstants.ForgeEffect memory item,
        string memory effectTypeName
    ) internal pure returns (string memory) {
        string memory effectValueStr = getEffectValueString(item);
        return string(abi.encodePacked(effectTypeName, " forge item that provides ", effectValueStr, "."));
    }

    /// @notice Generate SVG image with quality-based borders
    /// @param item Forge effect data
    /// @param effectTypeName Effect type name
    /// @return SVG string
    function generateSVG(
        GameConstants.ForgeEffect memory item,
        string memory effectTypeName
    ) internal pure returns (string memory) {
        string memory effectValue = getEffectValueString(item);
        (string memory borderDefs, string memory borderRect) = generateQualityBorder(item.quality);

        return
            string(
                abi.encodePacked(
                    '<svg width="350" height="350" xmlns="http://www.w3.org/2000/svg">',
                    borderDefs,
                    borderRect,
                    '<text x="175" y="150" font-family="serif" font-size="18" fill="white" text-anchor="middle">',
                    effectTypeName,
                    "</text>",
                    '<text x="175" y="200" font-family="serif" font-size="14" fill="white" text-anchor="middle">',
                    effectValue,
                    "</text>",
                    "</svg>"
                )
            );
    }

    /// @notice Generate quality-based border for SVG
    /// @param quality The forge quality
    /// @return defs SVG definitions for gradients/animations
    /// @return rect SVG rectangle with border
    function generateQualityBorder(
        GameConstants.ForgeQuality quality
    ) internal pure returns (string memory defs, string memory rect) {
        if (quality == GameConstants.ForgeQuality.SILVER) {
            // Silver border - simple silver color
            defs = "";
            rect = '<rect width="100%" height="100%" fill="black" stroke="#C0C0C0" stroke-width="3"/>';
        } else if (quality == GameConstants.ForgeQuality.GOLD) {
            // Gold border - golden color with slight glow
            defs = string(
                abi.encodePacked(
                    "<defs>",
                    '<filter id="goldGlow">',
                    '<feGaussianBlur stdDeviation="2" result="coloredBlur"/>',
                    "<feMerge>",
                    '<feMergeNode in="coloredBlur"/>',
                    '<feMergeNode in="SourceGraphic"/>',
                    "</feMerge>",
                    "</filter>",
                    "</defs>"
                )
            );
            rect = '<rect width="100%" height="100%" fill="black" stroke="#FFD700" stroke-width="4" filter="url(#goldGlow)"/>';
        } else if (quality == GameConstants.ForgeQuality.RAINBOW) {
            // Rainbow border - static gradient
            defs = string(
                abi.encodePacked(
                    "<defs>",
                    '<linearGradient id="rainbowGradient" x1="0%" y1="0%" x2="100%" y2="100%">',
                    '<stop offset="0%" style="stop-color:#FF0000"/>',
                    '<stop offset="16.66%" style="stop-color:#FF7F00"/>',
                    '<stop offset="33.33%" style="stop-color:#FFFF00"/>',
                    '<stop offset="50%" style="stop-color:#00FF00"/>',
                    '<stop offset="66.66%" style="stop-color:#0000FF"/>',
                    '<stop offset="83.33%" style="stop-color:#4B0082"/>',
                    '<stop offset="100%" style="stop-color:#9400D3"/>',
                    "</linearGradient>",
                    "</defs>"
                )
            );
            rect = '<rect width="100%" height="100%" fill="black" stroke="url(#rainbowGradient)" stroke-width="5"/>';
        } else if (quality == GameConstants.ForgeQuality.MYTHIC) {
            // Mythic border - animated gradient with pulsing effect
            defs = string(
                abi.encodePacked(
                    "<defs>",
                    '<linearGradient id="mythicGradient" x1="0%" y1="0%" x2="100%" y2="100%">',
                    '<stop offset="0%" style="stop-color:#FF69B4">',
                    '<animate attributeName="stop-color" values="#FF69B4;#9370DB;#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4" dur="3s" repeatCount="indefinite"/>',
                    "</stop>",
                    '<stop offset="25%" style="stop-color:#9370DB">',
                    '<animate attributeName="stop-color" values="#9370DB;#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB" dur="3s" repeatCount="indefinite"/>',
                    "</stop>",
                    '<stop offset="50%" style="stop-color:#4169E1">',
                    '<animate attributeName="stop-color" values="#4169E1;#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1" dur="3s" repeatCount="indefinite"/>',
                    "</stop>",
                    '<stop offset="75%" style="stop-color:#00FFFF">',
                    '<animate attributeName="stop-color" values="#00FFFF;#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1;#00FFFF" dur="3s" repeatCount="indefinite"/>',
                    "</stop>",
                    '<stop offset="100%" style="stop-color:#00FF00">',
                    '<animate attributeName="stop-color" values="#00FF00;#FFD700;#FF4500;#FF69B4;#9370DB;#4169E1;#00FFFF;#00FF00" dur="3s" repeatCount="indefinite"/>',
                    "</stop>",
                    "</linearGradient>",
                    '<filter id="mythicGlow">',
                    '<feGaussianBlur stdDeviation="3" result="coloredBlur"/>',
                    "<feMerge>",
                    '<feMergeNode in="coloredBlur"/>',
                    '<feMergeNode in="SourceGraphic"/>',
                    "</feMerge>",
                    "</filter>",
                    "</defs>"
                )
            );
            rect = string(
                abi.encodePacked(
                    '<rect width="100%" height="100%" fill="black" stroke="url(#mythicGradient)" stroke-width="6" filter="url(#mythicGlow)">',
                    '<animate attributeName="stroke-width" values="6;8;6" dur="2s" repeatCount="indefinite"/>',
                    "</rect>"
                )
            );
        } else {
            // Default fallback
            defs = "";
            rect = '<rect width="100%" height="100%" fill="black" stroke="#808080" stroke-width="2"/>';
        }
    }

    /// @notice Generate attributes array for OpenSea
    /// @param item Forge effect data
    /// @param effectTypeName Effect type name
    /// @return Attributes JSON string
    function generateAttributes(
        GameConstants.ForgeEffect memory item,
        string memory effectTypeName
    ) internal pure returns (string memory) {
        string memory baseAttributes = string(
            abi.encodePacked(
                '[{"trait_type":"Effect Type","value":"',
                effectTypeName,
                '"},',
                '{"trait_type":"Quality","value":"',
                getQualityString(item.quality),
                '"},'
            )
        );

        // Add Attribute trait for ATTRIBUTE effect type
        string memory attributeField = "";
        if (item.effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            attributeField = string(
                abi.encodePacked(
                    '{"trait_type":"Attribute","value":"',
                    GameConstants.getAttributeName(item.attribute),
                    '"},'
                )
            );
        }

        string memory endAttributes = string(
            abi.encodePacked(
                '{"trait_type":"Value","value":',
                uint256(item.value).toString(),
                "},",
                '{"trait_type":"Created At","value":',
                uint256(item.createdAt).toString(),
                "}]"
            )
        );

        return string(abi.encodePacked(baseAttributes, attributeField, endAttributes));
    }

    /// @notice Get quality string
    /// @param quality Quality enum
    /// @return Quality string
    function getQualityString(GameConstants.ForgeQuality quality) internal pure returns (string memory) {
        return GameConstants.getQualityName(quality);
    }

    /// @notice Generate effect value description
    /// @param item Forge effect data
    /// @return Effect value string
    function getEffectValueString(GameConstants.ForgeEffect memory item) internal pure returns (string memory) {
        if (item.effectType == GameConstants.ForgeEffectType.ATTRIBUTE) {
            return
                string(
                    abi.encodePacked(
                        "+",
                        uint256(item.value).toString(),
                        " to ",
                        GameConstants.getAttributeName(item.attribute)
                    )
                );
        } else if (item.effectType == GameConstants.ForgeEffectType.ENHANCE) {
            return "Splits into 2 random attribute forged items";
        } else if (item.effectType == GameConstants.ForgeEffectType.AMPLIFY) {
            return
                string(
                    abi.encodePacked(
                        "+",
                        uint256(item.value / 100).toString(),
                        ".",
                        uint256((item.value % 100) / 10).toString(),
                        "% to all attributes"
                    )
                );
        } else if (item.effectType == GameConstants.ForgeEffectType.FT) {
            return
                string(
                    abi.encodePacked(
                        uint256(item.value / 100).toString(),
                        ".",
                        uint256((item.value % 100) / 10).toString(),
                        "% token reward"
                    )
                );
        } else if (item.effectType == GameConstants.ForgeEffectType.NFT) {
            return "Exclusive NFT reward";
        } else if (item.effectType == GameConstants.ForgeEffectType.MYTHIC) {
            return "Solo Leveling";
        }
        return "Unknown effect";
    }
}
