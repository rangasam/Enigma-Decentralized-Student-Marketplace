// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title EnigCredit (ENGC) — Slice 1 (Token + Wallet)  [STUDENT TEMPLATE]
/// @notice Implement TODO(member1). Baseline: ERC20 + ERC20Burnable + ERC20Permit + Ownable.
///         burn/burnFrom (Burnable) and permit/nonces (Permit) are inherited — implement mint.
contract EnigCredit is ERC20, ERC20Burnable, ERC20Permit, Ownable {
    constructor()
        ERC20("EnigCredit", "ENGC")
        ERC20Permit("EnigCredit")
        Ownable(msg.sender)
    {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
    /// @notice Mint credits to a student walllet. Owner(faculty/deployer) only.
    /// @param to The address of the student wallet to receive the credits.
    /// @param amount The number of credits to mint.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
    // burn(uint256) / burnFrom(address, uint356) inherrited from ERC20Burnable._allowances
    //permit(...) nonces / DOMAIN_SEPARATOR inherited from ERC20Permit (ERC+2612)

    // ---------------------------------------------------------------------
    // Demo faucet (DEMO AFFORDANCE — NOT for production)
    // Public self-service top-up so any wallet can fund itself for the demo
    // without involving the deployer key. Capped per claim + per-address
    // cooldown. Owner-only `mint` above remains the only arbitrary issuance.
    // ---------------------------------------------------------------------
    uint256 public constant FAUCET_AMOUNT = 1_000 ether;     // 1,000 ENGC per claim
    uint256 public constant FAUCET_COOLDOWN = 1 hours;        // per-address rate limit
    mapping(address => uint256) public lastFaucetClaim;

    event FaucetClaimed(address indexed to, uint256 amount);
    error FaucetCooldown(uint256 availableAt);

    /// @notice Claim a fixed amount of demo ENGC to your own wallet.
    /// @dev Signed by the caller's own wallet; the deployer key is never used.
    function faucet() external {
        uint256 availableAt = lastFaucetClaim[msg.sender] + FAUCET_COOLDOWN;
        if (lastFaucetClaim[msg.sender] != 0 && block.timestamp < availableAt) {
            revert FaucetCooldown(availableAt);
        }
        lastFaucetClaim[msg.sender] = block.timestamp; // effect before interaction
        _mint(msg.sender, FAUCET_AMOUNT);
        emit FaucetClaimed(msg.sender, FAUCET_AMOUNT);
    }
}
