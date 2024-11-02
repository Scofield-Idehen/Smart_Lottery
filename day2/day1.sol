// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;


contract scofield {

    uint256 Favourite_person;


    struct NewPerson{
        string name;
        uint favouritePerson;
    }
    //we mapped to either string or uint
    mapping(string => uint256) public mapFavouriteNumber;
    mapping(uint256 => string) public mapFavouriteNumber2;

    //dynamic array to store value
    NewPerson[] public listofPerson;

    function addPerson(uint _favouritePerson)public{
        Favourite_person = _favouritePerson;
    }
    //pure and view 
    function retrievePerson()public view returns(uint256){
        return Favourite_person;
    }

    //calldata temporary can not change 
    // memory(temporary but can chnage) 
    //storage permanent but can change
    function addNewPerson(string memory _name, uint _favouritePerson)public{
        listofPerson.push(NewPerson(_name, _favouritePerson));
        mapFavouriteNumber[_name] = _favouritePerson;
        mapFavouriteNumber2[_favouritePerson] = _name;
    }


}
