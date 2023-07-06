require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: false,
        runs: 200,
      },
      // metadata: {
      //   bytecodeHash: 'none',
      // },
    },
  },
  networks: {
    testnet_evm: {
      url: "http://evmtestnet.confluxrpc.com",
      chainId: 71,
      gas: 10000000,
      gasPrice: 30000000000, // 30G drip
      loggingEnabled: true,
      accounts: [process.env.TESTNET_EVM_PRIVATE_KEY_1]
    },
    testnet_core: {
      chainId: 1,
      loggingEnabled: true,
      url: "http://test-internal.confluxrpc.com",
      accounts: [process.env.TESTNET_CORE_PRIVATE_KEY_1],
    },
    goerli: {
      chainId: 5,
      loggingEnabled: true,
      url: 'https://rpc.ankr.com/eth_goerli'
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      testnet_evm: "YOUR_CONFLUXSCAN_API_KEY",
      testnet_core: "YOUR_CONFLUXSCAN_API_KEY",
      goerli: "W3HFCB87IWVV6PK7ITW8287FAU367ESMVA"
    },
    customChains: [
      {
        network: "testnet_evm",
        chainId: 71,
        urls: {
          apiURL: "https://evmapi-testnet.confluxscan.net/api",
          browserURL: "https://evmtestnet.confluxscan.net"
        }
      },
      {
        network: "testnet_core",
        chainId: 1,
        urls: {
          apiURL: "https://api-testnet.confluxscan.net/api",
          browserURL: "https://testnet.confluxscan.net"
        }
      },
      {
        network: "goerli",
        chainId: 5,
        urls: {
          apiURL: "https://api-goerli.etherscan.io/api",
          browserURL: "https://goerli.etherscan.io"
        }
      }
    ],
  },
};