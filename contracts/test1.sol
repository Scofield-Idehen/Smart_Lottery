// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {scofield} from "./test2.sol";

contract storageFactory{
    scofield[] public listofnewscofield;
    
    function createnewContract()public{
        scofield storagefactorySC = new scofield();
        listofnewscofield.push(storagefactorySC);
    }

    function sfstore(uint256 _simpleIndex, uint indexNumber) public {
        listofnewscofield[_simpleIndex].addPerson(indexNumber);
         
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        return listofnewscofield[_simpleStorageIndex].retrievePerson();
    }
    


}