// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {EnigCredit} from "../contracts/EnigCredit.sol";

/// @notice Slice 1 — Token + Wallet.
contract EnigCreditTest is Test {
    EnigCredit token;
    address alice = address(0xA11CE);

    function setUp() public { token = new EnigCredit(); }

    function test_Metadata() public view {
        assertEq(token.name(), "EnigCredit");
        assertEq(token.symbol(), "ENGC");
        assertEq(token.decimals(), 18);
    }

    function test_InitialSupplyToDeployer() public view {
        assertEq(token.totalSupply(), 1_000_000 ether);
        assertEq(token.balanceOf(address(this)), 1_000_000 ether);
    }

    function test_OwnerCanMint() public {
        token.mint(alice, 500 ether);
        assertEq(token.balanceOf(alice), 500 ether);
    }

    function test_RevertWhen_NonOwnerMints() public {
        vm.prank(alice);
        vm.expectRevert();
        token.mint(alice, 1 ether);
    }

    function test_Transfer() public {
        token.transfer(alice, 100 ether);
        assertEq(token.balanceOf(alice), 100 ether);
    }

    // ---- Token-v2026 baseline additions ----
    function test_BurnReducesSupply() public {
        uint256 s0 = token.totalSupply();
        token.burn(1_000 ether);
        assertEq(token.totalSupply(), s0 - 1_000 ether);
    }

    function test_Permit() public {
        uint256 pk = 0xBEEF;
        address signer = vm.addr(pk);
        address spender = address(0x5);
        uint256 value = 5 ether;
        uint256 deadline = block.timestamp + 1 days;
        bytes32 structHash = keccak256(abi.encode(
            keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
            signer, spender, value, token.nonces(signer), deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), structHash));
        (uint8 v, bytes32 r, bytes32 sg) = vm.sign(pk, digest);
        token.permit(signer, spender, value, deadline, v, r, sg);
        assertEq(token.allowance(signer, spender), value);
    }

    // ---- Demo faucet ----
    function test_FaucetMintsToCaller() public {
        vm.prank(alice);
        token.faucet();
        assertEq(token.balanceOf(alice), token.FAUCET_AMOUNT());
    }

    function test_RevertWhen_FaucetWithinCooldown() public {
        vm.startPrank(alice);
        token.faucet();
        vm.expectRevert(
            abi.encodeWithSelector(EnigCredit.FaucetCooldown.selector, block.timestamp + token.FAUCET_COOLDOWN())
        );
        token.faucet();
        vm.stopPrank();
    }

    function test_FaucetAgainAfterCooldown() public {
        vm.startPrank(alice);
        token.faucet();
        vm.warp(block.timestamp + token.FAUCET_COOLDOWN());
        token.faucet();
        vm.stopPrank();
        assertEq(token.balanceOf(alice), token.FAUCET_AMOUNT() * 2);
    }
}
