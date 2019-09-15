import React from 'react';
import { ethers } from 'ethers';
import logo from './moloch.png';
import './App.css';

window.ethers = ethers
const molochAbi = require('./abi/moloch.json')
const selloutAbi = require('./abi/sellout.json')

class App extends React.Component {
  state = {
    sold: false,
    hat: null
  }
  
  async componentDidMount() {
    // let provider = ethers.getDefaultProvider('homestead');
  let provider = new ethers.providers.Web3Provider(window.web3.currentProvider);

  let moloch = new ethers.Contract('0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1', molochAbi, provider);
  window.moloch = moloch
  let sellout = new ethers.Contract('0x829fE69F1feA3305C1aa0C1873b22835b87200d6', selloutAbi, provider);
  window.sellout = sellout
  
  let loop = async () => {
    let sold = await sellout.sold()
    let hat = await sellout.hat()
    this.setState({sold, hat})
  }

  setInterval(loop, 10000);
  }

  render() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Sell your voting power! <br />
          Works on any Moloch-like DAO
        </p>
        <h3>SOLD to 0x2AF412...</h3>
        <a
          className="App-link"
          href="https://twitter.com/nanexcool/status/1168640894947471360"
          target="_blank"
          rel="noopener noreferrer"
        >
          Read the story
        </a>
        <p>
          The initial trial of the SelloutDAO was a success! Stay tuned for version 2 ;)
        </p>
        <a
          className="App-link"
          href="https://github.com/nanexcool/sellout-dao"
          target="_blank"
          rel="noopener noreferrer"
        >
          Source Code
        </a>
        <p>Made by Mariano Conti (@nanexcool) for @ETHBerlin</p>
      </header>
    </div>
  );

  }
}

export default App;
