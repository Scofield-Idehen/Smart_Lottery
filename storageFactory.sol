// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {priceConverter} from './priceConverter.sol';




contract fundMe{
    using priceConverter for uint;

    uint public myValue = 5e18; 
    address[] public funders;
    mapping (address funder => uint256 funded) public fundingOf;

    function fund()public payable{
        require (msg.value.getConversionRate() > myValue, "Not enough fund");
        funders.push(msg.sender);
        fundingOf[msg.sender] = fundingOf[msg.sender] + msg.value;
    }

    
    



    //function withdraw()public {}


}

