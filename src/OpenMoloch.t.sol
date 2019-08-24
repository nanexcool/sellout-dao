pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./OpenMoloch.sol";

contract FakeUser {
    WethLike weth;

    constructor(WethLike weth_) public {
        weth = weth_;
    }

    function approve(address guy, uint256 wad) external {
        weth.approve(guy, wad);
    }
}

contract Hevm {
    function warp(uint256) public;
}

contract OpenMolochTest is DSTest {
    MolochLike dao;
    OpenMoloch om;
    WethLike weth;
    GemLike gem;
    FakeUser u;
    Hevm hevm;

    function () external payable {

    }

    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        dao = MolochLike(0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1);
        weth = WethLike(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        gem = GemLike(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        u = new FakeUser(weth);
        om = new OpenMoloch(dao, gem);
    }

    function test_basic_sanity() public {
        uint256 prop = 95;

        // hand over control to the Sellout proxy
        dao.updateDelegateKey(address(om));

        // uint256 top = om.top();
        // emit log_named_uint('top', top);

        // assertEq(m.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 0);
        // om.vote(prop, 1);
        // assertEq(m.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 1);

        assertEq(weth.balanceOf(address(this)), 0);

        weth.deposit.value(100 ether)();
        weth.transfer(address(om), 15 ether);

        assertEq(weth.balanceOf(address(om)), 15 ether);

        om.make();

        assertEq(weth.balanceOf(address(om)), 5 ether);

        // warp one period duration
        hevm.warp(now + dao.periodDuration());

        assertEq(dao.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 0);
        om.vote(prop, 1);
        assertEq(dao.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 1);

        assertEq(address(om).balance, 0);

        address payable omg = address(om);

        assertEq(address(omg).balance, 0);

        omg.transfer(1 ether);

        assertEq(address(omg).balance, 1 ether);

        om.take();

        assertEq(address(om).balance, 0);
        assertEq(weth.balanceOf(address(om)), 0);
        assertEq(weth.balanceOf(address(this)), 90 ether);

        assertTrue(true);
    }
}
