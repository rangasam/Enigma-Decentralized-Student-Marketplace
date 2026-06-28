// Network config. GitHub Actions can replace the Sepolia placeholders during deployment.
// Local development falls back to the hardcoded values below.
export const NETWORKS = {
  anvil: {
    label: "Local Anvil (dev)", chainId: 31337, rpcUrl: "http://127.0.0.1:8545", explorer: "",
    addresses: { EnigCredit: "0x5fbdb2315678afecb367f032d93f642f64180aa3", Marketplace: "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512", Reputation: "0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0" },
  },
  sepolia: {
    label: "Sepolia (hosted demo)", chainId: 11155111, rpcUrl: "https://ethereum-sepolia-rpc.publicnode.com", explorer: "https://sepolia.etherscan.io",
    addresses: {
      EnigCredit: "0x7F2daef2De0aDb592d2BfF824e7D0bF0d4Cdfea5",
      Marketplace: "0x1AC805Bd494e2B1393AA2EB9D4ab383A6ced6929",
      Reputation: "0xcA7883465a699295C6Cb0d577ec5D4A620459e9F",
    },
  },
};
export const DEFAULT_NETWORK = "anvil";
