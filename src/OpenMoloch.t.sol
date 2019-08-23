pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./OpenMoloch.sol";

contract OpenMolochTest is DSTest {
    OpenMoloch moloch;

    function setUp() public {
        moloch = new OpenMoloch();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
