// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract BAIT {
    string public name = "Bait";
    string public symbol = "BAIT";
    uint256 public totalSupply;
    uint8 public constant decimals = 18;
    
    address public owner;
    address public postContract;
    
    mapping(address => uint256) public balanceOf;
    
    event Mint(address indexed to, uint256 amount);
    
    constructor() {
        owner = msg.sender;
        // 预铸造一些代币给部署者
        _mint(msg.sender, 10000 * 10**decimals);
    }
    
    // 内部铸造函数
    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Mint to zero address");
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
    }
    
    // 设置Post合约地址
    function setPostContract(address _postContract) external {
        require(msg.sender == owner, "Only owner");
        require(postContract == address(0), "Already set");
        postContract = _postContract;
    }
    
    // Post合约调用来奖励用户
    function mint(address to, uint256 amount) external {
        require(msg.sender == postContract, "Only post contract");
        _mint(to, amount);
    }
}