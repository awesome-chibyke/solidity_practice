//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0 <0.9.0;
 
contract Deposit{
    
    receive() external payable{}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    //transfer eth to an address
    function transferEth(address payable receipient) public {
        receipient.transfer(address(this).balance);
    }
}
