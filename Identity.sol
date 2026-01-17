// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Identity {
    struct User {
        string name;
        uint256 nonce;
    }
    
    mapping(address => User) public users;
    
    event IdentitySet(address indexed user, string name, string displayIdentity);
    
    function setIdentity(string memory _name) external {
        require(bytes(_name).length > 0, "Name required");
        require(bytes(_name).length <= 20, "Name too long");
        
        users[msg.sender].name = _name;
        users[msg.sender].nonce += 1;
        
        string memory display = getDisplayIdentity(msg.sender);
        emit IdentitySet(msg.sender, _name, display);
    }
    
    function getDisplayIdentity(address _user) public view returns (string memory) {
        User memory user = users[_user];
        
        if (bytes(user.name).length == 0) {
            return "anon#0000";
        }
        
        uint256 hashNum = uint256(keccak256(abi.encodePacked(_user, user.nonce)));
        string memory shortHash = uintToString((hashNum % 10000));
        
        while (bytes(shortHash).length < 4) {
            shortHash = string(abi.encodePacked("0", shortHash));
        }
        
        return string(abi.encodePacked(user.name, "#", shortHash));
    }
    
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        
        uint256 temp = value;
        uint256 digits;
        
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }
}