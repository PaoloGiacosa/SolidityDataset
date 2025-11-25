// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallWithAddress {
    function execute(address target) external payable {
        target.delegatecall(msg.data);
    }
}