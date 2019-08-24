import React from 'react';
import { ethers } from 'ethers';

class Proposal extends React.Component {

  constructor(props) {
    super()
    this.provider = props.provider
  }

  componentDidMount() {
    this.provider.getBalance('0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1').then((balance) => {
      let etherString = ethers.utils.formatEther(balance);
      console.log("Balance: " + etherString);
    });
  }

  render() {
    return (
      <div>
        <h2>Proposal</h2>
      </div>
    )
  }
}

export default Proposal
