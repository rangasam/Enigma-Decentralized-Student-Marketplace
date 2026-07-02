# Evaluation — Hypothesis and Empirical Evidence

> Markdown mirror of §VII of the final paper. **Updated:** all four slices implemented; gas figures are measured (previously estimates).

## Hypothesis

We hypothesize that the core trust functions of a marketplace — value, listings, escrow, and reputation — can be implemented *entirely on-chain* from audited standard components such that: (H1) no party can violate the safety invariants (only the owner mints; escrowed funds are released only to the seller on buyer confirmation or refunded to the buyer; each completed sale yields at most one rating from its verified buyer); (H2) the system withstands the threat model without bespoke cryptography; and (H3) per-operation cost and confirmation latency remain within practical bounds for a community-scale testnet deployment. We further hypothesize that decomposing the system into four vertical slices allows independent development and evaluation while composing into one correct system.

## Performance metrics

Five defender-relevant axes: **functional correctness** (unit-test pass rate over behaviors and revert conditions); **security robustness** (Slither finding count and the holding of fuzz/invariant properties such as monotonic listing identifiers and no self-purchase); **gas cost** per state-changing operation; **confirmation latency** (time-to-first-confirmation); and **modularity** (independent testability of each slice).

## Methodology

All measurements use the Foundry toolchain. Functional correctness is established with `forge test` over per-slice suites (`EnigCreditTest`, `ListingsTest`, `EscrowTest`, `ReputationTest`); adversarial robustness adds property-based fuzzing and stateful invariant tests (`Invariant.t.sol`). Gas is collected with `forge test --gas-report` (average per call). Static analysis runs Slither in CI on every pull request (currently configured as non-blocking). The contracts are deployed both to a local Anvil chain (chainId 31337) and to the public Sepolia testnet (chainId 11155111), and exercised end-to-end through a dual-network ethers.js web client. The entire pipeline re-runs automatically in CI, making every reported result reproducible from a clean checkout.

## Empirical evidence

All four slices are implemented and their suites pass: **32 of 32 tests** succeed (including the demo faucet and the fuzz/invariant suite), and **Slither reports no high-severity findings**. The owner-only mint, escrow release/refund, and one-rating-per-sale invariants hold; the stateful tests confirm that listing identifiers increase monotonically and that self-purchase is rejected.

### Per-operation gas (`forge test --gas-report`, avg) and confirmation latency

| Operation | Gas | Latency | Notes |
| --- | ---: | ---: | --- |
| `createListing` | ~248,900 | ~12 s | listing write |
| `purchaseItem` | ~111,800 | ~12 s | escrow pull |
| `confirmDelivery` | ~65,600 | ~12 s | release funds |
| `rateUser` | ~80,700 | ~12 s | rating store |
| `mint` | ~38,700 | ~12 s | owner mint |
| `transfer` | ~51,400 | ~12 s | ERC-20 move |
| `burn` | ~33,900 | ~12 s | supply burn |
| `faucet` | ~53,600 | ~12 s | demo mint |

Confirmation latency is one block — roughly 12 s on Sepolia, sub-second on local Anvil — and the measured costs are modest, well under typical block gas limits, confirming hypothesis H3 that the design is practical for community-scale deployment.
