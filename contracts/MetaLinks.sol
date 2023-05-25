// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/access/Ownable.sol";

// to use console.log
import "hardhat/console.sol";



/// @title MetaLinks
/// @author efenstakes / felix
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

    // map an address to their avatar id
    mapping( address => uint256 ) public addressToAvatarID;

    // map an id to avatar data
    mapping( uint256 => Avatar ) public idToAvatar;
    
    // map a metalink id to links
    mapping( uint256 => MetaLink ) public idToLink;



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


    // modifiers

    /// @notice Ensure address has an avatar
    /// @dev Ensure address has an avatar
    modifier isMember() {
        require( addressToAvatarID[msg.sender] > 0 && addressToAvatarID[msg.sender] <= totalAvatars, "You have to be a member" );
        _;
    }

    /// @notice Ensure address has no avatar
    /// @dev Ensure address has no avatar
    modifier isNotMember() {
        require( addressToAvatarID[msg.sender] == 0, "You are already a member" );
        _;
    }



    /// @notice Create an avatar
    /// @dev Create an avatar
    /// @param _name the avatar name 
    /// @param _aka the avatar aka 
    /// @param _bio the avatar bio 
    /// @param _avatar the avatar avatar link
    /// @param _bg_avatar the big image avatar link 
    // generate new avatar id
    // associate address with generated avatar id
    // create avatar
    // add avatar to idToAvatar
    // increase number of avatars by 1
    // emit event
    // return bool
    function createAvatar( string memory _name, string memory _aka, string memory _bio, string memory _avatar, string memory _bg_avatar ) external isNotMember returns (uint256) {
        // generate new avatar id
        uint256 id = totalAvatars + 1;

        // associate address with generated avatar id
        addressToAvatarID[msg.sender] = id;

        // create avatar
        Avatar memory newAvatar = Avatar({
            name: _name,
            aka: _aka,
            bio: _bio,
            avatar: _avatar,
            bg_avatar: _bg_avatar,
            links: new uint256[](0)
        });
        
        // add avatar to idToAvatar
        idToAvatar[id] = newAvatar;

        // increase number of avatars by 1
        totalAvatars++;

        // increase number of addresses added so far
        totalAddresses++;

        // emit event
        emit AvatarCreated( id, _name, _aka, _bio, _avatar, _bg_avatar );

        return id;
    }



    /// @notice Add an avatars address
    /// @dev Add an avatars address. It skips any addresses that have already been added
    /// @param _addresses the new avatar _addresses
    // get address avatar id
    // for each address, add it to addressToAvatarID
    // emit event
    // return bool
    function addAvatarAddress(address[] memory _addresses) public isMember returns(bool) {
        // get address avatar id
        uint256 avatarID = addressToAvatarID[msg.sender];

        // ensure id is valid
        require( avatarID > 0 && avatarID <= totalAvatars, "Not a valid Avatar ID" );


        // for each address, add it to addressToAvatarID
        for( uint32 counter = 0; counter < _addresses.length; counter++ ) {
            bool alreadyExists = addressToAvatarID[_addresses[counter]] > 0;

            // if address is not added, add it
            if( !alreadyExists ) {
                addressToAvatarID[_addresses[counter]] = avatarID;
                totalAddresses++;
            }
        }

        // emit event
        emit AvatarAddressesAdded( avatarID, _addresses );
       
        return true;
    }




    /// @notice Add an avatars MetaLink
    /// @dev Add an avatars MetaLink
    /// @param _name the metalink name 
    /// @param _aka the metalink aka 
    /// @param _bio the metalink bio 
    /// @param _universe the metalink universe 
    /// @param _avatar the metalink avatar link
    /// @param _bg_avatar the metalink big image avatar link 
    /// @param _link the metalink link
    /// @param _active the determinant for whether metalink is active or not
    // create link
    // generate a link id from totalMetaLinks
    // use the id to save link to midToMetaLinks mapping
    // add link to users avatar links array
    // increase total metalinks with 1
    // emit event
    // return bool
    function addAvatarMetalink( string memory _name, string memory _aka, string memory _bio, string memory _universe, string memory _avatar, string memory _bg_avatar, string memory _link, bool _active ) external isMember returns (bool) {
        // get the avatar id
        uint256 avatarID = addressToAvatarID[msg.sender];

        // get the avatar
        Avatar storage myAvatar = idToAvatar[avatarID];

        // generate a link id from totalMetaLinks
        uint256 newLinkID = totalMetaLinks + 1;

        // create link
        MetaLink memory newLink = MetaLink({
            name: _name,
            aka: _aka,
            bio: _bio,
            universe: _universe,
            link: _link,
            avatar: _avatar,
            bg_avatar: _bg_avatar,
            active: _active
        });

        // use the id to save link to midToMetaLinks mapping
        idToLink[newLinkID] = newLink;

        // add link to avatar's links array
        myAvatar.links.push(newLinkID);

        // increase total metalinks with 1
        totalMetaLinks++;

        // emit event
        // resulted to using newLink.**PROPOERTY_NAME** because of a stack too deep error
        emit MetaLinkAdded(
            avatarID,
            newLinkID,
            _name,
            _aka,
            _bio,
            _universe,
            _link,
            newLink.avatar,
            newLink.bg_avatar,
            newLink.active
        );

        return true;
    }


    /// @notice Check if given address is used
    /// @dev Check if given address is used
    /// @param _address the address
    function isAddressUsed(address _address) public view returns(bool) {
        return addressToAvatarID[_address] > 0;
    }


    /// @notice Get my id given address
    /// @dev Get my id given address
    function getMyAvatarID() public view returns(uint256) {
        return addressToAvatarID[msg.sender];
    }


    /// @notice Get avatar id given address
    /// @dev Get avatar id given address
    /// @param _address the avatar address
    function getAvatarID(address _address) public view returns(uint256) {
        return addressToAvatarID[_address];
    }


    
    /// @notice Get avatar given address
    /// @dev Get avatar given address
    /// @param _address the avatar address
    function getAvatarByAddress(address _address) public view returns(string memory, string memory, string memory, string memory, string memory, uint[] memory links) {
        uint256 id = addressToAvatarID[_address];
        
        // ensure the avatar exists
        require( id > 0 && id <= totalAvatars , "Avatar does not exist" );

        Avatar memory avatar = idToAvatar[id];

        return ( avatar.name, avatar.aka, avatar.bio, avatar.avatar, avatar.bg_avatar, avatar.links );
    }
    
    
    /// @notice Get avatar given its id
    /// @dev Get avatar given its id
    /// @param _id the avatar id
    function getAvatarById(uint256 _id) public view returns(string memory, string memory, string memory, string memory, string memory, uint[] memory links) {      
        // ensure the avatar exists
        require( _id > 0 && _id <= totalAvatars , "Avatar does not exist" );

        Avatar memory avatar = idToAvatar[_id];

        return ( avatar.name, avatar.aka, avatar.bio, avatar.avatar, avatar.bg_avatar, avatar.links );
    }


    /// @notice Get avatar metalink id list
    /// @dev Get avatar metalink id list
    /// @param _id the avatar id
    function getAvatarMetaLinkIDs(uint256 _id) public view returns(uint256[] memory links) {        
        Avatar memory avatar = idToAvatar[_id];

        return avatar.links;
    }

    /// @notice Get metalink data
    /// @dev Get metalink data
    /// @param _id the metalink id
    function getMetaLink(uint256 _id) public view returns(string memory, string memory, string memory, string memory, string memory, string memory, string memory, bool) {
        // ensure the metalink exists
        require( _id > 0 && _id <= totalMetaLinks , "MetaLink does not exist" );

        MetaLink memory metaLink = idToLink[_id];

        return ( metaLink.name, metaLink.aka, metaLink.universe, metaLink.bio, metaLink.avatar, metaLink.bg_avatar, metaLink.link, metaLink.active );
    }
    
    /// @notice Get avatar metalinks data
    /// @dev Get avatar metalinks data
    /// @param _id the avatar id
    function getMetaLinks(uint256 _id) public view returns(MetaLink[] memory) {
        // ensure the avatar exists
        require( _id > 0 && _id <= totalAvatars , "Avatar does not exist" );

        uint[] memory metaLinkIds = idToAvatar[_id].links;
        MetaLink[] memory metaLinks;

        for (uint256 index = 0; index < metaLinkIds.length; index++) {
            MetaLink memory metaLink = idToLink[ metaLinkIds[index] ];
            metaLinks[ index ] = metaLink;
        }

        return metaLinks;
    }






}

