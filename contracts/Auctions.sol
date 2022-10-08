//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract AuctionCreator{
    Auction[] public createdAuctions;

    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        createdAuctions.push(newAuction);
    }

}

contract Auction{

    mapping(address => uint) public bidsMap;
    address payable public owner;


    address payable public highestBidder;
    uint public higestBindingBid;
    uint public bidIncrement;

    //timing
    uint public startBlock;
    uint public endBlock;

    //minitor the state of the auction
    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;

    string public ipfsHash;

    bool public ownerRewardChance = true;


    constructor(address eoa){
        owner = payable(eoa);
        bidIncrement = 100;
        auctionState = State.Running;

        ipfsHash = '';

        startBlock = block.number;
        endBlock = startBlock + 3;
    }

    modifier notOwner() {
        require(msg.sender != owner, "Bids can only be placed by none owners");
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock, "Auction cannot be played at this time");
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock, "Auction time has elasped");
        _;
    }

    //helper function for getting the min bid between two bids
    function min(uint a, uint b) pure internal returns(uint){
        if(a <= b){
            return a;
        }else{
            return b;
        }
    } 

    // address1 = 20;
    // address2 = 30;
    // increment = 10;
    // highestbingbid = {lowest + increment} = 30;//increment must be added to the lowest bid between the now highest and the formal highes
    // .........................
    // address3 = 40;
    // currentBid = 40 + 0 = 40;
    // highestbingbid = {lowest + increment} = 30;

    function makeABid() payable public notOwner afterStart beforeEnd {
        require(msg.value > 1 ether, "Value sent must be greater than 1 ether");//minimum va;lue allowed to be placed
        require(auctionState == State.Running, "Auction state must be running to accept bids");//check if the auction is on running state

        //place a bid
        uint currentBid = msg.value + bidsMap[msg.sender];

        require(currentBid > higestBindingBid);//check if the current bid is greater than the highest binding bid

        //add the current bid to the map
        bidsMap[msg.sender] = currentBid;

        //check for the highestbindingbid
        if(currentBid < bidsMap[highestBidder]){
            higestBindingBid = min(currentBid + bidIncrement, bidsMap[highestBidder]);
        }else{
            higestBindingBid = min(currentBid, bidsMap[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }

    }

    function cancelAuction() public {
        auctionState = State.Cancelled;
    }

    function finalizeAuction() public {

        //make sure the state of the aution is cancelled or that the auction time has elapsed
        require(State.Cancelled == auctionState || block.number > endBlock);

        //make sure this funtion is accessed by a user that have played the
        //placed the auction or the owner of the smart contract
        require(bidsMap[msg.sender] > 0 || msg.sender == owner);

        uint theValue;
        address payable recipient;

        if(auctionState == State.Cancelled){
            recipient = payable(msg.sender);
            theValue = bidsMap[highestBidder];
        }else{
            //pull out the funds
            if(msg.sender == owner && ownerRewardChance == true){
                recipient = owner;
                theValue = higestBindingBid;

                ownerRewardChance = false;//this will make the owner to only seek reward once

            }else{
                if(msg.sender == highestBidder){
                    recipient = highestBidder;
                    theValue = bidsMap[highestBidder] - higestBindingBid;
                }else{
                    recipient = payable(msg.sender);
                    theValue = bidsMap[msg.sender];
                }
            }
        }
        //reset the value of the of the users bid to 0
        bidsMap[recipient] = 0;
        recipient.transfer(theValue);
    
    }

}