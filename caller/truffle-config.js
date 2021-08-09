const LoomTruffleProvider = require('loom-truffle-provider')

const path = require('path')
const fs = require('fs')

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "5777",       // Any network (default: none)
  },
    extdev: {
      provider: function () {
        const privateKey = fs.readFileSync(path.join(__dirname, 'caller_private_key'), 'utf-8')
        const chainId = 'extdev-plasma-us1'
        const writeUrl = 'wss://extdev-plasma-us1.dappchains.com/websocket'
        const readUrl = 'wss://extdev-plasma-us1.dappchains.com/queryws'
        return new LoomTruffleProvider(chainId, writeUrl, readUrl, privateKey)
      },
      network_id: '9545242630824'
    }
  },
  compilers: {
    solc: {
      version: '0.8.0'
    }
  }
}