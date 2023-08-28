// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract C {
    uint public num;
    address public sender;

    function setX(uint _x) external payable {
        num = _x;
        sender = msg.sender;
    }
}

contract B {
    uint public num;
    address public sender;

    event Log(bool success, bytes msg);

    function CallSetX(address _Addr, uint _x) external payable {
        (bool success, bytes memory data) = _Addr.call(abi.encodeWithSignature("setX(uint256)", _x));
        emit Log(success,data);
    }

    function delegateCallSetX(address _Addr, uint _x) external payable {
        (bool success, bytes memory data) = _Addr.delegatecall(abi.encodeWithSignature("setX(uint256)", _x));
        emit Log(success,data);
    }
}