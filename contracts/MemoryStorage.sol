// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract MemoryStorage{

    uint[] public numbers = [10, 20, 30];

    function memoryChange() public view {
        uint[] memory _numbers = numbers;

        //change a value in the array
        _numbers[1] = 50;
    }

    function storageChange() public {
        //when a function variable or local 
        //variable is set to storage and initialized with a value from
        //the state variable it automatically changeg the state variable 
        uint[] storage _numbers = numbers;

        //change a value in the array
        _numbers[1] = 50;
    }

}