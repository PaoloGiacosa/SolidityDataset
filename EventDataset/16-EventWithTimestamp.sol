// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithTimestamp {
    event TimedAction(uint256 timestamp, bytes data);
    
    function emitTimedAction(bytes memory data) external {
        emit TimedAction(block.timestamp, data);
    }
}