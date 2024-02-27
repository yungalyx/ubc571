// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract OnlineFlightBooking {

  struct FlightBooking {
    bool isValidBooking;
    string departureCity;
    string arrivalCity;
    bool hasCheckedIn;
  }

  mapping(address => FlightBooking) public orderbook;
  bool private locked;

  modifier nonReentrant() {
    require(!locked, "No reentrant");
    locked = true;
    _;
    locked = false;


  }

  function checkBooking() public view returns (bool, string memory, string memory, bool) {
      FlightBooking memory booking = orderbook[msg.sender];
      return (booking.isValidBooking, booking.departureCity, booking.arrivalCity, booking.hasCheckedIn);
  }


  function makeBooking(string calldata _departure, string calldata _arrival) external payable {
        
    require(bytes(_departure).length > 0, "INVALID DEPARTURE CITY");
    require(bytes(_arrival).length > 0, "INVALID ARRIVAL CITY");
    require(msg.value == 1.5 ether, "INCORRECT AMOUNT SENT");

    FlightBooking storage booking = orderbook[msg.sender];

    if (!booking.isValidBooking && !booking.hasCheckedIn) { // first time
      booking.departureCity = _departure;
      booking.arrivalCity = _arrival;
      booking.isValidBooking = true;
    } else if (booking.isValidBooking && booking.hasCheckedIn) { // can reuse 
      booking.departureCity = _departure;
      booking.arrivalCity = _arrival;
      booking.hasCheckedIn = false;
      booking.isValidBooking = true;
    } else {
      revert("CANNOT MAKE ANOTHER BOOKING");
    }

    orderbook[msg.sender] = booking;
  
  }


  function cancelBooking() external nonReentrant() {
    FlightBooking storage booking = orderbook[msg.sender];

    require(!booking.hasCheckedIn, "CANNOT REFUND IF CHECKED IN");
    require(booking.isValidBooking, "CANNOT REFUND");
      
    orderbook[msg.sender].isValidBooking = false; // this function must go first 
    payable(msg.sender).transfer(1.5 ether);
  
  }


  function checkIn() external {
    FlightBooking storage booking = orderbook[msg.sender];
    require(booking.isValidBooking, "CANNOT CHECK IN TO INVALID BOOKING");
    orderbook[msg.sender].hasCheckedIn = true;

  }
}