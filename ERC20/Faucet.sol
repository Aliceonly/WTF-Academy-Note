// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;

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

contract Faucet {
    uint public onceAllowed = 100;
    address public tokenContract;
    mapping(address => bool) public usedAddrs;

    event SendToken(address indexed receiver, uint indexed amount);

    constructor(address _tokenContract){
        tokenContract = _tokenContract;
    }

    function requestToken() external{
        require(!usedAddrs[msg.sender], "Can't Request Multiple Times!");
        IERC20 token = ERC20(tokenContract);
        require(token.balanceOf(address(this)) >= onceAllowed,"Faucet Empty!");
        token.transfer(msg.sender, onceAllowed);
        usedAddrs[msg.sender] = true;
        emit SendToken(msg.sender, onceAllowed);
    }
}