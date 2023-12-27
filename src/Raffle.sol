//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title Raffle
 * @dev Implements raffle draw
 * @author Scofield Idehen
 * @notice You can use this contract for raffle draws and other related activities.
 */


contract raffleTicket{
    uint private immutable i_ticketPrice;

    constructor(uint ticketPrice){
        i_ticketPrice = ticketPrice;
    }

    function enterdrew() external payable {
        require(msg.value >= i_ticketPrice, "Raffle: Insufficient amount");

    }

    function withdrew() public { 

    }


    /** Get entrance fee before entering */

}