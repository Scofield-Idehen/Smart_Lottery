// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library priceConverter{

    function getPrice() public view returns(uint256){
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = PriceFeed.latestRoundData();
        return uint(price * 1e10);
    }
    function getConversionRate (uint256 _ethamount)public view returns(uint){
        uint GetAmount = getPrice();
        uint AmountInUSD = (GetAmount * _ethamount) / 1e18;
        return AmountInUSD;
    }


}