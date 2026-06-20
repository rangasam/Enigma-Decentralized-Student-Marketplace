# Slice 4 — Reputation / Ratings (`Reputation.sol`)
> Owner: member4 · Branch: `feature/member4-reputation` · dedicated contract reading Marketplace state.

## What it does
After a trade is **Sold** (buyer confirmed delivery), the buyer rates the seller 1–5, once per listing.
Averages are stored as raw totals and computed off-chain (gas-efficient).

## Functions
- `rateUser(listingId, rating)` — only the listing's buyer, only when `Status.Sold`, 1–5, once (`AlreadyRated`).
- `getAverageRating(user)` → `(total, count)`.

## Design
`Reputation` holds the rating ledger and reads `Marketplace.getListing(id)` to verify the completed sale
(seller, buyer, status). This keeps escrow (member3) and reputation (member4) as clean, separate verticals.

## Tests (`test/Reputation.t.sol`)
rate after sold · rate twice reverts · non-buyer reverts · bad rating reverts · unsold reverts.

## TODO checklist
- [ ] star-picker widget · [ ] show avg on listing cards (batch-read) · [ ] reputation analytics view.
