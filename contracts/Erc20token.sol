//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;
// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------
 
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract MyToken is ERC20Interface{
    string public name = "ZILLAX";
    string public symbol = "ZLZ";
    uint public decimals = 0;

    address public founder;

    uint public override totalSupply;

    mapping(address => uint) public  balances;

    mapping(address => mapping(address => uint)) public allowed;

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint balance){
        return balances[tokenOwner];
    }

    //override the transfer function in the 
    function transfer(address to, uint tokens) public virtual override returns (bool success){
        require(balances[msg.sender] >= tokens, "Insufficient Account Balance");

        balances[to] += tokens;
        balances[msg.sender] -= tokens;

        emit Transfer(msg.sender, to, tokens);

        return true;
    }
//0xC93cfE88Bb3530f845Ed289C70D428bd32D7E97C
//0xCF9649973e242835724940986140c291A9D51a92
    function allowance(address tokenOwner, address spender) public override view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success){

        require(balances[msg.sender] >= tokens, "Token value is greater than your current holding");
        require(tokens > 0, "Token value must be greater than 0");
        
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
        require(allowed[from][msg.sender] >= tokens, "Token value is greater than the approved balance");
        require(balances[from] >= tokens, "Insuficient Balnce");
        require(tokens > 0, "Token value must be greater than 0");

        allowed[from][msg.sender] -= tokens;//remove the amount of token from the allowed balance
        balances[from] -= tokens;//remove the amount of token from the owner balance
        balances[to] += tokens;

        emit Transfer(from, to, tokens);

        return true;
    }

}

contract icoContract is MyToken{

    address public admin;

    //token price against ethereum 
    //1000zllz = 1 ether
    //1zllz = ?
    uint tokenPrice = 0.001 ether;

    //variable that holds the contributed amount
    uint public raisedAmount;

    //the maximum amount that needs to be raised
    uint public hardCap = 5 ether;

    //define the stages for the ico
    enum State {beforeStart, Running, Ended, AfterEnd, Halted}

    //start time for the ico
    uint public startTime = block.timestamp;
    uint public endTime;

    //declare the minimum and maximum amoount
    uint public minimumAmount = 0.1 ether;
    uint public maximumAmount = 1 ether;

    //this holds the current ico state
    State public icoState;

    //the deposit address
    address payable public depositAddress;
//0xF672d31f021374A2738A59288a743729a140D3Be
    //event fo the investment
    event Invest(address _sender, uint _amount, uint _tokens);

    constructor(uint _duration, address payable _depositAddress){
        icoState = State.beforeStart;

        //state the owner
        admin = msg.sender;

        //initialize endTime
        endTime = startTime + _duration;

        //add the deposit address
        depositAddress = _depositAddress;

    }

    //declare a modifier for the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Access denied, you ae not an admin");
        _;
    }

        // emergency stop
    function halt() public onlyAdmin{
        icoState = State.Halted;
    }
    
    
    function resume() public onlyAdmin{
        icoState = State.Running;
    }
    
    
    function changeMaximumAmount(uint _minimumAmount) public onlyAdmin{
        minimumAmount = _minimumAmount;
    }
    
    function changeMinimumAmount(uint _maximumAmount) public onlyAdmin{
        maximumAmount = _maximumAmount;
    }

    function changeEndTime(uint _duration) public onlyAdmin{
        endTime = startTime + _duration;
    }
    
    
    function changeDepositAddress(address payable newDepositAddress) public onlyAdmin{
        depositAddress = newDepositAddress;
    }

    function checkIcoState() public view returns(State){
        State currentState;
        if(icoState == State.Halted){
            currentState = State.Halted;
        }else if(block.timestamp < startTime){
            currentState = State.beforeStart;
        }else if(block.timestamp >= startTime && block.timestamp < endTime){
            currentState = State.Running;
        }else{
            currentState = State.AfterEnd;
        }
        return currentState;
    }

    function returnRaisedAmount() public view returns(uint){
        return raisedAmount;
    }

    //declare a function for investment
    function invest() payable public returns(bool){

        //check the state of the ico
        icoState = checkIcoState();
        require(icoState == State.Running, "Amount must be greater than zero");

        //make the deposited amount is greater than 0
        //require(msg.value > 0, "Amount must be greater than zero");

        //validate the amount
        string memory s1 = string(abi.encodePacked("Amount cannot not be lower than", minimumAmount));
        string memory s2 = string(abi.encodePacked("Amount cannot not be higgher than", maximumAmount));
        string memory s3 = string(abi.encodePacked(s1, s2));
        require(msg.value >= minimumAmount && msg.value <= maximumAmount, s3);

        uint amount = raisedAmount + msg.value;
        require(amount <= hardCap, "The maximum amount to be raised has been reached");

        raisedAmount += msg.value;

        //do the conversion and get the tokens; 
        //1 zllz = 0.001 ether, 
        //? = 20 zllz
        uint tokens = msg.value / tokenPrice;

        //do teh payment stuff;
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;

        //send the money to the deposit address
        depositAddress.transfer(msg.value);

        emit Invest(msg.sender, msg.value, tokens);

        return true;

    }

    receive() external payable {
        invest();
    }

    function transfer(address to, uint tokens) public override returns (bool success){
        require(block.timestamp > endTime, "Token sales is not yet finished");
        super.transfer(to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(block.timestamp > endTime, "Token sales is not yet finished");
        super.transferFrom(from, to, tokens);
        return true;
    }

    function burnTokens() public {
        icoState = checkIcoState();
        require(icoState == State.AfterEnd, "Token sales is not yet finished");
        require(balances[founder] > 0, "No token available for burning");
        balances[founder] = 0;
    }
    function getSymbol() public view returns(string memory){
        return symbol;
    }

}