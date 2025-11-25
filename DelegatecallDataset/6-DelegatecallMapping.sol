// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallMapping {
    mapping(uint => address) public targets;
    
    function execute(uint id, bytes memory data) external {
        targets[id].delegatecall(data);
    }
}