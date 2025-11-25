// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithAddressArray {
    event AddressList(address[] addresses);
    
    function emitAddresses(address[] memory addresses) external {
        emit AddressList(addresses);
    }
}