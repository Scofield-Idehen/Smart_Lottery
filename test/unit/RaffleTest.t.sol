//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {raffleTicket} from "../../src/Raffle.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/Helperconfig.s.sol";


contract raffleTest is Test{

    /* Events */
    event RafflesEntered(address indexed PLAYER);

    raffleTicket raffleticket;
    HelperConfig configHelper;

        uint ticketPrice;
        uint interval;
        address vfrCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackgas;


    address public PLAYER = makeAddr("player");
    uint256 public constant  STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();  
        (raffleticket, configHelper) = deployer.run();
        (ticketPrice, interval, vfrCoordinator, gasLane, subscriptionId, callbackgas) = configHelper.activeNetworkConfig();
        vm.deal(PLAYER, STARTING_USER_BALANCE);
    }

    function testraffleisopenState() public view {
        assert(raffleticket.raffleState() == raffleTicket.RaffleState.OPEN);

    }
    ///////////////////
    // EnterRaffle   //
    ///////////////////

    function testRevertwhenNotEnoughETH() public {
        //Arrange
        vm.prank(PLAYER);
        //Act
        vm.expectRevert(raffleTicket.Raffle__InsufficientETH.selector);
        raffleticket.enterdrew();
    }

    function testRafflerecordsnewentry() public {
        vm.prank(PLAYER);
        raffleticket.enterdrew{value: ticketPrice}();
        address playerRecorded = raffleticket.getplayers(0);
        assert(playerRecorded == PLAYER);


    }

    function testEmitsEvents() public {
        vm.prank(PLAYER);
        vm.expectEmit(true, true, false, false, address(raffleticket));
        emit RafflesEntered(PLAYER);
        raffleticket.enterdrew{value: ticketPrice}();
        
    }

    function testenterwhencalculating() public {
        vm.prank(PLAYER);
        raffleticket.enterdrew{value: ticketPrice}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1 );
        raffleticket.performUpkeep("");

        vm.expectRevert(raffleTicket.Raffle__NotOpenRaffle.selector);
        vm.prank(PLAYER);
        raffleticket.enterdrew{value: ticketPrice}();
    }
}
