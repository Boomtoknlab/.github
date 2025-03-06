// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mysportybetloyalty {
    address public owner;
    mapping(address => uint256) public loyaltyPoints;
    uint256 public totalPoints;

    event PointsAwarded(address indexed user, uint256 points);
    event PointsRedeemed(address indexed user, uint256 points);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function awardPoints(address user, uint256 points) external onlyOwner {
        require(user != address(0), "Invalid address");
        loyaltyPoints[user] += points;
        totalPoints += points;
        emit PointsAwarded(user, points);
    }

    function redeemPoints(address user, uint256 points) external onlyOwner {
        require(user != address(0), "Invalid address");
        require(loyaltyPoints[user] >= points, "Insufficient points");
        loyaltyPoints[user] -= points;
        totalPoints -= points;
        emit PointsRedeemed(user, points);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getPoints(address user) external view returns (uint256) {
        return loyaltyPoints[user];
    }
}
