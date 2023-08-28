// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Pair{
    address public factory;
    address public token0;
    address public token1;

    constructor() payable{
        factory = msg.sender;
    }

    function init(address _token0, address _token1) external {
        require(msg.sender == factory,"invaid factory");
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory{
    mapping(address => mapping(address => address)) tokenPairs;
    address[] public allPairs;

    function createPair(address _tokenA, address _tokenB) external returns(address pairAddr){
        Pair pair = new Pair();
        pair.init(_tokenA, _tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        tokenPairs[_tokenA][_tokenB] = pairAddr;
        tokenPairs[_tokenB][_tokenA] = pairAddr;
    }
}