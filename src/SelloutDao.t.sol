pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./SelloutDao.sol";

contract Hevm {
    function warp(uint256) public;
}

contract SelloutDaoTest is DSTest {
    MolochLike dao;
    SelloutDao om;
    WethLike weth;
    GemLike gem;
    Hevm hevm;

    function () external payable {

    }

    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        dao = MolochLike(0x1fd169A4f5c59ACf79d0Fd5d91D1201EF1Bce9f1);
        weth = WethLike(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        gem = GemLike(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function test_after() public {
        om = SelloutDao(0x829fE69F1feA3305C1aa0C1873b22835b87200d6);
        
    }

    function test_basic_sanity() public {
        om = new SelloutDao(dao);

        // hand over control to the Sellout proxy
        dao.updateDelegateKey(address(om));

        assertTrue(!om.sold());

        address payable omg = address(om);

        assertEq(address(omg).balance, 0);

        assertEq(om.hat(), address(0x0));

        omg.call.value(1 ether).gas(100000)("");

        assertEq(address(omg).balance, 1 ether);

        assertTrue(om.sold());
        assertEq(om.hat(), address(this));

        assertEq(weth.balanceOf(address(this)), 0);

        weth.deposit.value(100 ether)();
        weth.transfer(address(om), 15 ether);

        assertEq(weth.balanceOf(address(om)), 15 ether);

        om.make(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, 0, 1, "Hola");

        uint256 prop = om.prop();
        assertEq(prop, 96);

        assertEq(weth.balanceOf(address(om)), 5 ether);

        // warp one period duration
        hevm.warp(now + dao.periodDuration());

        assertEq(dao.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 0);
        om.vote(1);
        assertEq(dao.getMemberProposalVote(0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89, prop), 1);

        om.take();

        assertEq(address(om).balance, 0);
        assertEq(weth.balanceOf(address(om)), 0);
        assertEq(weth.balanceOf(address(this)), 90 ether);
    }
}
