// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

struct Instructor {
    string name;
    uint age;
    address addr;
}

contract Academy{

    Instructor public academyInstructor;

    enum State {Open, Closed, Unknown}

    //create a variable of state type
    State public academtState = State.Open;

    constructor(uint _age, string memory _name){

        academyInstructor.age = _age;
        academyInstructor.name = _name;
        academyInstructor.addr = msg.sender;

    }

    function changeIntructor(uint _age, string memory _name, address _addr) public {
        if(academtState == State.Open){
            //declare a new variable of intructor type
            Instructor memory newIntructor = Instructor({
                age:_age,
                name:_name,
                addr:_addr
            });
            academyInstructor = newIntructor;
        }
        
    }

}

contract school{
    Instructor public schoolInstructor;
}