// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithSender {
    event SenderAction(address sender, bytes data);
    
    function emitSenderAction(bytes memory data) external {
        emit SenderAction(msg.sender, data);
    }
}