//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title Raffle
 * @dev Implements raffle draw
 * @author Scofield Idehen
 * @notice You can use this contract for raffle draws and other related activities.
 */


contract raffleTicket{


    //state variables
    uint private immutable i_ticketPrice;
    error Raffle__InsufficientETH();
    //we use the s_ beacuse there are stored in the storage
    address[] private s_participants;

    //events

    event RafflesEntered(address indexed player);

    //constructor
    constructor(uint ticketPrice){
        i_ticketPrice = ticketPrice;
    }

    function enterdrew() external payable {
        //We stop using Require because it consumes all the gas
        //require(msg.value >= i_ticketPrice, "Raffle: Insufficient amount");
        if (msg.value < i_ticketPrice) { // this saves gas
            revert Raffle__InsufficientETH();
        }
        s_participants.push(payable(msg.sender));
        emit RafflesEntered(msg.sender);

    }
    //make it random
    //
    function pickwinner() public { 

    }


    /** Get entrance fee before entering */

}
