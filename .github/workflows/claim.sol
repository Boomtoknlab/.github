// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Claim {
    address public owner;
    mapping(address => bool) public claimedAddresses;

    event AddressClaimed(address indexed claimer);

    constructor() {
        owner = msg.sender;
    }

    function claimAddress() external {
        require(!claimedAddresses[msg.sender], "Address already claimed");
        claimedAddresses[msg.sender] = true;
        emit AddressClaimed(msg.sender);
    }

    function isAddressClaimed(address _address) external view returns (bool) {
        return claimedAddresses[_address];
    }
}
