//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CryptosToken{
    string constant public name = "Cryptos";
    uint supply;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function setSupplyValue(uint _supply) public {
        supply = _supply;
    }

    function getSupplyValue() public view returns(uint){
        return supply;
    }
}