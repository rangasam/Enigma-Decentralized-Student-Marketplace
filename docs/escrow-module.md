# Slice 3 — Escrow / Trade (`Marketplace.sol`)
> Owner: **member3** (AJ Sanon) · Branch: `feature/member3-escrow` · co-owns `Marketplace.sol` with member2 (listings).

## Implements
- `purchaseItem(id)` — buyer must `approve` first; pulls `priceInTokens` via **`SafeERC20.transferFrom`** into the contract (escrow), sets `Status.Pending`, records `buyer` + `purchaseTimestamp`, emits `ItemPurchased`. `nonReentrant whenNotPaused`. Reverts `NotAvailable`, `SelfPurchase`.
- `purchaseWithPermit(id, deadline, v, r, s)` — same as above but authorizes via **EIP-2612 `permit`** (no separate `approve` tx).
- `confirmDelivery(id)` — **buyer** confirms receipt → releases escrow to **seller** (`safeTransfer`), sets `Status.Sold`, emits `DeliveryConfirmed`. Reverts `NotPending`, `NotBuyer`.
- `cancelPurchase(id)` — **buyer** refund **after `CANCELLATION_TIMEOUT`** (trustless dispute), emits `PurchaseCancelled`. Reverts `NotPending`, `NotBuyer`, `TimeoutNotReached`.
- `pause()` / `unpause()` — owner emergency stop.
- All token movements use **`SafeERC20`** and follow **checks-effects-interactions** under **`ReentrancyGuard`** (state updated before external calls).
- Frontend (`modules/market/`): 2-step buy (approve + purchase) or one-step permit, confirm, cancel.

## Events & errors
- Events: `ItemPurchased(id, buyer)`, `DeliveryConfirmed(id, seller, amount)`, `PurchaseCancelled(id, buyer)`, `Paused/Unpaused`.
- Errors: `NotAvailable`, `SelfPurchase`, `NotPending`, `NotBuyer`, `TimeoutNotReached`, `EnforcedPause`, `ReentrancyGuardReentrantCall`.

## Threat model (Security)
| Threat | Mitigation |
|--------|------------|
| Reentrancy on token transfer | `nonReentrant` + checks-effects-interactions on every token path |
| Self-purchase / wrong status | `SelfPurchase` / `NotAvailable` / `NotPending` checks |
| Seller never delivers | buyer `cancelPurchase` after `CANCELLATION_TIMEOUT` (trustless refund) |
| Non-compliant ERC-20 returns | `SafeERC20` (`safeTransfer` / `safeTransferFrom`) |
| Operating during an incident | `Pausable` (`whenNotPaused`) owner emergency stop |
| Approval front-running | prefer `purchaseWithPermit` (signature) over `approve` |

## Tests (`test/Escrow.t.sol`)
purchase escrows tokens · self-purchase revert · confirm pays seller · cancel-before-timeout revert · cancel-after-timeout refunds buyer · purchase-while-paused revert · `purchaseWithPermit`.

## TODO checklist
- [ ] step-indicator UI · [ ] skip `approve` if allowance sufficient · [ ] surface the cancellation countdown.

> Ratings live in **Slice 4 / `Reputation.sol`** (member4). This slice is **escrow only**: purchase (incl. `purchaseWithPermit`), confirm, cancel-after-timeout.

## Walkthrough
📸 Slice-3 validation (approve → purchase → confirm/cancel) on Local Anvil + Hosted Sepolia: follow Slice 1's dual-network pattern in [`network-tests.md`](network-tests.md). CLI reference: [`PROCEDURES.md`](PROCEDURES.md).
