// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {EnigCredit} from "../contracts/EnigCredit.sol";
import {Marketplace} from "../contracts/Marketplace.sol";
import {Reputation} from "../contracts/Reputation.sol";

/// @notice Deploys EnigCredit + Marketplace + Reputation (4-slice) and
///         optionally pre-funds a list of demo wallets with ENGC.
///
/// Optional env (Option C — pre-fund at deploy, no deployer key in the app):
///   DEMO_RECIPIENTS  comma-separated addresses to credit, e.g. "0xabc...,0xdef..."
///   DEMO_GRANT       ENGC (whole tokens) to mint per recipient (default 10000)
///
/// The pre-fund reuses the owner-only `mint`, so the deployer remains the sole
/// arbitrary minter — it just exercises that authority once at setup. Wallets
/// not on the list can still self-serve via the public `faucet()`.
contract Deploy is Script {
    function run() external {
        address[] memory recipients = vm.envOr("DEMO_RECIPIENTS", ",", new address[](0));
        uint256 grantWhole = vm.envOr("DEMO_GRANT", uint256(10_000));
        uint256 grant = grantWhole * 1 ether;

        vm.startBroadcast();
        EnigCredit token = new EnigCredit();
        Marketplace market = new Marketplace(address(token));
        Reputation reputation = new Reputation(address(market));

        for (uint256 i = 0; i < recipients.length; i++) {
            token.mint(recipients[i], grant);
            console2.log("Pre-funded:", recipients[i], grantWhole);
        }
        vm.stopBroadcast();

        console2.log("EnigCredit :", address(token));
        console2.log("Marketplace:", address(market));
        console2.log("Reputation :", address(reputation));
        console2.log("Pre-funded recipients:", recipients.length);
    }
}
