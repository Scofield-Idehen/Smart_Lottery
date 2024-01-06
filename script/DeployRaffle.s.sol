//SPDX-Licenses-identifier: MIT
pragma solidity ^0.8.18;


import {Script} from "forge-std/Script.sol";
import {raffleTicket} from "../src/Raffle.sol";
import {HelperConfig} from "./Helperconfig.s.sol";


contract DeployRaffle is Script{

    function run() external returns (raffleTicket, HelperConfig){

        HelperConfig configHelper = new HelperConfig();
        (
        uint ticketPrice,
        uint interval,
        address vfrCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackgas
        ) = configHelper.activeNetworkConfig();

        vm.startBroadcast();
        raffleTicket raffleticket = new raffleTicket(
            ticketPrice,
            interval,
            vfrCoordinator,
            gasLane,
            subscriptionId,
            callbackgas
        );
        vm.stopBroadcast();
        return (raffleticket, configHelper);


    }
}