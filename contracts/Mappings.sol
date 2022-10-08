// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract MappingsDemo{

    mapping(address => uint) public bids;

    function bidForProduct() payable public {
        bids[msg.sender] = msg.value;
    }

}