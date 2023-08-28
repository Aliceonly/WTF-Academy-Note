// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    event Log(uint amount, uint gas);

    uint private _x = 0;

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

    function setX(uint256 x) external payable{
        _x = x;
        if(msg.value > 0){
            emit Log(msg.value,gasleft());
        }
    }

    function getX() external view returns(uint x){
        x = _x;
    }
}

contract CallContract{

    event Response(bool success, bytes msg);

    function callSetX(address payable _Address, uint256 x) external payable {
        (bool success,bytes memory data) = _Address.call{value:msg.value}(abi.encodeWithSignature("setX(uint256)", x));
        emit Response(success, data);
    }

    function callGetX(address _Address) external returns(uint){
        (bool success, bytes memory data) = _Address.call(abi.encodeWithSignature("getX()"));
        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

}