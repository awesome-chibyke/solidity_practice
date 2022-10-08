//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract A{

    address public theOwner;

    constructor(){
        theOwner = msg.sender;
    }

}


contract B{

    A[] public ownerA;
    address public ownerB;

    constructor(){
        ownerB = msg.sender;
    }

    function deployA() public {
        A new_a_address = new A();
        ownerA.push(new_a_address);
    }

}