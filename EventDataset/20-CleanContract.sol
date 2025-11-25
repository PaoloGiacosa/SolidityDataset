// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract HelloWorld {
    string private greeting;
    address public owner;
    
    // Evento per notificare i cambiamenti del messaggio
    event GreetingChanged(string newGreeting, address changedBy);
    
    // Modifier per restringere l'accesso al proprietario
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo il proprietario puo' eseguire questa funzione");
        _;
    }
    
    // Costruttore
    constructor() {
        greeting = "Hello, World!";
        owner = msg.sender;
    }
    
    // Funzione per ottenere il saluto corrente
    function getGreeting() public view returns (string memory) {
        return greeting;
    }
    
    // Funzione per cambiare il saluto (solo proprietario)
    function setGreeting(string memory _newGreeting) public onlyOwner {
        greeting = _newGreeting;
        if(keccak256(abi.encodePacked(_newGreeting)) != keccak256(abi.encodePacked("")))
            emit GreetingChanged(_newGreeting, msg.sender);
    }
    
    // Funzione per ottenere l'indirizzo del proprietario
    function getOwner() public view returns (address) {
        return owner;
    }
    
    // Funzione per trasferire la proprietà
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Indirizzo non valido");
        owner = _newOwner;
    }
}