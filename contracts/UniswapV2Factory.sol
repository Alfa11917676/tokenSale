pragma solidity ^0.8.7;

import '../interfaces/IUniswapV2Factory.sol';

contract UniswapV2Factory {
    IUniswapV2Factory private v2Factory;

constructor () {
   v2Factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
}
    function pairsCreate (address token1, address token2) public returns(address) {
        (address pairAddress) = v2Factory.createPair(token1, token2);
        return pairAddress;
    }
}