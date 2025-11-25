// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallWithValue {
    function execute(address target, bytes memory data) external payable {
        target.delegatecall(data);
    }
}