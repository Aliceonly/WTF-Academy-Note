// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

error SendError();
error CallError();

contract SendETH {
    constructor() payable {}

    function transferETH(address payable _to, uint256 amount) external payable{
        _to.transfer(amount);
    }

    function sendETH(address payable _to, uint256 amount) external payable{
        bool success = _to.send(amount);
        if(!success){
            revert SendError();
        }
    }

    function callETH(address payable _to, uint256 amount) external payable{
        (bool success,) = _to.call{value : amount}("");
        if(!success){
            revert CallError();
        }
    }
}

contract ReceiveETH{
    event Log(uint amount, uint gas);

    receive() external payable {
        emit Log(msg.value,gasleft());
    }

    function getBalance() view public returns(uint){
        return address(this).balance;
    }
}