//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0 <0.9.0;
 
contract Deposit{

    address immutable public admin;

    constructor(){
        admin = msg.sender;
    }
    
    receive() external payable{}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function transferBalance(address payable recipient) public{
        require(admin == msg.sender, "you are not an admin, please vamus");
        
        uint balance = getBalance();
        recipient.transfer(balance);
    }
}
