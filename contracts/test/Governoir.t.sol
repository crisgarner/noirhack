// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Governoir} from "../src/Governoir.sol";
import {Token} from "../src/Token.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract GovernoirTest is Test {
    Governoir public governoir;
    Token public token;
    TimelockController public timelock;

    function setUp() public {
        token = new Token();
        address[] memory proposers = new address[](1);
        proposers[0] = address(this);
        address[] memory executors = new address[](1);
        executors[0] = address(this);
        timelock = new TimelockController(
            1 days,
            proposers,
            executors,
            address(0)
        );
        governoir = new Governoir(token, timelock);
    }

    function test_Propose() public {
        bytes memory data = abi.encodeWithSelector(
            Token.mint.selector,
            address(this),
            100 ether
        );
        address[] memory targets = new address[](1);
        targets[0] = address(token);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = data;

        governoir.propose(targets, values, calldatas, "Test proposal");
    }
}
