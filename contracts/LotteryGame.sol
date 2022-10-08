// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract LotteryGame{

    //declare the dynamic array that will hold the addresses of the players
    address payable[] public players;

    //address that deploys the smart
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    //play the game
    receive() external payable {
        require(msg.value == 0.1 ether); //each player must send an equivalent of 1 ether

        //save the address that sent ether to the players array, address must be converted to payable address
        players.push(payable(msg.sender));
    }

    //get the balance of the smart contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }


    //create a random number that will help in calculating the winner of the game
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    //declare the result
    function selectWinner() public {
        //winner must be declared by the owner of the smart contract
        require(msg.sender == owner);

        //there must be more than three players in the game before result can be declared
        require(players.length >= 3);

        //get the random number
        uint randomNumber = random();

        //get the modulus
        uint index = randomNumber % players.length;

        //get the winner
        address payable winner = players[index];

        //send all the balance of the smart contract to the winner
        winner.transfer(getBalance());

        //reset the payable array
        players = new address payable[](0);
    }

}