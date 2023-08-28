// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    event Log(uint amount, uint gas);

    uint private _x = 0;

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

    function setX(uint x) external payable{
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
    function callSetX(address _Address, uint x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns(uint x){
        x = _Address.getX();
    }

    function transferSetX(address _Address,uint x) payable external{
        OtherContract oc = OtherContract(_Address);
        oc.setX{value:msg.value}(x);
    }
}