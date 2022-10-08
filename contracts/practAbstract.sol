//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

abstract contract BaseContract{
    uint public x;
    address public owner;

    function setX(uint _x) public virtual;
}

contract DerivedContract is BaseContract{

    constructor(uint _x){
        x = _x;
        owner = msg.sender;
    }

    function setX(uint _x) public override {
        x = _x;
    }
}