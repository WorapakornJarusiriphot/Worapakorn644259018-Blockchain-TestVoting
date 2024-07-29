// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TestVoting {
    address public managerAddress;
    string[] public candidateList;
    mapping(string => uint) public votesScores;
    mapping(address => bool) public isVoted;
    
    enum State { Started, Voting, Ended }
    State public state;

    constructor(string[] memory _candidateList) {
        managerAddress = msg.sender;
        candidateList = _candidateList;
        state = State.Started;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }
    
    function startVote() public inState(State.Started) {
        state = State.Voting;
    }
    
    function endVote() public inState(State.Voting) {
        state = State.Ended;
    }
    
    function candidateCount() public view returns (uint) {
        return candidateList.length;
    }
    
    function voteForCandidate(string memory _candidate) public inState(State.Voting) {
        require(isVoted[msg.sender] == false, "Already Voted");
        isVoted[msg.sender] = true;
        votesScores[_candidate] += 1;
    }
    
    function totalVotesFor(string memory _candidate) public view inState(State.Ended) returns (uint) {
        return votesScores[_candidate];
    }
}

