//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

interface BaseContract{

    function setX(uint _x) external;

    function setB(uint _y) external;

}

contract A is BaseContract{
    
    uint public x;
    uint public y;

    function setX(uint _x) public override {
        x = _x;
    }

    function setB(uint _y) public override {
        y = _y;
    }
}