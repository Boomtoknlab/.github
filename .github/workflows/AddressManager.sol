// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AddressManager {
    address public owner;
    mapping(string => address) private addresses;

    event AddressAdded(string indexed name, address indexed addr);
    event AddressRemoved(string indexed name);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addAddress(string memory name, address addr) public onlyOwner {
        addresses[name] = addr;
        emit AddressAdded(name, addr);
    }

    function getAddress(string memory name) public view returns (address) {
        return addresses[name];
    }

    function removeAddress(string memory name) public onlyOwner {
        delete addresses[name];
        emit AddressRemoved(name);
    }
}
