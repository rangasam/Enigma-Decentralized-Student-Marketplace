# Slice 4 — Reputation / Ratings (`Reputation.sol`)
> Owner: **member4** (Omair Naeem) · Branch: `feature/member4-reputation` · dedicated contract that reads Marketplace state.

## What it does
After a trade is **Sold** (buyer confirmed delivery), each side may rate the other **1–5**, **once per direction per listing**. Totals are stored on-chain; the average is computed off-chain (gas-efficient) or via a scaled helper.

## Functions
- `rateUser(listingId, rating)` — **bidirectional**: the **buyer rates the seller** (flag `buyerRatedSeller`) *or* the **seller rates the buyer** (flag `sellerRatedBuyer`). Requires `Status.Sold`, `1 ≤ rating ≤ 5`, caller is the listing's buyer or seller, and not already rated in that direction. Emits `RatingSubmitted`.
- `getAverageRating(user)` → `(total, count)` raw accumulators (client divides to avoid truncation).
- `getAverageRatingScaled(user)` → average **×100** (e.g. `450` = 4.50 ★), `0` when no ratings.
- `buyerRatedSeller(id)` / `sellerRatedBuyer(id)` — public flags for the UI.

## Design
`Reputation` holds the rating ledger and reads `Marketplace.getListing(id)` to authenticate the rater (seller, buyer, status) — keeping escrow (member3) and reputation (member4) as clean, separate verticals with no shared mutable state. Guarded by `ReentrancyGuard`.

## Events & errors
- Event: `RatingSubmitted(rater, rated, rating, listingId)`.
- Errors: `NotSold`, `BadRating`, `Unauthorized` (not buyer/seller), `AlreadyRated`.

## Tests (`test/Reputation.t.sol`)
rate after Sold (total/count + flag) · rate-twice revert (`AlreadyRated`) · non-participant revert (`Unauthorized`) · bad rating revert (`BadRating`) · unsold revert (`NotSold`).

## Threat model (Security)
| Threat | Mitigation |
|--------|------------|
| Rating manipulation by outsiders | `Unauthorized` — only the listing's buyer or seller |
| Score inflation / double-rating | `buyerRatedSeller` / `sellerRatedBuyer` flags + `AlreadyRated` |
| Rating an incomplete trade | `NotSold` — only after `Status.Sold` |
| Out-of-range scores | `BadRating` — enforce 1–5 |
| Reentrancy via cross-contract read | `nonReentrant`; only a `view` external call (`getListing`) |

## TODO checklist
- [ ] star-picker widget · [ ] show avg on listing cards (batch read) · [ ] reputation analytics view.

## Walkthrough
📸 Slice-4 validation (sell → buy → confirm → rate) on Local Anvil + Hosted Sepolia: follow Slice 1's dual-network pattern in [`network-tests.md`](network-tests.html). CLI reference: [`PROCEDURES.md`](procedures.html).
