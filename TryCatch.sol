// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OnlyEven{
    constructor(uint x){
        require(x != 0);
        assert(x != 1);
    }

    function onlyEven(uint num) external pure returns(bool success) {
        require(num % 2 == 0);
        return true;
    }
}

contract TryCatch{
    event SuccessEvent();
    event ErrorEvent(string msg);
    event BytesEvent(bytes data);

    // OnlyEven even = new OnlyEven(2);

    function exec(uint num) external returns(bool success){
        try new OnlyEven(num) returns(OnlyEven _even){
            emit SuccessEvent();
            success = _even.onlyEven(num);
        } catch Error(string memory res){
            emit ErrorEvent(res);
        } catch(bytes memory res){
            emit BytesEvent(res);
        }
    }
}