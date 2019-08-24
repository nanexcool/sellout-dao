pragma solidity ^0.5.10;

contract MolochLike {
    function updateDelegateKey(address) external;
    function submitVote(uint256, uint8) external;
    function submitProposal(address, uint256, uint256, string calldata) external;
    function getProposalQueueLength() external view returns (uint256);
    function getMemberProposalVote(address, uint256) external view returns (uint256);
    function proposalDeposit() external view returns (uint256);
    function periodDuration() external view returns (uint256);
}

contract WethLike {
    function deposit() external payable;
    function approve(address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract GemLike {
    function approve(address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract OpenMoloch {
    address    public owner;
    MolochLike public dao;
    GemLike    public gem;

    mapping (uint256 => address) public hat;

    modifier auth() {
        require(msg.sender == owner, "nope");
        _;
    }

    constructor(MolochLike dao_, GemLike gem_) public {
        owner = msg.sender;
        dao = dao_;
        gem = gem_;
    }

    function () external payable {

    }

    function top() external view returns (uint256) {
        return dao.getProposalQueueLength();
    }

    function vote(uint256 wat, uint8 val) external {
        dao.submitVote(wat, val);
    }

    function make() external auth {
        gem.approve(address(dao), dao.proposalDeposit());
        dao.submitProposal(address(this), 0, 1, "This is my proposal");
    }

    function take() external auth {
        msg.sender.transfer(address(this).balance);
        gem.transfer(owner, gem.balanceOf(address(this)));
    }
}

// contract OpenMolochFactory {

// }
