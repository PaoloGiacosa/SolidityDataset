// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithMsgData {
    event RawData(bytes data);
    
    function emitRawData() external {
        emit RawData(msg.data);
    }
}