//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script{
    struct NetworkConfig{
        uint ticketPrice;
        uint interval;
        address vfrCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackgas;
    }

    NetworkConfig public activeNetworkConfig;


    constructor(){
        if (block.chainid == 11155111){
            activeNetworkConfig = getSapoliaETH();
        } else{
             activeNetworkConfig  = getAnvileETh();
        }
    }

    function getSapoliaETH() public view returns(NetworkConfig memory){
        return 
            NetworkConfig({
            ticketPrice: 0.01 ether,
            interval: 30, 
            vfrCoordinator: address(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625), // i casted mine to show it is address
            gasLane: bytes32(0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c), // to show it is 32bytes
            subscriptionId: 0, //we will update this with ours soon // Remember to look at this again 
            callbackgas: 500000
        });
    }

    function getAnvileETh() public returns (NetworkConfig memory){
        if(activeNetworkConfig.vfrCoordinator != address(0)){
            return activeNetworkConfig;
        }

        uint96 baseFee = 0.25 ether;
        uint96 gasPriceLink = 1e9;

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        vm.stopBroadcast(); 

        return 
            NetworkConfig({
                ticketPrice: 0.01 ether,
                interval: 30, 
                vfrCoordinator: address(vrfCoordinatorMock), // i casted mine to show it is address
                gasLane: bytes32(0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c), // to show it is 32bytes
                subscriptionId: 0, //we will update this with ours soon // Remember to look at this again 
                callbackgas: 500000
        });      

        

    }
}

