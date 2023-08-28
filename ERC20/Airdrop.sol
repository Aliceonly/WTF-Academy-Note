// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;

import "./IERC20.sol"; //import IERC20

import "./IERC20.sol";

contract ERC20 is IERC20{
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;
    string public symbol;

    uint8 public decimals = 18;

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    function transfer(address _to, uint256 _amount) external override returns(bool){
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) external returns (bool){
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external returns (bool){
        allowance[_from][msg.sender] -= _amount;
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function mint(uint _amount) external{
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    function burn(uint _amount) external{
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }
}

/// @notice 向多个地址转账ERC20代币
contract Airdrop {
    function getSum(uint256[] calldata _arr) internal pure returns(uint256 sum){
        for (uint i = 0; i < _arr.length; i++) {
            sum += _arr[i];
        }
    }

    function SendAirDrop(address _tokenAddr, address[] calldata _receivers, uint256[] calldata _amounts) external {
        require(_receivers.length == _amounts.length,"Lengths of Addresses and Amounts NOT EQUAL");
        IERC20 token = ERC20(_tokenAddr);
        uint _amountSum = getSum(_amounts);
        require(_amountSum <= token.allowance(msg.sender, address(this)),"Need Approve ERC20 token");
        for (uint i = 0; i < _receivers.length; i++) {
            token.transferFrom(msg.sender, _receivers[i], _amounts[i]);
        }
    }
}