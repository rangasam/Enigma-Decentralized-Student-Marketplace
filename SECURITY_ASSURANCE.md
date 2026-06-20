# Security Assurance — Enigma-Decentralized-Student-Marketplace

> Aligned to **Ethereum-Token-v2026.pdf** (EthTrust, vulnerability matrix, OWASP). Token + escrow (ERC-20).

## EthTrust Security Assurance Levels (EEA v3)
| Level | Requires | Status |
|-------|----------|--------|
| **[S]** | clean compile, pinned solc 0.8.20, no unsafe patterns | ✅ build clean; Slither CI |
| **[M]** | reentrancy guards, access control, CEI, checked external calls, events | ✅ OZ `ReentrancyGuard` on all escrow paths; OZ `Ownable` mint; CEI before `transferFrom`/`transfer`; events on every step |
| **[Q]** | threat model, fuzz/invariant, review | ✅ `test/Invariant.t.sol`; matrix below; course review |

## Vulnerability Diagnostic & Mitigation Matrix
| Threat (OWASP SCWE) | Where | Mitigation |
|---|---|---|
| Reentrancy (SC05) | `purchaseItem`, `confirmDelivery`, `cancelPurchase` | OZ `ReentrancyGuard` + CEI (state set before token transfer) |
| Broken access control (SC01) | `mint`, escrow actions | OZ `Ownable` mint; per-listing `seller`/`buyer` checks |
| Unauthorized fund release | `confirmDelivery` | only the buyer; status must be `Pending` |
| Self-dealing | `purchaseItem` | `SelfPurchase` (buyer ≠ seller) |
| Stuck escrow / seller non-delivery | `cancelPurchase` | buyer refund after `CANCELLATION_TIMEOUT` |
| Rating manipulation | `rateUser` | only buyer, only `Sold`, once per listing |
| Allowance/approval misuse | `purchaseItem` / `purchaseWithPermit` | pull-payment via **SafeERC20**; ERC-2612 `permit` for signed approvals |
| Non-standard ERC-20 return | all token transfers | **SafeERC20** `safeTransfer`/`safeTransferFrom` (no silent failures) |
| Incident / emergency | listings + purchases | **Pausable** owner stop (`pause`/`unpause`, `whenNotPaused`) |
| Integer overflow | counters | Solidity 0.8 checked arithmetic |

## Minting & Burning (token supply)
ERC-20 `EnigCredit`: fixed initial supply to deployer + owner-gated `mint` (faculty airdrops) + holder **`burn`/`burnFrom`** (OZ `ERC20Burnable`) + **ERC-2612 `permit`** (OZ `ERC20Permit`) for gasless approvals. Baseline per Token-v2026 §Minting & Burning.

## Tooling
Slither (`slither.config.json`, CI job) · Foundry fuzz + invariant (`test/Invariant.t.sol`) · `forge test --gas-report`.
Refs: EEA EthTrust v3 + Checklist; OWASP SCSVS/SCSTG/SCWE; Solidity Security Considerations; OpenZeppelin docs.

> **4-slice note:** ratings live in `Reputation.sol` (member4), which reads completed-sale state from the Marketplace. Same guards (only buyer, only Sold, once per listing, 1–5) — see `docs/reputation-module.md`.
