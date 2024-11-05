// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {priceConverter} from './priceConverter.sol';


error dontaskme;

contract fundMe{
    using priceConverter for uint;

    uint public myValue = 5e18; 
    address[] public funders;
    mapping (address funder => uint256 funded) public fundingOf;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund()public payable{
        require (msg.value.getConversionRate() > myValue, "Not enough fund");
        funders.push(msg.sender);
        fundingOf[msg.sender] += msg.value;
    }



    function withdraw()public onlyowner{
        for(uint funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        fundingOf[funder] = 0;
        }
        funders = new address[](0);
        //payable(msg.sender).transfer(address(this).balance);

        //bool sendsuccess = payable(msg.sender).send(address(this).balance);
       // require(sendsuccess, "send failes");

        (bool callsuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess, "send failes");
        

         
    }

    modifier onlyowner(){
        require(msg.sender == owner, "must be owner");
        _;
    }

    receive() external payable {
        withdraw();
    }

    fallback() external payable{
        withdraw();
    }


}

