// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*

-Membership payment contract

*/

contract Membership {

    event NewMember(uint paid,string name,uint rank);

    //Member data:Name,subscription period,registration day,month and year
    struct Members {
        string memberName;
        uint rank;
        uint day;
        uint month;
        uint year;
    }

    mapping(address => bool) isMember;
    mapping(address => Members) member;
    uint[3] membershipFee=[10,20,30];
    address owner;

    //contract owner address
      constructor(address _owner) {
        owner=_owner;
    }  
 
    //purchase membership and add data
    function purchaseMembership(string memory _name,uint _day,uint _month,uint _year) external payable {
        //check payment values first
        require(msg.value == membershipFee[0] || msg.value == membershipFee[1] || msg.value == membershipFee[2]);
         
         for (uint i = 0; i < membershipFee.length ; i++) {
            if (msg.value == membershipFee[i]) {
                member[msg.sender].memberName=_name;
                member[msg.sender].rank=i;
                member[msg.sender].day=_day;
                member[msg.sender].month=_month;
                member[msg.sender].year=_year;
                isMember[msg.sender] = true;
            }
        }
 
        emit NewMember(msg.value, _name,member[msg.sender].rank);
    }

    //Deleting the membership end of the membership period while member wallet is connected with front end
    function cancelMembership() external {
        require(isMember[msg.sender]);
        delete isMember[msg.sender];
        delete member[msg.sender];
    }

    //update membership fee
    function updateFee(uint _bronzeMember,uint _silverMember,uint _goldMember) external {
        require(msg.sender == owner);
        membershipFee[0]=_bronzeMember;
        membershipFee[1]=_silverMember;
        membershipFee[2]=_goldMember;
    }
    
}
