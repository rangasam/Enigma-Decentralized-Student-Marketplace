# Study Guide & Reflective Outline — Decentralized Student Marketplace

## Concepts demonstrated → lesson mapping
| This prototype | Concept | Source PDF |
|----------------|---------|-----------|
| EnigCredit = OZ ERC-20 + Ownable mint | Token economics, ERC-20 with OpenZeppelin | Ethereum-Token §ERC-20/OZ |
| approve → transferFrom escrow | Allowance security, pull-payments | Ethereum-Token §Allowance Security |
| ReentrancyGuard + CEI on escrow | Reentrancy & external-call safety | SmartContractSecurity; Solidity Security |
| confirm/cancel timeout | Trustless dispute resolution | Ethereum-Token §Secure Token Engineering |
| on-chain ratings + events | Events & app integration | Ethereum-Token §Events |
| fuzz + invariant tests | Testing token properties | Ethereum-Token §Testing; Foundry |

## Approach: Design → Harden → Assess
1. **Design:** ERC-20 credit + escrow marketplace from OZ components; roles = Owner(mint)/Seller/Buyer.
2. **Harden:** access control, CEI + ReentrancyGuard on every token path, timeout refund, rating guards; fuzz + invariants.
3. **Assess:** EthTrust [S]/[M]/[Q] (`SECURITY_ASSURANCE.md`), Slither + human review, report.

## Further study / reading
ERC-20 storage anatomy · ERC-20 with OpenZeppelin · allowance security (ERC-2612 permit) · events & logs ·
access-control design · testing token contracts · token security properties · ABI & app integration · web3 (ethers.js) · deployment & verification.
Refs: Ethereum.org token standards · EIPs · Solidity docs · OpenZeppelin Contracts + Access Control · EEA EthTrust v3 + Checklist · OWASP SCSVS/SCSTG/SCWE · Slither · Foundry fuzz/invariant.
Course PDFs: `resources/applied-blockchain-technology/lab2/` (Ethereum-Token, SmartContractSecurity, smartContractDev, Foundations, Consensus, bitcoin).

| Reputation.sol (member4) | On-chain reputation, reads cross-contract sale state | Ethereum-Token §Events; SmartContractSecurity |
