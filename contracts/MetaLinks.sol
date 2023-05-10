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

    
    

    // events

    /// @notice Event emitted when avatar is created
    /// @dev Event emitted when avatar is created
    /// @param avatarID the avatar id 
    /// @param name the avatar name 
    /// @param aka the avatar aka 
    /// @param bio the avatar bio 
    /// @param avatar the avatar avatar link
    /// @param bgAvatar the big image avatar link 
    event AvatarCreated(
        uint256 indexed avatarID,
        string name,
        string aka,
        string bio,
        string avatar,
        string bgAvatar
    );

    /// @notice Event emitted when avatar adds an address to their avatar
    /// @dev Event emitted when avatar adds an address to their avatar
    /// @param avatarID the avatar id 
    /// @param newAddresses the added addresses
    event AvatarAddressesAdded(
        uint256 indexed avatarID,
        address[] newAddresses
    );


    /// @notice Event emitted when an avatar adds a MetaLink
    /// @dev Event emitted when an avatar adds a MetaLink
    /// @param avatarID the avatar id 
    /// @param newMetaLinkID the MetaLink id 
    /// @param name the MetaLink name 
    /// @param aka the MetaLink aka 
    /// @param bio the MetaLink bio 
    /// @param avatar the MetaLink avatar link
    /// @param bgAvatar the big image MetaLink link 
    event MetaLinkAdded(
        uint256 indexed avatarID,
        uint256 indexed newMetaLinkID,
        string name,
        string aka,
        string bio,
        string universe,
        string link,
        string avatar,
        string bgAvatar,
        bool active
    );



    // constructor
    constructor() { }







}

