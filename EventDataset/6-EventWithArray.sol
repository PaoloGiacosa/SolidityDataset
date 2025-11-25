// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithArray {
    event NumberList(uint256[] numbers);
    
    function emitNumbers(uint256[] memory numbers) external {
        emit NumberList(numbers);
    }
}