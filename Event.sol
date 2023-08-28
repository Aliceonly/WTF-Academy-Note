pragma solidity ^0.8.0;

contract Event {
    mapping(address => uint) public balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function _transfer(address _from, address _to, uint256 _amount) external {
        balances[_from] = 10000000000000000000;

        balances[_from] -= _amount;

        balances[_to] += _amount;

        emit Transfer(_from, _to, _amount);
    }
}
