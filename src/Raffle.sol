//SPDX-License-Identifier:MIT

pragma solidity ^0.8.13;


import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract Raffle{

error Raffle__NotEnoughEthSent();

  uint16 private constant REQUEST_CONFIRMATIONS=3;
  uint32 private constant NUMS_WORDS=1;

    

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gaslane;
    uint32 private immutable i_callbackGasLimit;

    uint256 private s_lastTimestamp;
    address payable[] private s_players;
    
   event EnteredRaffle(address indexed player);


    constructor (uint256 entranceFee,uint256 interval , address vrfCoordinator, bytes32 gaslane,uint64 subscriptionId , uint32 callbackGasLimit){
        i_interval = interval;
        i_entranceFee = entranceFee;
        i_vrfCoordinator= VRFCoordinatorV2Interface(vrfCoordinator);
        s_lastTimestamp= block.timestamp;
        i_gaslane= gaslane;
        i_subscriptionId= subscriptionId;
        i_callbackGasLimit= callbackGasLimit;

    }

    function  enterRaffle() external payable {

        if(msg.value<i_entranceFee){
            revert Raffle__NotEnoughEthSent(); 
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);

    }

    


    function PickAWinner()public{
     if(block.timestamp-s_lastTimestamp<i_interval){
        revert();
       
     }

      uint256 requestId= i_vrfCoordinator.requestRandomWords(
            i_gaslane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUMS_WORDS
        );

    }

    function getEntranceFee() public view returns(uint256){
       return i_entranceFee;
    }

}