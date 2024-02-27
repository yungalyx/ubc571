// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Ethazon {

    struct EthazonOrder {
        bool isValidEthazonOrder;
        string customerName;
        string shippingAddress;
        bool hasConfirmed;
    }

    event Logs(string);
    event Logs2(bool);
    
    mapping(address => EthazonOrder) public order_logs;


    receive() external payable {
        require(msg.value == 0.1 ether);
    }

    fallback() external payable {

    }

    modifier checkFundsReceived { 
        uint256 prebalance = address(this).balance;
        _;
        require(address(this).balance > prebalance, "CHECK FUNDS RECEIVED");
    }

    function checkOrder() public view returns (bool, string memory, string memory, bool) {
        EthazonOrder memory eord = order_logs[msg.sender];
        return (eord.isValidEthazonOrder, eord.customerName, eord.shippingAddress, eord.hasConfirmed);
    }

    function makeOrder(string calldata _customerName, string calldata _shippingAddress) public payable {
        
        require(bytes(_customerName).length > 0, "INVALID NAME");
        require(bytes(_shippingAddress).length > 0, "INVALID ADDRESS");
        require(msg.value == 1 ether, "INVALID AMOUNT");

        
        EthazonOrder storage eord = order_logs[msg.sender];

    

        if (!eord.hasConfirmed && !eord.isValidEthazonOrder) { // first time
            eord.customerName = _customerName;
            eord.shippingAddress = _shippingAddress;
            eord.hasConfirmed = false;
        } else if (eord.isValidEthazonOrder && eord.hasConfirmed) { // can reuse 
            eord.customerName = _customerName;
            eord.shippingAddress = _shippingAddress;
            eord.hasConfirmed = false;
        } else if (!eord.isValidEthazonOrder && eord.hasConfirmed) {  // should revert
            revert();
        }

        order_logs[msg.sender] = eord;
  

    }

    function confirmOrder() public view {

        EthazonOrder memory eord = order_logs[msg.sender];
        require(eord.isValidEthazonOrder, "INVALID ORDER");
        eord.hasConfirmed = true;

    }

    function cancelOrder() public {
        EthazonOrder memory eord = order_logs[msg.sender];
        require(eord.isValidEthazonOrder && !eord.hasConfirmed);
        eord.isValidEthazonOrder = false;
        payable(msg.sender).transfer(0.1 ether);

    }

}
