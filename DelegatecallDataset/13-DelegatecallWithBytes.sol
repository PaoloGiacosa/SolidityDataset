// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallWithBytes {
    address public implementation;
    
    function executeWithData(address target, bytes memory data) external {
        target.delegatecall(data);
    }
}