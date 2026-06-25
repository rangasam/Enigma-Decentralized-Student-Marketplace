# 📄 Publications

## Enigma: A Decentralized Student Marketplace with Token Credits, On-Chain Escrow, and Reputation

A 2-page **IEEE** conference paper describing the system, written as **modular LaTeX**: `main.tex`
consolidates one folder per section, with a **section per slice owned by each member** — so everyone
edits only their part.

### Read / review (no LaTeX needed)
Every section has a Markdown mirror:

- [Abstract](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/abstract/abstract.md) · [Introduction](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/introduction/introduction.md) · [Architecture](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/architecture/architecture.md)
- [Slice 1 — Token + Wallet (M1)](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/slice1_token/slice1_token.md) · [Slice 2 — Listings (M2)](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/slice2_listings/slice2_listings.md)
- [Slice 3 — Escrow + Ratings (M3)](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/slice3_escrow/slice3_escrow.md) · [Slice 4 — Reputation (M4)](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/slice4_reputation/slice4_reputation.md)
- [Evaluation](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/evaluation/evaluation.md) · [Conclusions](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/blob/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications/conclusions_future_work/conclusions_future_work.md)

### Source & compiled PDF
- **LaTeX source + README:** [`publications/` folder](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/tree/publications/publications/Enigma-Decentralized-Student-Marketplace-Publications)
- **Compiled PDF:** builds in CI on every push — download the latest **`enigma-paper-pdf`** artifact from
  the [Build paper workflow](https://github.com/rangasam/Enigma-Decentralized-Student-Marketplace/actions/workflows/build-paper.yml). *(Overleaf: upload the folder, set the main document to `main.tex`.)*

### Per-section ownership
| Section | Owner | Status |
| --- | --- | --- |
| Slice 1 — Token + Wallet | Member 1 | drafted (validated: 7/7 tests, Anvil + Sepolia) |
| Slice 2 — Listings | Member 2 | design draft — `[refine]` |
| Slice 3 — Escrow + Ratings | Member 3 | design draft — `[refine]` |
| Slice 4 — Reputation | Member 4 | design draft — `[refine]` |

> Architecture, Slice 1, and Evaluation are drafted from validated results; Slices 2–4 are accurate
> design-level drafts for their owners to complete.
