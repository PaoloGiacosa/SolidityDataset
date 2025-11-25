// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract StorageDelegatecall {
    mapping(address => bool) public authorized;
    
    function execute(address target) external {
        target.delegatecall(msg.data);
    }
}