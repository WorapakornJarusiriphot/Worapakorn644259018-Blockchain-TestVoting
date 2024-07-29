// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TestVoting {
    address public managerAddress;
    string[] public candidateList;
    mapping(string => uint256) public votesScores;
    mapping(address => bool) public isVoted;
    enum State {
        Started,
        Voting,
        Ended
    }
    State public state;

    constructor(string[] memory _candidateList) {
        managerAddress = msg.sender;
        candidateList = _candidateList;
        state = State.Started;
    }

    //สร้างเพื่อจำกัจคนคลิกปุ่ม startVote กับ endVote
    modifier onlyManager() {
        require(msg.sender == managerAddress, "Only manager can execute");
        _;
    }

    //inState ทำหน้าที่ตรวจสอบว่า state ปัจจุบันของ contract ตรงกับ _state ที่ถูกต้องหรือไม่ ถ้า state ปัจจุบันไม่ตรงกับ _state ที่ต้องการ, require จะ throw ข้อผิดพลาดและ transaction จะถูกยกเลิก
    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }

    //เป็นการสร้างปุ่ม startVote ขึ้นมาถ้า managerAddress ยังไม่กดปุ่มนี้ทุกคนก็จะยังไม่สามารถโหวตได้
    function startVote() public onlyManager inState(State.Started) {
        state = State.Voting;
    }

    //เป็นการสร้างปุ่ม endVote ขึ้นมาถ้า managerAddress กดปุ่มนี้แล้ว ก็จะสิ้นสุดการโหวดทันที ทุกคนก็จะยังไม่สามารถโหวตต่อได้
    function endVote() public onlyManager inState(State.Voting) {
        state = State.Ended;
    }

    //เป็นการสร้างปุ่ม candidateCount ขึ้นมา ถ้ากดปุ่มนี้แล้ว ก็จะขึ้นจำนวนคนเข้าสมัครการโหวตขึ้นมา
    function candidateCount() public view returns (uint256) {
       return candidateList.length;
    }

    //voteForCandidate เอาไว้ใช้สำหรับ กรอกชื่อคนที่จะโหวด แล้วถ้าโหวดไปแล้วก็จะไม่สามารถโหวตอีกได้
    function voteForCandidate(string memory _candidate) public inState(State.Voting)
    {
        require(isVoted[msg.sender] == false, "Already Voted");
        isVoted[msg.sender] = true;
        votesScores[_candidate] += 1;
    }

    //เป็นการใช้ totalVotesFor ซึ่งหากเราต้องการเปิดเผยคะแนนโหวตเฉพาะเมื่อการโหวตสิ้นสุด ถ้ายังไม่สิ้นสุดก็จะไม่สามารถใช้งานปุ่มนี้ได้
    function totalVotesFor(string memory _candidate) public view inState(State.Ended) returns (uint256)
    {
        return votesScores[_candidate]; //เป็นการใช้ votesScores ซึ่งหากเราต้องการให้ผู้ใช้สามารถติดตามคะแนนโหวตของแต่ละคนได้ตลอดเวลา
    }

    //โค้ดนี้เราเขียนเพิ่มเอาเองไม่มีในคำถาม //การรวมผลของโหวดทุกคนว่าโหวดไปแล้วกี่คนเช่น คน A ได้รับผลโหวด 10 แล้ว คน B ได้รับผลโหวด 5 การรวมคำโหวดทุกคนก็จะได้ 15
    function totalVotes() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < candidateList.length; i++) {
            total += votesScores[candidateList[i]];
        }
        return total;
    }
}
