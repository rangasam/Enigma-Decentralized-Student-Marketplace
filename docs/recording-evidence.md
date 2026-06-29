# Recording Test Evidence — Members 2–4

How to capture and file your slice's validation evidence, the **same way Slice 1 did it**
(see [`resources/token-wallet/`](resources/token-wallet/) for the model). Each slice needs **two**
things: (1) **CLI test output** and (2) **GUI screenshots** at the key steps from
[`network-tests.md`](network-tests.md) (§C local Anvil, §D hosted Sepolia).

## 1 · CLI evidence (everyone — 30 seconds)
Run your slice's suite and paste the passing `Suite result: ok` summary into your PR / report:
```bash
forge test --match-contract ListingsTest   -vv    # member 2
forge test --match-contract EscrowTest      -vv    # member 3
forge test --match-contract ReputationTest  -vv    # member 4
```

## 2 · GUI screenshots to capture
Follow the §C2 (Anvil) / §D2 (Sepolia) GUI steps and screenshot each point below. Save the files into
the folder shown, using the **exact filenames** (each folder has a manifest README).

### Member 2 — Listings → `docs/resources/listings/`
| File | Shows |
|---|---|
| `listings-create.png` | create-listing form filled → MetaMask **Confirm** |
| `listings-available.png` | the new listing under **Available** |
| `listings-cancel.png` | *(optional)* seller cancels an Available listing |

### Member 3 — Escrow / Trade → `docs/resources/escrow/`
| File | Shows |
|---|---|
| `escrow-purchase.png` | **Approve + Purchase** → listing becomes **Pending** (price held in escrow) |
| `escrow-confirm.png` | **Confirm delivery** → **Sold**, seller paid |
| `escrow-etherscan.png` | *(Sepolia)* Etherscan showing escrow custody / transfer to seller |

### Member 4 — Reputation → `docs/resources/reputation/`
| File | Shows |
|---|---|
| `reputation-rate.png` | submit a **1–5★** rating → MetaMask **Confirm** |
| `reputation-average.png` | the seller's **average** updated in the UI |

> Capturing on **both** networks? Prefix the hosted ones with `sepolia-`
> (e.g. `sepolia-escrow-confirm.png`) and keep the Anvil ones as-is.

## 3 · Redaction rules (these pages are public)
- Fully mask any **API keys / RPC URLs / private keys / seed phrases / PII** — a partial blur is not enough.
- Public **Anvil** dev addresses (`0xf39F…`, `0x5FbD…`) are well-known test accounts — safe to show.
- If a real secret was ever visible in a capture, **rotate it** — blurring the image doesn't undo exposure.

## 4 · Filing it
1. Drop the PNGs into `docs/resources/<your-slice>/`.
2. Open a PR (or ping the tech lead). The images get embedded into **`network-tests.md` §C/§D** and your
   row of the README **Contribution statement** as:
   ```markdown
   ![caption](resources/<your-slice>/<file>.png)
   ```
