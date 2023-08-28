// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Fallback {
    event ReceiveCalled(address sender, uint value);
    event FallbackCalled(address sender, uint value, bytes data);

    receive() external payable {
        emit ReceiveCalled(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }
}