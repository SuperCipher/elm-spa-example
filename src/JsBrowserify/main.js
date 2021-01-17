const randomBytes = require('randombytes')
const base64url = require('base64url')
// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
const flags = null

// Start our Elm application
const app = Elm.Main.init({ flags: flags })

// Ports go here
// https://guide.elm-lang.org/interop/ports.html

// uncomment to select network
// const NETWORK = 'mainnet'
// const NETWORK = 'testnet'
const NETWORK = 'regtest'

// REST API servers.
const MAINNET_API_FREE = 'https://free-main.fullstack.cash/v3/'
const TESTNET_API_FREE = 'https://free-test.fullstack.cash/v3/'
const REGTEST_API_FREE = 'http://128.199.203.157:3000/v3/'
const lang = 'english'
// bch-js-examples require code from the main bch-js repo
const BCHJS = require('bch-js-reg')

// Instantiate bch-js based on the network.
let bchjs
let regtest
switch (NETWORK) {
  case 'mainnet':
    bchjs = new BCHJS({ restURL: MAINNET_API_FREE })
    regtest = false
    break
  case 'testnet':
    bchjs = new BCHJS({ restURL: TESTNET_API_FREE })
    regtest = false
    break
  case 'regtest':
    bchjs = new BCHJS({ restURL: REGTEST_API_FREE })
    regtest = true
    break
  default:
    bchjs = new BCHJS({ restURL: REGTEST_API_FREE })
    regtest = true
}

function newBase64RootSeed () {
  const entropy16 = randomBytes(16)
  return entropy16.toString('base64')
}

function decodedBase64 () {
  return Buffer.from(base64RootSeed.toString('base64'), 'base64')
}



const base64RootSeed = newBase64RootSeed()
console.log('BASE64ROOTSEED', base64RootSeed)
const rootSeed = Buffer.from(base64RootSeed.toString('base64'), 'base64')
console.log('ROOTSEED', rootSeed)
const mnemonic = bchjs.Mnemonic.fromEntropy(rootSeed, bchjs.Mnemonic.wordLists()[lang])
console.log('MNEMONIC', mnemonic)
const seedBuffer = bchjs.Mnemonic.toSeed(mnemonic)
console.log('SEEDBUFFER', seedBuffer)
const masterHDNode = bchjs.HDNode.fromSeed(rootSeed, NETWORK)
// console.log('MASTERHDNODE', masterHDNode)
const childNode0 = masterHDNode.derivePath(`m/44'/145'/0'/0/0`)
console.log('CHILDNODE0', childNode0)
const cashAddress0 = bchjs.HDNode.toCashAddress(childNode0, regtest)
console.log('CASHADDRESS', cashAddress0)



const encodedBase64RootSeed = base64url.fromBase64(rootSeed)
console.log('ENCODEDBASE64ROOTSEED', encodedBase64RootSeed)
const decodedBase64RootSeed = base64url.toBase64(encodedBase64RootSeed)
console.log('DECODEDBASE64ROOTSEED', decodedBase64RootSeed)
rootSeed == decodedBase64RootSeed
console.log('ROOTSEED == DECODEDBASE64ROOTSEED', rootSeed == decodedBase64RootSeed)
