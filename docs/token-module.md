# Slice 1 — Token + Wallet (`EnigCredit.sol`)
> Owner: **member1** (Ranga Sam) · Branch: `feature/member1-token` · OpenZeppelin ERC-20 + Permit + Burnable + Ownable.

## Implements
- `EnigCredit` ERC-20 — name *EnigCredit*, symbol **ENGC**, 18 decimals, **1,000,000** initial supply minted to the deployer (owner).
- `mint(to, amount)` — **owner-only** (`onlyOwner`); faculty/owner airdrops demo credits. Non-owner calls revert `OwnableUnauthorizedAccount`.
- `faucet()` — **public, capped** self-serve **1,000 ENGC** with a **1-hour per-wallet cooldown** (`FaucetCooldown`). Demo affordance only; does **not** grant arbitrary minting.
- Inherited: `transfer` / `approve` / `allowance`, `permit` (EIP-2612 gasless approval), `burn` / `burnFrom`.
- Frontend (`modules/token/`): connect wallet (identity), live ENGC balance, **Get 1,000 ENGC** faucet card, owner **Mint** form.

## Events & errors
- Events: `Transfer`, `Approval`, `FaucetClaimed`.
- Errors: `OwnableUnauthorizedAccount`, `FaucetCooldown(availableAt)`.

## Tests (`test/EnigCredit.t.sol`) — **10/10**
metadata · initial-supply-to-deployer · owner mint · non-owner mint revert · transfer · permit · burn reduces supply · faucet mints · faucet cooldown revert · faucet again after cooldown.

## Threat model (Security)
| Threat | Mitigation |
|--------|------------|
| Unauthorized issuance | `Ownable` owner-only `mint`; faucet is capped + rate-limited |
| Faucet drain / spam | fixed 1,000 ENGC per claim, 1-hour cooldown per wallet |
| Approval front-running | prefer **EIP-2612 `permit`** (signature) over `approve` |

## TODO checklist
- [x] faucet for demo top-ups · [ ] balance auto-refresh on account/chain change · [ ] "Switch to Sepolia" helper.

## Walkthrough
📸 Validate mint / owner / faucet / balance on **both networks** (Local Anvil + Hosted Sepolia), step by step with screenshots: [`network-tests.md`](network-tests.html). CLI reference: [`PROCEDURES.md`](procedures.html).
