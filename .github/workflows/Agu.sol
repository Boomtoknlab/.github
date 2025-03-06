// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Agu {
    address public owner;
    mapping(address => uint256) public balances;

    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mintTokens(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid address");
        balances[to] += amount;
        emit TokensMinted(to, amount);
    }

    function burnTokens(address from, uint256 amount) external onlyOwner {
        require(from != address(0), "Invalid address");
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        emit TokensBurned(from, amount);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }
}
