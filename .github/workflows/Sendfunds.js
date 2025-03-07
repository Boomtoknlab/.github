const Web3 = require('web3');
const { toWei } = require('web3-utils');

// Replace with your Binance RPC endpoint
const rpcURL = 'https://virtual.binance.rpc.tenderly.co/add95b93-f1d4-4d71-a63d-0e89712c101d';
const web3 = new Web3(new Web3.providers.HttpProvider(rpcURL));

// Replace with your private key (DO NOT SHARE THIS)
const privateKey = '0x21fa1bf8dc9793971382c89776e623f9177e4e30b24537d1b2f9383dc46a00c6';

// Replace with your wallet address and the exchange wallet address
const myAddress = '0x97293CeAB815896883e8200AEf5a4581a70504b2';
const exchangeWallet = '0xf0e058a2c2c490fe4d8fecb9fd69f9b4f18a9140';

async function sendFunds() {
    const nonce = await web3.eth.getTransactionCount(myAddress, 'latest'); // get latest nonce

    const transaction = {
        'to': exchangeWallet, // transaction recipient
        'value': toWei('0.1', 'ether'), // amount to send in Wei
        'gas': 2000000, // gas limit
        'nonce': nonce
    };

    const signedTx = await web3.eth.accounts.signTransaction(transaction, privateKey);

    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(error, hash) {
        if (!error) {
            console.log("Transaction hash:", hash);
        } else {
            console.error("Transaction failed:", error);
        }
    });
}

sendFunds().catch(console.error);
