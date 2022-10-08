//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract TodoList{

    uint public TodoListNumber;
    uint public controlNum = 1;

    struct TaskDetails {
        uint id;
        string details;
        bool status;
    }

    mapping(uint => TaskDetails) public Task_Details;

    function createToDo(string memory _details) public {
        //require(_details != '', "details is required");

        TaskDetails storage newTaskDetails = Task_Details[TodoListNumber];

        TodoListNumber++;

        newTaskDetails.id = TodoListNumber;
        newTaskDetails.details = _details;
        newTaskDetails.status = false;

    }

    function returnAllList() public view returns(uint[] memory, string[] memory, bool[] memory){

        uint[] memory idArray = new uint[](TodoListNumber);
        string[] memory detailsArray = new string[](TodoListNumber);
        bool[] memory statusArray = new bool[](TodoListNumber);

        for (uint i = 0; i < TodoListNumber; i++) {
            idArray[i] = Task_Details[i].id;
            detailsArray[i] = Task_Details[i].details;
            statusArray[i] = Task_Details[i].status;
        }

        return (idArray, detailsArray, statusArray);

    }

}