# Security Architecture & Standards

Security is a first-class design goal of the Enigma Marketplace, not an afterthought. Rather than
hand-rolling token, access-control, or transfer logic, every sensitive primitive is delegated to
**audited, community-reviewed [OpenZeppelin](https://docs.openzeppelin.com/contracts/5.x/) v5.1.0
libraries** and established Ethereum standards. This minimizes the custom attack surface and inherits
years of audits and battle-testing.

> This page covers the **technical** security design. For operational policy (no secrets in the repo,
> testnet-only, PII, screenshot redaction, key rotation), see [`SECURITY.md`](https://github.com/enigma-group-project/Enigma-Decentralized-Student-Marketplace/blob/main/SECURITY.md).

## 1. Standard, audited building blocks (OpenZeppelin)
`EnigCredit` and `Marketplace` compose only standard OpenZeppelin modules:

| Concern | OpenZeppelin module | Why it matters |
|---|---|---|
| Token model | `ERC20` | Canonical, interoperable fungible-token semantics — wallets, explorers, and tooling understand it natively. |
| Gasless approvals | `ERC20Permit` (EIP-2612) | Buyers authorize escrow with an **off-chain signature** instead of a separate `approve` transaction — fewer transactions, no lingering allowances. |
| Supply reduction | `ERC20Burnable` | Standard, safe burn path. |
| Access control | `Ownable` | Single, explicit privileged role for credit issuance. |
| Reentrancy | `ReentrancyGuard` | `nonReentrant` mutex on every fund-moving function. |
| Safe transfers | `SafeERC20` | Wraps token transfers so non-compliant / non-reverting tokens can't silently fail. |
| Emergency stop | `Pausable` | Owner can halt state changes if a flaw is discovered. |

## 2. The ERC-20 transaction model
Credits are a standard **ERC-20** token (`EnigCredit`, symbol `ENGC`). Using the standard — rather than
a bespoke balance ledger — means transfers, allowances, and events follow well-understood, formally
specified semantics that are already supported by MetaMask, Etherscan, and ethers.js. Payments flow
through the **allowance/escrow** pattern: the buyer authorizes the `Marketplace` (via `approve` or, ideally,
a single **EIP-2612 `permit`** signature), and the contract pulls funds into escrow with `SafeERC20`.

## 3. Reentrancy protection (defence in depth)
Every function that moves value (`purchaseItem`, `confirmDelivery`, `cancelPurchase`, `rateUser`)
applies **two independent defences**:

1. **Checks-Effects-Interactions (CEI):** all validation and **state updates happen before** any external
   call or token transfer, so a malicious callback cannot observe or re-enter mid-update.
2. **`ReentrancyGuard` (`nonReentrant`):** a mutex that blocks nested re-entry even if an interaction is
   reachable.

Token movements use **`SafeERC20`** (`safeTransfer` / `safeTransferFrom`) so a misbehaving token cannot
break accounting by returning `false` or no value.

## 4. Access control & least privilege
- **Owner-only issuance:** arbitrary minting is restricted to the deployer via `Ownable`'s `onlyOwner`.
- **Capped public faucet (demo only):** `faucet()` lets any wallet self-serve a **fixed 1,000 ENGC with a
  1-hour cooldown** — a *demo affordance* that adds no arbitrary-mint power. Production issuance stays
  owner-gated.
- **Action binding:** only the **buyer** of a **completed** sale can `confirmDelivery` or `rateUser`, and
  each listing can be rated **once** — preventing payment redirection and reputation forgery.

## 5. Escrow & dispute safety
Buyer funds are held **in the contract**, not sent to the seller, until the buyer confirms delivery.
A **timeout-based refund** (`cancelPurchase`) protects the buyer if a seller never delivers, giving a
trustless dispute path without a central arbiter.

## 6. Language-level & coding-standard protections
- **Solidity 0.8.20** — built-in checked arithmetic (overflow/underflow revert by default).
- **Custom errors** — gas-efficient, explicit revert reasons (`NotBuyer`, `BadRating`, `AlreadyRated`, …).
- **Pinned dependencies** — OpenZeppelin pinned to **v5.1.0** for reproducible, reviewed builds.
- **Events** for every state transition, enabling off-chain indexing and auditability.

## 7. Verification: tested and statically analysed
Security is continuously verified in CI on every pull request:

- **Unit tests** (`forge test`) cover authorization, reverts, and the full escrow/rating lifecycle.
- **Fuzz & invariant tests** (`test/Invariant.t.sol`) — e.g. listing IDs are monotonic and no self-purchase
  is possible — explore thousands of randomized inputs.
- **Slither** static analysis runs as a required CI job, flagging reentrancy, access-control, and
  unchecked-call patterns before merge.

Together these standards — audited OpenZeppelin libraries, the ERC-20 model, layered reentrancy
protection, least-privilege access control, and automated testing/analysis — give the marketplace a
defensible, reviewable security posture appropriate for a trustless, multi-party application.
