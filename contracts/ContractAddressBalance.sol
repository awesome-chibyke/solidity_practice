// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract ContractAddressBalance{

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable {

    }

    fallback() external payable {
        
    }
//0x7b627a4663f7992A8c019f411467a25766AD9f54
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendEth() public payable {
        
    }

    function transferEther(address payable receipient, uint amount) public returns(bool){
        // checking that only contract owner can send ether from the contract to another address
         require(owner == msg.sender, "Transfer failed, you are not the owner!!");

        if(amount <= getBalance()){
            receipient.transfer(amount);
            return true;
        }else{
            return false;
        }
    } 

}