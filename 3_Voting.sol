// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
abstract contract IVoting {
    function register() public virtual;
    function voteFor(address) public virtual;
    function numberOfVotesReceivedFor(address) view public virtual returns(uint);
    // function winnersAndNumberOfWinningVotes() view public virtual returns(address[] memory, uint);
}
*/

/** 
 * @title Voting
 * @dev Implements voting process along with vote delegation
 */

 contract Voting // is IVoting
 {
    struct Voter 
    {
        uint vote;   // index of the voted candidate
                    // has to be int bc finding the candidate address from candidates[] can return -1 for errorhandling
        bool voted;  // if true, that person already voted
        uint weight; // weight is accumulated by delegation ... @dev could be extendet with vote-delegation
        bool registered;  // if false, that person is not registered
    }

    struct Candidate 
    {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        bytes32 name;   // short name (up to 32 bytes) ... zb 0x1000000000000000000000000000000000000000000000000000000000000000
        uint voteCount; // number of accumulated votes
        address ETHAddress; // Holds a 20 byte value (size of an Ethereum address)
    }

    // address public chairperson;

    mapping(address => Voter) voters;

    Candidate[] candidates;

    constructor(bytes32[] memory _candidateNames, address[] memory _candidateAdress)
    {
        for(uint i = 0; i < _candidateNames.length; i++)
        {
            // require(candidateAdress[i] != null, "Candiate has no address.");

            candidates.push(Candidate({
                    name: _candidateNames[i],
                    voteCount: 0,
                    ETHAddress: _candidateAdress[i]
                }));
        }
    }

    function register() public // override
    {
        // not implemented
        voters[msg.sender].weight = 1;
        voters[msg.sender].voted = false;
        voters[msg.sender].registered = true;
    }

    function voteFor(address _address) public // override
    {
        // Voter storage sender = voters[msg.sender];
        require(voters[msg.sender].registered, "Person has not registered as voter yet.");
        require(!voters[msg.sender].voted, "Person already voted.");

        uint candidate = findCandidate(_address);
        // require(candidate == 0, "Candidate's adress does not exist.");
        
        voters[msg.sender].vote = candidate;

        candidates[candidate].voteCount += voters[msg.sender].weight;
        voters[msg.sender].voted = true;
    }


    function findCandidate(address _address) view private
            returns(uint)
    {
        for(uint i = 0; i < candidates.length; i++)
        {
            if(candidates[i].ETHAddress == _address){
                return i;
            }
        }

        //return 0;
    }

    /*
    @error: function not callable ... ???
    */
    function numberOfVotesReceivedFor(address _address) public view returns(uint) 
    {
        uint candidate = findCandidate(_address);
        return candidates[candidate].voteCount;
    }

/*
    // Keine Ahnung was die requ fuer die func sind!
    
    function winnersAndNumberOfWinningVotes() view public virtual returns(address[] memory, uint) 
    {
        address[] memory winners;
        uint votes;
        return(winners, votes);
    }
*/
 }
