// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {

    string public name;

    constructor(string memory _name) {
        name = _name;
    }

    function sayHelloWorld() public pure returns (string memory) {
        return "Hello world, thus na first contract";
    }

    function spitName() public view returns (string memory) {
        return name;
    }

}