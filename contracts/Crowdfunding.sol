//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{

    //details of the contributor and amount contributed
    mapping(address => uint) public contributors;
    //address of the admin
    address public admin;
    //goal that will be reached, before a particular funding project comes to a close
    uint public goal;
    //the time frame for the contribution
    uint public deadLine;
    //minimum amount to transfered by a contributor
    uint public minimumAmount;
    //total amount currently transfered
    uint public totalAmount;
    //number of contributors
    uint public numberOfContributors;

    //events to be emitted by the contract
    event ContributeEvent(address _contributor, uint amount, uint _totalAmountContributed);
    event RequestEvent(uint _amount, address receiver, string _description);
    event MakePaymentEvent(uint _amount, address receiver);

    struct Request {
        string description;
        uint amount;
        address payable receiver;
        uint createdAt;
        uint noOfVoters;
        bool fundReleaseStatus;
        mapping(address => bool) votingDetails;
    }

    uint public noOfRequests;
    mapping(uint => Request) public request;

    constructor(uint _goal, uint _deadLine){
        goal = _goal;
        deadLine = block.timestamp + _deadLine;
        admin = msg.sender;
        minimumAmount = 1 ether;
    }

    function contribute() public payable{
        //check to make sure user is sending the an amount above the minimum amount
        require(msg.value >= minimumAmount, "Amount must be greater than the minimum amount");
        //check if the goal have not been reached
        require(totalAmount < goal, "Goal for funding has been reached");
        //check for the timestamp
        require(block.timestamp < deadLine, "Time frame set for funding has elasped");
        
        if(contributors[msg.sender] == 0){
            numberOfContributors++;
        }

        //add the user to the contributor mapping
        contributors[msg.sender] += msg.value;

        //add the amount to the total amount for the funding
        totalAmount += msg.value;

    }

    receive() external payable {
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public  {
        require(contributors[msg.sender] > 0, "You are not an existing contributor");

        //has the time for the ndng passed and goal is not yet reached
        require(block.timestamp >= deadLine && totalAmount < goal, "Funding time frame is yet to expire");

        //pay the user
        payable(msg.sender).transfer(contributors[msg.sender]);

        contributors[msg.sender] = 0;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function createRequest(string memory _description, uint _amount, address payable receiptient) public onlyAdmin {
        Request storage _requestDetails = request[noOfRequests];
        _requestDetails.description = _description;
        _requestDetails.amount = _amount; 
        _requestDetails.fundReleaseStatus = false;
        _requestDetails.receiver = receiptient;

        noOfRequests++;
    }

    function vote(uint _requestIndex) public {

        //the voter must hae contributed to the funding
        require(contributors[msg.sender] > 0, "You must be a contributor to be able to vote");

        Request storage requestObject = request[_requestIndex];

        //make sure a voter cant vote twice
        require(requestObject.votingDetails[msg.sender] == false);

        requestObject.votingDetails[msg.sender] = true;//cast the vote
        requestObject.noOfVoters++;//increment the number of people that have voted

    }

    function makePayment(uint _requestIndex) public payable onlyAdmin {

        Request storage requestObject = request[_requestIndex];

        require(requestObject.noOfVoters > numberOfContributors/2);//check if more than 5 voters have voted

        //check if the unds have been released before
        require(requestObject.fundReleaseStatus == false);

        //release the funds
        requestObject.receiver.transfer(requestObject.amount);

    }

}