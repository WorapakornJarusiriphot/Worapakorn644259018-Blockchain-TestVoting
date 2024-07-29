// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.21;

// contract TestVoting {
//     address public managerAddress;
//     address[] public candidateList;
//     mapping(string => uint256) votesScores;
//     mapping(address => uint256) isVoted;
//     enum State {
//         Started,
//         Voting,
//         Ended
//     }
//     State state;

//     constructor() {//string[] _candidateList
//         managerAddress = msg.sender;
//         //candidateList = _candidateList;
//         //state = State;
//     }

//     modifier inState(State _state) {
//         require(state == _state,"Error");
//         _;
//     }

//     function startVote() public {
//         // managerAddress ; //= State.Started

//     // function withdraw (uint256 money) public {
//     //     // require(balances[msg.sender] >= money, "Insufficient funds");
//     //     // payable(msg.sender).transfer(money);
//     //     // balances[msg.sender] -= money;

//     //     require(balances[msg.sender] >= money, "Insufficient funds");
//     //     balances[msg.sender] -= money;
//     //     (bool success, ) = msg.sender.call{value: money}("");
//     //     //msg.sender.call{value: money}("");
//     //     require(success, "withdraw failed!!");
//     // }
    
//     }

//     function endVote() public {
//         //State.Started.call(inState);
//     }

//     function candidateCount() public view returns (uint256 _State) {
//         //State = _State;
//         return _State;
//     }

//     function voteForCandidate(string memory _votesScores) public inState(bool managerAddress){
//         require(managerAddress[msg.sender] == false, "Already Voted");
//         managerAddress[msg.sender] = true;
//         votesScores += 1;
//         return votesScores = _votesScores;
//     }

//     function totalVotesFor() public view returns (uint256 candidate){
//         require(candidate == endVote, "No");
//         candidateList = candidate;
//         return candidate;
//     }
// }


pragma solidity ^0.8.0;

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
