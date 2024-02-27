// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "forge-std/Vm.sol";
import { Ethazon } from "../src/Ethazon.sol";


contract EthazonTest is Test {

  Ethazon public ethazon;

// function setUp() public {
//   ethazon = new Ethazon();
  
// }


// // 1. A customer cannot make the order if either the customerName or shippingAddress is empty.

// function test_missing_name() public {
//   vm.expectRevert("INVALID NAME");
//   ethazon.makeOrder("", "5398 Tyne Street");

// }

// function test_missing_address() public {
//   vm.expectRevert("INVALID ADDRESS");
//   ethazon.makeOrder("Okay name", "");
// }

// function test_make_order_valid() public {
//   address alice = makeAddr("Alice");
//   vm.deal(alice, 1 ether);
//   vm.prank(alice);

//   ethazon.makeOrder{value: 1 ether}("Alice", "yesy");
  
//   vm.prank(alice);
//   (bool valid, string memory name,,) = ethazon.checkOrder();
//   assertEq(name, "Alice");

// }


// 2. A customer cannot confirm if the order is not valid (when isValidEthazonOrder is false).
// function test_invalid_order_cannot_confirm() public {
//   vm.expectRevert("INVALID ORDER");
//   ethazon.makeOrder("yes", "yes");
//   ethazon.cancelOrder();
//   ethazon.confirmOrder();
// }

// 3. A customer cannot cancel the order if the customer has confirmed the order.
// 4. A customer cannot make another order before she/he has confirmed or canceled the existing order.
// 5. A customer cannot make an order if he/she does not send enough ether to the smart contract.
// 6. If everything is OK, a customer should create an order successfully.
// 7. A customer should receive the money when she/he cancel the order successfully.
// 8. A customer can confirm the order if everything is good.
// 9. The smart contract should have the correct balance of Ethers if an order has been made.


}