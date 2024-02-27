// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "forge-std/Vm.sol";
import { OnlineFlightBooking } from "../src/OnlineFlightBooking.sol";


contract OnlineFlightBookingTest is Test {

  OnlineFlightBooking public ofb;

  function setUp() public {
    ofb = new OnlineFlightBooking();
    
  }


  // 1. A passenger cannot book a ticket if either departure city or arrivalCity is empty string

  function test_missing_arrival() public {
    vm.expectRevert("INVALID ARRIVAL CITY");
    ofb.makeBooking{value: 1.5 ether}("YVR", "");

  }

  function test_missing_departure() public {
    vm.expectRevert("INVALID DEPARTURE CITY");
    ofb.makeBooking{value: 1.5 ether}("", "SEA");
  }

  // 2. A passenger cannot check in if the booking is not valid

  function test_make_order_valid() public {
    address alice = makeAddr("Alice");
    vm.deal(alice, 1.5 ether);
    vm.prank(alice);

    vm.expectRevert("CANNOT CHECK IN TO INVALID BOOKING");
    ofb.checkIn();
    
  }

  // 3. A passenger cannot refund the ticket if the passenger has checked in

  function test_cannot_refund_if_checked_in() public {
    address alice = makeAddr("Alice");
    vm.deal(alice, 1.5 ether);
    vm.startPrank(alice);

    ofb.makeBooking{value: 1.5 ether}("YVR", "PVG");
    ofb.checkIn();

    vm.expectRevert("CANNOT REFUND IF CHECKED IN");
    ofb.cancelBooking();

    vm.stopPrank();
  }

  // 4. A passenger canot buy another ticket before they have checked in or cancelled 
  // i.e, cannot book if checkedin is false but ticket valid
  // can book if ticket valid 


  function test_cannot_book_if_not_checked_in() public {
    address alice = makeAddr("Alice");
    vm.deal(alice, 3 ether);
    vm.startPrank(alice);

    ofb.makeBooking{value: 1.5 ether}("SIN", "EDI");
    
    vm.expectRevert("CANNOT MAKE ANOTHER BOOKING");
    ofb.makeBooking{value: 1.5 ether}("SIN", "PVG");

    vm.stopPrank();

  }

  // 5. A passenger cannot make a booking if they send incorret ether 

  function test_cannot_book_if_too_little_ether_sent() public {
    address alice = makeAddr("Alice");
    vm.deal(alice, 2 ether);
    vm.startPrank(alice);

    vm.expectRevert("INCORRECT AMOUNT SENT");
    ofb.makeBooking{value: 2 ether}("SIN", "EDI");

    vm.stopPrank();

  }

  function test_cannot_book_if_too_much_ether_sent() public {
    address alice = makeAddr("Alice");
    vm.deal(alice, 2 ether);
    vm.startPrank(alice);

    vm.expectRevert("INCORRECT AMOUNT SENT");
    ofb.makeBooking{value: 1 ether}("SIN", "EDI");

    vm.stopPrank();

  }

  // 6. If everything is okay, a booking should be made successfully
  // 9. The smart contract should have correct balance of thers if ookng has been made 
  function test_successful_booking() public {
    uint256 balanceBefore = address(ofb).balance;
    address alice = makeAddr("Alice");
    vm.deal(alice, 1.5 ether);
    vm.prank(alice);

    ofb.makeBooking{value: 1.5 ether}("SIN", "EDI");

    uint256 balanceAfter = address(ofb).balance;

    assertEq(balanceAfter - balanceBefore, 1.5 ether, "expect increase of 1.5 ether");

  }



  // 7. A passenger should recieve money when booking is cancelled

  function test_successful_cancellation() public {
    
    address alice = makeAddr("Alice");
    vm.deal(alice, 1.5 ether);

    vm.startPrank(alice);

    ofb.makeBooking{value: 1.5 ether}("PVG", "YVR");
    ofb.cancelBooking();

    uint256 balanceAfter = address(alice).balance;

    assertEq(balanceAfter, 1.5 ether, "expect 1.5 ether to be refunded");

  }


  // 8. A passenger can check in if everything is good? 

  function test_successful_checkin() public  {
    address alice = makeAddr("Alice");
    vm.deal(alice, 3 ether);

    vm.startPrank(alice);
    ofb.makeBooking{value: 1.5 ether}("PVG", "YVR");
    ofb.checkIn();

    (bool valid,,, bool checkedIn) = ofb.checkBooking();
    assertEq(checkedIn, true, "Check in should be true");

  }

}
