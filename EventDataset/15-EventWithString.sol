// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithString {
    event Message(string content);
    
    function emitMessage(string memory content) external {
        emit Message(content);
    }
}