//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title Raffle
 * @dev Implements raffle draw
 * @author Scofield Idehen
 * @notice You can use this contract for raffle draws and other related activities.
 */

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";


contract raffleTicket{


    //state variables

    // @dev ticketPrice is the price of the ticket and must be called 
    uint private immutable i_ticketPrice;

    //error
    error Raffle__InsufficientETH();
    error Raffle__TrasferedFailed();
    error Raffle__NotOpenRaffle();


    /** enum */

    eum RaffleState {
        OPEN,
        CALCULATING
    }



    //@dev interval is the time interval for the raffle draw
    //if set to 700 if the timestamp is 1200 - 500 = enough time has passed 
    uint private immutable i_interval;
    //we use the s_ beacuse there are stored in the storage
    address[] private s_participants;
    //the time stamp to be used for the raffle draw
    uint private s_timestamp;

    /**working with chainlink vrf */
    //this address is crucial for interacting with the Chainlink VRF service, which provides 
    //secure and verifiable random numbers on the blockchain.
    // private immutable i_vfrCordinator;

    VRFCoordinatorV2Interface private immutable i_vfrCordinator;

    //this is the key used to identify the randomness request
    bytes32 private immutable i_gaslane;
    //this is the subscription id
    uint64 private immutable i_subscriptionId;
    //this is the variable used to store the random number
    uint16 private constant REQUEST_VARABLE = 3;
    //this is the amount of gas to be used for the callback function
    uint32 private immutable i_callbackgas;
    //this is the number of words to be generated
    uint32 private constant NUM_WORD = 1; 
    address private s_winner;
    RaffleState private s_rafflestate;



    //events

    event RafflesEntered(address indexed player);
    event Pickedwinner(address indexed winner);

    //constructor
    constructor(uint ticketPrice, uint interval, address vfrCordinator, bytes32 gasLane, uint64 subscriptionId, uint32 callbackgas){
        i_ticketPrice = ticketPrice;
        i_interval = interval;
        s_timestamp = block.timestamp;
        // we typecast the address to the VRFCoordinatorV2Interface
        //the i_vfrCordinator is the address of the VRFCoordinatorV2Interface
        i_vfrCordinator = VRFCoordinatorV2Interface(vfrCordinator);
        i_gaslane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackgas = callbackgas;
        s_rafflestate = RaffleState.OPEN;

    }

    function enterdrew() external payable {
        // we stop using require because it will consume all the gas
        //require(msg.value >= i_ticketPrice, "Raffle: Insufficient amount");
        if (msg.value < i_ticketPrice) { // this saves gas
            revert Raffle__InsufficientETH();
        }
        if(s_rafflestate != RaffleState.OPEN){
            revert Raffle__NotOpenRaffle;
        }
        s_participants.push(payable(msg.sender));

        //this emit the sender address
        emit RafflesEntered(msg.sender);

    }
    //make it random
    //
    function pickwinner() external {
        //This code checks if the difference between the current block's timestamp and a stored timestamp 
        //(s_timestamp) is less than a specified interval (i_interval).
        if((block.timestamp - s_timestamp) < i_interval){
            revert();
        }
        // 
        s_rafflestate = RaffleState.CALCULATING;
        //this is the code that will be used to generate the random number
        //it was copied from the chainlink documentation
        //it has been modified to suit our purpose
        // forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
        uint256 requestId = i_vfrCordinator.requestRandomWords(
            i_gaslane, // this is the key used to identify the randomness request
            i_subscriptionId, // this is the subscription id
            REQUEST_VARABLE, // this is the variable used to store the random number
            i_callbackgas, // this is the amount of gas to be used for the callback function
            NUM_WORD // this is the number of words to be generated

        );

    }

    function fullfillRandom(
        uint256 requestId,
        uint256[] memory randomWords 
    ) internal override {
        //this is the code that will be used to generate the random winner
        //we use the randomWords[0] because we are generating only one word
        uint indexWinner = randomWords[0] % s_participants.length;
        // the winner is the s_participants[indexWinner]
        address winner = s_participants[indexWinner];
        s_winner = winner;
        s_rafflestate = RaffleState.OPEN
        s_participants = new address payable[](0)
        s_timestamp = block.timestamp;
        emit Pickedwinner(winner);
        // we use the call function to send the money to the winner
        (bool success, ) = winner.call{value: address(this).balance}("");
        if(!success){
            //we use the revert function to send the money back to the contract
            revert Raffle__TrasferedFailed();
        }
       
    }


    /** Get entrance fee before entering */

}