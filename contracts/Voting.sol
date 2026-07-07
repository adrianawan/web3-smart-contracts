// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;

    mapping(address => bool) public hasVoted;
    bool public electionActive;

    constructor(address initialOwner)
        Ownable(initialOwner)
    {}

    function addCandidate(string memory name)
    public
    onlyOwner
        {
            candidates.push(
                Candidate({
                    id: candidates.length,
                    name: name,
                    voteCount: 0
                })
            );

            emit CandidateAdded(candidates.length - 1, name);
        }

    function vote(uint256 candidateId)
    public
        {
            require(
                electionActive,
                "Election is not active"
            );

            require(
                !hasVoted[msg.sender],
                "Already voted"
            );

            require(
                candidateId < candidates.length,
                "Invalid candidate"
            );

            hasVoted[msg.sender] = true;

            candidates[candidateId].voteCount++;

            emit VoteCast(
                msg.sender,
                candidateId
            );
        }

    function getCandidate(uint256 candidateId)
        public
        view
        returns(
            uint256,
            string memory,
            uint256
        )
    {
        Candidate memory c = candidates[candidateId];

        return (
            c.id,
            c.name,
            c.voteCount
        );
    }

    function getCandidateCount()
        public
        view
        returns(uint256)
    {
        return candidates.length;
    }

    function getWinner()
    public
    view
    returns (
        uint256,
        string memory,
        uint256
    )
    {
        require(candidates.length > 0, "No candidates");

        uint256 winnerIndex = 0;

        for (uint256 i = 1; i < candidates.length; i++) {

            if (
                candidates[i].voteCount >
                candidates[winnerIndex].voteCount
            ) {
                winnerIndex = i;
            }

        }

        Candidate memory winner =
            candidates[winnerIndex];

        return (
            winner.id,
            winner.name,
            winner.voteCount
        );
    }

    function startElection()
    public
    onlyOwner
        {
            electionActive = true;

            emit ElectionStarted();
        }
    
    function endElection()
    public
    onlyOwner
    {
        electionActive = false;

        emit ElectionEnded();
    }
}
event CandidateAdded(uint256 candidateId, string name);

event VoteCast(address voter, uint256 candidateId);

event ElectionStarted();

event ElectionEnded();