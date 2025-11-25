pragma solidity ^0.6.0;

// Contract 1: Evento semplice con address
contract SimpleEventEmitter {
    event UserAction(address user);
    
    function emitEvent(address user) external {
        emit UserAction(user);
    }
}