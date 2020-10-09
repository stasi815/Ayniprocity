pragma solidity >=0.4.22 <0.6.0;

import "./SafeMath.sol";


interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
}

contract AyniToken {

    using SafeMath for uint256;

    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;

    // creates array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // Generates public event on the blockchain that notifies clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Generates public event on the blockchain that notifies clients
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Notifies clients about the amt Spent
    event Spent(address indexed from, uint256 value);

    // Constructor function that initializes the contract
    constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
        // Update total supply with the decimal amt
        totalSupply = initialSupply * 10 ** uint256(decimals);
        // Give all inital tokens to the creator of the contract
        balanceOf[msg.sender] = totalSupply;
        // Set name
        name = tokenName;
        // Set symbol
        symbol = tokenSymbol;
    }

    // can only be called by this contract
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use spend() instead
        require(_to != address(0x0));
        // Check if the sender has adequate balance
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract amt from the sender
        balanceOf[_from] -= _value;
        // Add the same amt to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }


    //  Transfer `_value` tokens `_to`
    //  @param _to Address of the recipient
    //  @param _value Amt to send
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    // Transfer `_value` tokens `_from` other address `_to` recipient
    // @param _from The address of the sender
    // @param _to The address of the recipient
    // @param _value the amt to send
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // Check allowance
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    // Set spending allowance from spender address
    // Allows `_spender` to spend no more than `_value` tokens on your behalf
    // @param _spender The address authorized to spend
    // @param _value the max amt they can spend
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
    // @param _spender The address authorized to spend
    // @param _value the max amt they can spend
    // @param _extraData some extra information to send to the approved contract
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }
    // Spends tokens
    // Remove `_value` tokens from system
    // @param _value Amt of money to spend
    function spend(uint256 _value) public returns (bool success) {
        // Check if the sender has enough
        require(balanceOf[msg.sender] >= _value);
        // Subtract amt from the sender
        balanceOf[msg.sender] -= _value;
        // Update totalSupply
        totalSupply -= _value;
        emit Spent(msg.sender, _value);
        return true;
    }

    // Spends tokens from other account
    // Remove `_value` tokens from system on behalf of `_from`
    // @param _from Address of the sender
    // @param _value Amt of money to spend
    function spendFrom(address _from, uint256 _value) public returns (bool success) {
        // Check if the targeted balance is enough
        require(balanceOf[_from] >= _value);
        // Check allowance
        require(_value <= allowance[_from][msg.sender]);
        // Subtract from the targeted balance
        balanceOf[_from] -= _value;
        // Subtract from the sender's allowance
        allowance[_from][msg.sender] -= _value;
        // Update totalSupply
        totalSupply -= _value;
        emit Spent(_from, _value);
        return true;
    }
}
