// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallWithEvents {
    event Executed(address target);
    
    function execute(address target, bytes memory data) external {
        target.delegatecall(data);
        emit Executed(target);
    }
}