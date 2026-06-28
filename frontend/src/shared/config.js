// Network config. GitHub Actions can replace the Sepolia placeholders during deployment.
// Local development falls back to the hardcoded values below.
export const NETWORKS = {
  anvil: {
    label: "Local Anvil (dev)", chainId: 31337, rpcUrl: "http://127.0.0.1:8545", explorer: "",
    addresses: { EnigCredit: "0x5FbDB2315678afecb367f032d93F642f64180aa3", Marketplace: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512", Reputation: "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0" },
  },
  sepolia: {
    label: "Sepolia (hosted demo)", chainId: 11155111, rpcUrl: "https://ethereum-sepolia-rpc.publicnode.com", explorer: "https://sepolia.etherscan.io",
    addresses: {
      EnigCredit: "0xdeacBb317c52407EFD2c95F682F82EF1B5ACdeAF",
      Marketplace: "0xfF7F1ff4278451Af398c32fFB59845D9bE05246e",
      Reputation: "0x8c22D172b8a66c57071D281246eb69EE1eb7A63C",
    },
  },
};
export const DEFAULT_NETWORK = "anvil";
