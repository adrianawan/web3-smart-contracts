// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Voting} from "./Voting.sol";

contract VotingTest is Test {

    Voting voting;

    address voter1 = address(1);
    address voter2 = address(2);

    function setUp() public {
        voting = new Voting(address(this));

        voting.addCandidate("Alice");
        voting.addCandidate("Bob");
    }

    function testCandidateCount() public view {
        require(
            voting.getCandidateCount() == 2,
            "Should have two candidates"
        );
    }

    function testStartElection() public {
        voting.startElection();

        require(
            voting.electionActive(),
            "Election should be active"
        );
    }

    function testVote() public {

        voting.startElection();

        vm.prank(voter1);

        voting.vote(0);

        (, , uint256 votes) =
            voting.getCandidate(0);

        require(votes == 1);
    }

    function testDoubleVote() public {

        voting.startElection();

        vm.startPrank(voter1);

        voting.vote(0);

        vm.expectRevert();

        voting.vote(1);

        vm.stopPrank();
    }

    function testEndElection() public {

        voting.startElection();

        voting.endElection();

        require(
            !voting.electionActive(),
            "Election should be ended"
        );
    }
}