// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallChain {
    address public next;
    
    function setNext(address _next) external {
        next = _next;
    }
    
    fallback() external payable {
        next.delegatecall(msg.data);
    }
}