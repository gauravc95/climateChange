pragma solidity >=0.5.0;
import "./nftContract.sol";

contract ClimComm {

    struct communityEvent {
        string name;
        string eventDetails;
        string eventWebsite;
        string ipfsPhotos;
        address[] participants;
    }

    uint eventId = 1;
    mapping(uint => communityEvent) public communityEvents;
    mapping(uint => address[]) public eventOwners;

  function createEvent(string memory name,
                        string memory eventDetails,
                        string memory eventWebsite,
                        string memory ipfsPhotos) external returns(uint){

        address[] memory participants;
        communityEvent memory ce = communityEvent({name:name, eventDetails:eventDetails, 
                                eventWebsite:eventWebsite, ipfsPhotos:ipfsPhotos,participants:participants});

        communityEvents[eventId] = ce;
        eventOwners[eventId].push(msg.sender);
        eventId = eventId + 1; 
        return eventId - 1;            
  }
  
  function getEvent(uint id) public view returns(string memory,
                        string memory,
                        string memory,
                        string memory){

      return (communityEvents[id].name,
      communityEvents[id].eventDetails,
      communityEvents[id].eventWebsite,
      communityEvents[id].ipfsPhotos);
  }
  function addOwnerToEvent(uint id,address newOwner)external returns(uint){
    eventOwners[id].push(newOwner);
  }

  function addParticipantsToEvent(uint id,address participant)external returns(uint){
    communityEvents[id].participants.push(participant);
  }

    function substring(string memory str, uint startIndex, uint endIndex) external returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

  function endEvent(uint id) external returns(uint){
        newNFT nft = new newNFT(communityEvents[id].name,this.substring(communityEvents[id].name,0,2));
        for (uint i = 0; i < communityEvents[id].participants.length;i++){
            nft.mint(communityEvents[id].participants[i],1,communityEvents[id].ipfsPhotos);
        }
  }
}
