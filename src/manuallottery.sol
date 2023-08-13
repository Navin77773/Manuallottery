// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error manuallottery__notEnougheth(string);
error manuallottery__excessEther(string);
error manuallottery__participantslimitNotReached();
error manuallottery__onlyOwner();

contract manuallottery {
    event participantEntered(address);
    event fundTransferedtoWinner(address);

    address immutable OWNER;

    address[] private s_listofParticipants;

    address[] private s_listofWinners;

    constructor() {
        OWNER = msg.sender;
    }

    function enterRaffle() public payable {
        if (msg.value < 5 ether) {
            revert manuallottery__notEnougheth(
                "entry price is 5 ether , the entered amount is less than expected price"
            );
        } else if (msg.value > 5 ether) {
            revert manuallottery__excessEther(
                "entry price is 5 ether , the entered amount is more than expected price"
            );
        }
        s_listofParticipants.push(msg.sender);
        emit participantEntered(msg.sender);
    }

    function pickWinner(uint _value) external {
        if (msg.sender == OWNER) {
            revert manuallottery__onlyOwner();
        } else if (
            s_listofParticipants.length < 5 || s_listofParticipants.length > 5
        ) {
            revert manuallottery__participantslimitNotReached();
        }
        address winner = s_listofParticipants[_value];
        payable(winner).transfer(address(this).balance);
        s_listofWinners.push(winner);
        emit fundTransferedtoWinner(winner);
    }

    /** Getter Functions */

    function checkParticipant(uint _value) external view returns (address) {
        return s_listofParticipants[_value];
    }

    function checkWinner(uint _value) external view returns (address) {
        return s_listofWinners[_value];
    }

    function lengthoflistofParticipants() external view returns (uint) {
        return s_listofParticipants.length;
    }

    function lengthoflistofWinners() external view returns (uint) {
        return s_listofWinners.length;
    }
}
