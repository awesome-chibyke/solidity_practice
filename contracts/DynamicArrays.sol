// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract DynamicArrays{

    uint[] public numbers;

    function addNumbers(uint number) public {
        numbers.push(number);
    }

    function popNumber() public {
        numbers.pop();
    }

    function getArrayLength() public view returns(uint){
        return numbers.length;
    }

    // returning an element at an index
    function getElement(uint i) public view returns(uint){
        if(i < numbers.length){
            return numbers[i];
        }
        return 0;
    }

    //createion of memory array
    function createMemArray() public {

        uint[] memory _numbers = new uint[](3);
        _numbers[0] = 10;
        _numbers[1] = 5;
        _numbers[2] = 8;
        _numbers[3] = 0;

        numbers = _numbers;

    }

}