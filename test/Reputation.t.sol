// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {Test} from "forge-std/Test.sol";
import {EnigCredit} from "../contracts/EnigCredit.sol";
import {Marketplace} from "../contracts/Marketplace.sol";
import {Reputation} from "../contracts/Reputation.sol";

/// @notice Slice 4 — Reputation / Ratings.
contract ReputationTest is Test {
    EnigCredit token; Marketplace market; Reputation rep;
    address seller = address(0x5E11E1); address buyer = address(0xB0B); address other = address(0x07);
    uint256 price = 50 ether; uint256 id;

    function setUp() public {
        token = new EnigCredit();
        market = new Marketplace(address(token));
        rep = new Reputation(address(market));
        token.transfer(buyer, 1000 ether);
        vm.prank(seller);
        id = market.createListing("Calculus Textbook", "Textbook", "Good", price, "");
        vm.prank(buyer); token.approve(address(market), price);
        vm.prank(buyer); market.purchaseItem(id);
        vm.prank(buyer); market.confirmDelivery(id); // status -> Sold
    }

    function test_RateAfterSold() public {
        vm.prank(buyer); rep.rateUser(id, 5);
        (uint256 total, uint256 count) = rep.getAverageRating(seller);
        assertEq(total, 5); assertEq(count, 1);
        assertTrue(rep.buyerRatedSeller(id));
    }
    function test_RevertWhen_RateTwice() public {
        vm.prank(buyer); rep.rateUser(id, 4);
        vm.prank(buyer); vm.expectRevert(Reputation.AlreadyRated.selector); rep.rateUser(id, 4);
    }
    function test_RevertWhen_NonBuyerRates() public {
        vm.prank(other); vm.expectRevert(Reputation.Unauthorized.selector); rep.rateUser(id, 5);
    }
    function test_RevertWhen_BadRating() public {
        vm.prank(buyer); vm.expectRevert(Reputation.BadRating.selector); rep.rateUser(id, 6);
    }
    function test_RevertWhen_RateUnsold() public {
        vm.prank(seller);
        uint256 id2 = market.createListing("Notes", "Notes", "New", price, "");
        vm.prank(buyer); vm.expectRevert(Reputation.NotSold.selector); rep.rateUser(id2, 5);
    }
}
