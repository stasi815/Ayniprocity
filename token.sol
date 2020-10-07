pragma solidity ^0.7.0;

import "./SafeMath.sol";

contract Token {

    using SafeMath for uint256;

    // returns the total amount of tokens
    function totalSupply() constant return (uint256 supply) {}

    // _owner is the address from which the balance will be retrieved
    function balanceOf(address _owner) constant returns (uint256 balance) {}

    // _to is the address of recipient, _value is the amt to be xferred
    function xfer(address _to, uint256 _value) returns (bool success) {}

    // _from is the address of the sender, _value is amt to xfer
    function xfer_from(address _from, address _to, uint256, uint256 _value) returns (bool success) {}

    // _spender is the address of the acct that can xfer tokens
    function approve(address _spender, uint256 _value) returns (bool success) {}

    // returns the amt of remaining tokens that can be spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

    event Transfer(address _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}