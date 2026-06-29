# Slice 2 — Listings (`Marketplace.sol`)
> Owner: **member2** (vp2244) · Branch: `feature/member2-listings` · co-owns `Marketplace.sol` with member3 (escrow).

## Implements
- `createListing(title, category, condition, priceInTokens, imageUrl)` → returns a monotonically increasing `id` (`nextListingId++`), stores a `Listing` (seller, price, metadata, `Status.Available`), emits `ListingCreated`. Validates: non-empty title (`EmptyTitle`), positive price (`BadPrice`). `whenNotPaused`.
- `getListing(id)` → `Listing` struct · `totalListings()` → `nextListingId` (reads for the UI).
- `cancelListing(id)` — **seller** removes an **Available** listing → `Status.Cancelled`, emits `ListingCancelled` (reverts `NotSeller` / `NotAvailable`).
- Frontend (`modules/listings/`): create-listing form + browse **Available** listings.

## Events & errors
- Events: `ListingCreated(id, seller, title, priceInTokens)`, `ListingCancelled(id, seller)`.
- Errors: `EmptyTitle`, `BadPrice`, `NotSeller`, `NotAvailable`.

## Tests (`test/Listings.t.sol`)
create stores + returns id · empty-title revert · zero-price revert · ids increment · seller cancels Available · non-seller cancel revert · cancel non-Available revert.

## Threat model (Security)
| Threat | Mitigation |
|--------|------------|
| Empty / malformed listing | `EmptyTitle` + `BadPrice` input validation |
| Cancel someone else's listing | `NotSeller` (only `listing.seller`) |
| Cancel a sold/pending item | `NotAvailable` (only `Status.Available`) |
| Listing spam while paused | `whenNotPaused` (owner emergency stop) |

## TODO checklist
- [ ] search + category filter + sort · [ ] render avg rating per listing (read Slice 4) · [ ] image upload/IPFS.

## Walkthrough
📸 Slice-2 validation (create → browse → cancel) on Local Anvil + Hosted Sepolia: follow Slice 1's dual-network pattern in [`network-tests.md`](network-tests.md). CLI reference: [`PROCEDURES.md`](PROCEDURES.md).
