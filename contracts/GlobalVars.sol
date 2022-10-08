// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract GlobalVars{

    // the current time as a timestamp (seconds from 01 Jan 1970)
    uint public this_moment = block.timestamp; // `now` is deprecated and is an alias to block.timestamp)
    
    // the current block number
    uint public block_number = block.number;
    
    // the block difficulty
    uint public difficulty = block.difficulty;
    
    // the block gas limit
    uint public gaslimit = block.gaslimit;

    address public owner;

    uint public sentValue;

    constructor(){//get the adddress that deployed the contract
        owner = msg.sender;
    } 

    //gget the address that called this function
    function changeOwner() public {
        owner = msg.sender;
    }

    //send ether
    function sendEther() public payable {
        sentValue = msg.value;
    }

    //get the value of ether that is existing in the smart contract
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    //calculate the amount of gas spent while running a block of function code
    function getGasSpent() public view returns(uint){

        uint start = gasleft();
        uint l = 1;

        //add a block of codde that will run
        for(uint i = 0; i < 100; i++){
            l *= i;
        }

        uint end = gasleft();

        return start - end;

    }

}