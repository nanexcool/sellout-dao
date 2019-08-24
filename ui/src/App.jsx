import React from 'react';
import { ethers } from 'ethers';
import QRCode from 'qrcode.react';
import Proposal from './Proposal';
import logo from './moloch.png';
import './App.css';

window.ethers = ethers
const molochAbi = require('./abi/moloch.json')

function App() {
  // let provider = ethers.getDefaultProvider('homestead');
  let provider = new ethers.providers.Web3Provider(window.web3.currentProvider);
  let address = "0x72BA1965320ab5352FD6D68235Cc3C5306a6FFA2";

  provider.getBalance(address).then((balance) => {
    let etherString = ethers.utils.formatEther(balance);
    console.log("Balance: " + etherString);
  });
  let moloch = new ethers.Contract('0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1', molochAbi, provider);
  window.moloch = moloch
  moloch.getProposalQueueLength().then((r) => {
    console.log(r.toString())
  })
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Sell your voting power!
        </p>
        <p>
          Works on any Moloch-like DAO
        </p>
        <Proposal provider={provider} />
        <QRCode value="0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1" includeMargin={true} size={384} />
        <a
          className="App-link"
          href="https://github.com/nanexcool"
          target="_blank"
          rel="noopener noreferrer"
        >
          Source Code
        </a>
      </header>
    </div>
  );
}

export default App;
