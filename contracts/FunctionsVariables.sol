// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract FunctionsVariable{

    int public price;//int type variable
    string public location;//string variable type

    //set the owner to hold the address that deploys the contract, it should be immutable
    address immutable public owner;

    //when a contanst is declared, the value is initialized immidiately
    int constant public area = 100;

    constructor(int _price, string memory _location){
        owner = msg.sender;
        price = _price;
        location = _location;//initializing values in the construct of the smart contract
    }

    function setPrice(int _price) public {
        int a;
        a = 10;

        price = _price;
    }

    function setLocation(string memory _location) public {
        location = _location;
    }

    function getPrice() public view returns(int){
        //functions declared view does not alter the blockchain
        return price;
    }



}