// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/access/Ownable.sol";

// to use console.log
import "hardhat/console.sol";



/// @title MetaLinks
/// @author efenstakes
/// @notice Manages MetaLinks avatars & their links
/// @dev this contract has logic to store and retrieve metalink avatars and their links
contract MetaLinks is Ownable {

    // total number of avatars so far
    // @dev this is used to allocate ids to new avatars
    uint256 public totalAvatars;

    // total number of links so far
    // @dev this is used to allocate ids to new links
    uint256 public totalMetaLinks;

    // total addresses that have been added
    uint256 public totalAddresses;

    // map a metalink id to their addresses
    mapping( address => uint256 ) public addressesToMID;

    // map an id to avatar data
    mapping( uint256 => Avatar ) public midsToAvatars;
    
    // map an metalink id to links
    mapping( uint256 => MetaLink ) public midsToMetaLinks;



    // structs
    
    /// @notice Avatar struct
    /// @dev Avatar struct
    struct Avatar {
        string name;
        string aka;
        string bio;
        string avatar;
        string bg_avatar;
        uint256[] links;
    }

    
    /// @notice MetaLink struct
    /// @dev MetaLink struct
    struct MetaLink {
        string name;
        string aka;
        string universe;
        string link;
        string bio;
        string avatar;
        string bg_avatar;
        bool active;
    }

    





}

