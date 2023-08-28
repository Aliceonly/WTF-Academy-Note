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

contract PairFactory2{
        mapping(address => mapping(address => address)) public tokenPairs; // 通过两个代币地址查Pair地址
        address[] public allPairs;


        function createPair(address _tokenA, address _tokenB) external returns(address pairAddr){
            require(_tokenA != _tokenB, 'IDENTICAL_ADDRESSES');
            (address _token0, address _token1) = _tokenA < _tokenB ? (_tokenA,_tokenB) : (_tokenB,_tokenA);
            bytes32 salt = keccak256(abi.encodePacked(_token0,_token1));
            Pair pair = new Pair{salt : salt}();
            pair.init(_tokenA, _tokenB);
            pairAddr = address(pair);
            allPairs.push(pairAddr);
            tokenPairs[_tokenA][_tokenB] = pairAddr;
            tokenPairs[_tokenB][_tokenA] = pairAddr;
        }

        function calcAddress(address _tokenA, address _tokenB) public view returns(address preAddr){
            require(_tokenA != _tokenB, 'IDENTICAL_ADDRESSES');
            (address _token0, address _token1) = _tokenA < _tokenB ? (_tokenA,_tokenB) : (_tokenB,_tokenA);
            bytes32 salt = keccak256(abi.encodePacked(_token0,_token1));
            preAddr = address(uint160(uint(keccak256(abi.encodePacked(bytes1(0xFF),address(this),salt,keccak256(type(Pair).creationCode))))));
        }
}