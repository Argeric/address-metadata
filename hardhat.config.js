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
    // conflux config start->
    conflux: {
      url: "https://evmtestnet.confluxrpc.com"
    },
    // conflux config end->

    /*// goerli config start->
    goerli: {
      url: 'https://rpc.ankr.com/eth_goerli'
    }
    // goerli config end->*/
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    // conflux config start->
    apiKey: {
      conflux: "YOUR_CONFLUXSCAN_API_KEY"
    },
    customChains: [
      {
        network: "conflux",
        chainId: 71,
        urls: {
          apiURL: "https://evmapi-testnet.confluxscan.net/api",
          browserURL: "https://evmtestnet.confluxscan.net"
        }
      }
    ],
    // conflux config end->

    /*// goerli config start->
    apiKey: {
      goerli: "W3HFCB87IWVV6PK7ITW8287FAU367ESMVA"
    },
    customChains: [
      {
        network: "goerli",
        chainId: 5,
        urls: {
          apiURL: "https://api-goerli.etherscan.io/api",
          browserURL: "https://goerli.etherscan.io"
        }
      }
    ]
    // goerli config end->*/
  },
};