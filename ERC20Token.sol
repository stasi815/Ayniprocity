pragma solidity ^0.7.0;

import "./StandardToken.sol";

contract ERC20Token is StandardToken {
    function() {
        throw;
    }

    string public name;
    uint256 public decimals;
    string public symbol;
    string public version = 'H1.0';

    function ERC20Token() {
        balances[msg.sender] = 100;
        totalSupply = 100;
        name = "Mink'oin";
        decimals = 18;
        symbol = "MNKA";
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _sender, _value);

        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
            throw;
        } return true;
    }
}