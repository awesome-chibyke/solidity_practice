// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract FixedSizeArrays{

    //ixed size array
    uint[4] public numbers;

    //special byte arrays
    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    bytes4 public b4;

    function setArrayElement(uint index, uint number) public {
        numbers[index] = number;
    }

    function getArrayLength() public view returns(uint){
        return numbers.length;
    }

    function setByteArray() public {
        b1 = 'a';
        b2 = 'ab';
        b3 = 'abc';
        b4 = 'abcd';
    }

}