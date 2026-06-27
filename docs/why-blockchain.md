# Why This Project — and Why Blockchain

This page explains **why we chose the Enigma marketplace**, **why it matters**, **why a public blockchain is the correct solution**, and **how the project meets the standard suitability and security criteria** that distinguish a well-justified blockchain application from one that merely uses the technology.

## Why this project, and why it's important
Online marketplaces are central to how communities exchange goods, yet they concentrate **trust, custody, and dispute resolution** in a single intermediary that charges fees, can fail, and must be trusted not to misbehave. For a campus community trading low-value items, that intermediary is both costly and unnecessary. Enigma asks whether a marketplace's core trust functions — **value, listings, escrow, and reputation** — can instead be enforced entirely by public smart contracts, making custody, settlement, and reputation **auditable** while removing the single point of failure. The pattern is broadly important: escrowed peer-to-peer commerce recurs in resale, freelance milestones, and rental deposits.

## Why blockchain is the correct solution
We apply the widely-cited suitability test of **Wüst & Gervais, *"Do you need a blockchain?"***. A public blockchain is warranted when **all** of the following hold — and Enigma satisfies each:

| Criterion | Enigma |
|---|---|
| State must be stored | Balances, listings, escrow, and reputation are persistent shared state. |
| Multiple parties write | Many buyers and sellers create listings, purchase, confirm, and rate. |
| Writers are mutually distrusting | Buyers and sellers are strangers with conflicting incentives. |
| No trusted third party is desired | We explicitly remove the escrow company / platform operator. |
| Public verifiability is valuable | Auditable custody and tamper-evident reputation is the whole point. |

Because every criterion is met, a **public, permissionless** chain — not a database or a private ledger — is the appropriate foundation.

## How it satisfies blockchain compatibility / suitability metrics
The design maps directly onto the properties that justify a public blockchain:

- **Disintermediation** — escrow and settlement are enforced by code, not a platform.
- **Trustlessness** — correctness follows from contract logic and consensus, not operator honesty.
- **Immutability & auditability** — every state transition emits an event on an append-only ledger.
- **Transparency** — anyone can verify balances and trade outcomes.
- **Availability** — no single point of failure.
- **Interoperability** — ENGC is a standard **ERC-20** (with **EIP-2612** permit), usable by any wallet, explorer, or exchange — it composes with the wider Ethereum ecosystem rather than a walled garden.

## Why it's a usable, real-world use case
The same **escrow + reputation** pattern underlies online resale, freelance/milestone payments, and rental deposits. The student marketplace is a concrete, **low-risk instantiation** that we deploy and exercise on the public **Sepolia** testnet and a local **Anvil** chain — demonstrating feasibility end-to-end, not just in theory.

## How it meets security standards (what sets it apart)
What distinguishes Enigma among comparable projects is **rigor**: it is built **exclusively on audited standards**, its security properties are **explicit and enforced**, and every claim is backed by **reproducible evidence**.

- **Audited libraries** — OpenZeppelin v5.1.0 (`ERC20`, `ERC20Permit`, `Ownable`, `ReentrancyGuard`, `SafeERC20`, `Pausable`).
- **Standards** — EIP-20 token model + EIP-2612 signature approvals.
- **Reentrancy protection** — checks-effects-interactions ordering plus `ReentrancyGuard` and `SafeERC20`.
- **Least privilege** — owner-only issuance; a capped, rate-limited demo faucet adds no arbitrary-mint power.
- **Verification** — unit, fuzz, and invariant tests plus **Slither** static analysis run as required CI on every pull request.

See the [Security Architecture & Standards](security.html) page for the full technical breakdown, and the [Publications](publications.html) page for the IEEE paper that formalizes this analysis.
