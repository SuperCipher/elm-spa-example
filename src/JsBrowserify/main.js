// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
const flags = null

// Start our Elm application
const app = Elm.Main.init({ flags: flags })

// Ports go here
// https://guide.elm-lang.org/interop/ports.html


const randomBytes = require('randombytes')

const entropy16 = randomBytes(16)
console.log('ENTROPY16', entropy16)