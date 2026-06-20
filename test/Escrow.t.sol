// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {Test} from "forge-std/Test.sol";
import {EnigCredit} from "../contracts/EnigCredit.sol";
import {Marketplace} from "../contracts/Marketplace.sol";

/// @notice Slice 3 — Escrow / Trade.
contract EscrowTest is Test {
    EnigCredit token; Marketplace market;
    address seller = address(0x5E11E1); address buyer = address(0xB0B);
    uint256 price = 50 ether; uint256 id;

    function setUp() public {
        token = new EnigCredit();
        market = new Marketplace(address(token));
        token.transfer(buyer, 1000 ether);
        vm.prank(seller);
        id = market.createListing("Calculus Textbook", "Textbook", "Good", price, "");
        vm.prank(buyer);
        token.approve(address(market), price);
    }

    function test_PurchaseEscrowsTokens() public {
        vm.prank(buyer); market.purchaseItem(id);
        assertEq(token.balanceOf(address(market)), price);
        assertEq(uint256(market.getListing(id).status), uint256(Marketplace.Status.Pending));
    }
    function test_RevertWhen_SellerBuysOwn() public {
        vm.prank(seller); vm.expectRevert(Marketplace.SelfPurchase.selector); market.purchaseItem(id);
    }
    function test_ConfirmDeliveryPaysSeller() public {
        vm.prank(buyer); market.purchaseItem(id);
        vm.prank(buyer); market.confirmDelivery(id);
        assertEq(token.balanceOf(seller), price);
        assertEq(uint256(market.getListing(id).status), uint256(Marketplace.Status.Sold));
    }
    function test_RevertWhen_CancelBeforeTimeout() public {
        vm.prank(buyer); market.purchaseItem(id);
        vm.prank(buyer); vm.expectRevert(Marketplace.TimeoutNotReached.selector); market.cancelPurchase(id);
    }
    function test_CancelAfterTimeoutRefundsBuyer() public {
        vm.prank(buyer); market.purchaseItem(id);
        vm.warp(block.timestamp + 5 minutes + 1);
        vm.prank(buyer); market.cancelPurchase(id);
        assertEq(token.balanceOf(buyer), 1000 ether);
        assertEq(uint256(market.getListing(id).status), uint256(Marketplace.Status.Available));
    }
    function test_RevertWhen_PurchaseWhenPaused() public {
        market.pause();
        vm.prank(buyer); vm.expectRevert(); market.purchaseItem(id);
    }
    function test_PurchaseWithPermit() public {
        uint256 pk = 0xB0B1; address pbuyer = vm.addr(pk);
        token.transfer(pbuyer, 1000 ether);
        vm.prank(seller);
        uint256 id2 = market.createListing("Algorithms", "Textbook", "Good", price, "");
        uint256 deadline = block.timestamp + 1 days;
        bytes32 sh = keccak256(abi.encode(keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"), pbuyer, address(market), price, token.nonces(pbuyer), deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), sh));
        (uint8 v, bytes32 r, bytes32 sg) = vm.sign(pk, digest);
        vm.prank(pbuyer); market.purchaseWithPermit(id2, deadline, v, r, sg);
        assertEq(token.balanceOf(address(market)), price);
        assertEq(uint256(market.getListing(id2).status), uint256(Marketplace.Status.Pending));
    }
}
