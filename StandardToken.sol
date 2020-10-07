pragma solidity ^0.7.0;

import "./Token.sol";

contract StandardToken is Token {
    function xfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value &&  _value > 0) {
            
        }
    }
}