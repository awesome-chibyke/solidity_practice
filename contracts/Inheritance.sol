//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract BaseContract {
    uint public x;
    address public owner;

    constructor(uint _x){
        owner = msg.sender;
        x = _x;
    }

    function setX(uint _x) public {
        x = _x;
    }
}

contract B is BaseContract{

}