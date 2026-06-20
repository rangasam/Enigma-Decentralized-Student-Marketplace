// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {EnigCredit} from "../contracts/EnigCredit.sol";
import {Marketplace} from "../contracts/Marketplace.sol";
import {Reputation} from "../contracts/Reputation.sol";

/// @notice Deploys EnigCredit + Marketplace + Reputation (4-slice).
contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        EnigCredit token = new EnigCredit();
        Marketplace market = new Marketplace(address(token));
        Reputation reputation = new Reputation(address(market));
        vm.stopBroadcast();
        console2.log("EnigCredit :", address(token));
        console2.log("Marketplace:", address(market));
        console2.log("Reputation :", address(reputation));
    }
}
