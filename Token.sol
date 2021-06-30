pragma solidity 0.8.0;

/**
 * @title ERC20 standard token implementation.
 * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
 */
contract Token {

  string internal tokenName;
  string internal tokenSymbol;
  uint8 internal tokenDecimals;
  uint256 internal tokenTotalSupply;
  mapping (address => uint256) internal balances; //Balance information map
  mapping (address => mapping (address => uint256)) internal allowed; //Token allowance mapping.

  event Transfer(address indexed _from,address indexed _to,uint256 _value);
  event Approval(address indexed _owner,address indexed _spender,uint256 _value);
  
  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _initialOwnerBalance) {
      tokenName = _name;
      tokenSymbol = _symbol;
      tokenDecimals = _decimals;
      tokenTotalSupply = _initialOwnerBalance;
      balances[msg.sender] = _initialOwnerBalance;
  }


  function name() external view returns (string memory _name){
    _name = tokenName;
  }

  function symbol() external view returns (string memory _symbol){
    _symbol = tokenSymbol;
  }

  function decimals() external view returns (uint8 _decimals){
    _decimals = tokenDecimals;
  }

  function totalSupply()external view returns (uint256 _totalSupply){
    _totalSupply = tokenTotalSupply;
  }

  /*
   * @dev Returns the account balance of another account with address _owner.
   * @param _owner The address from which the balance will be retrieved.
   */
  function balanceOf(address _owner) external view returns (uint256 _balance){
    _balance = balances[_owner];
  }

  /*
   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
   * function SHOULD throw if the "from" account balance does not have enough tokens to spend.
   * @param _to The address of the recipient.
   * @param _value The amount of token to be transferred.
   */
  function transfer(address payable _to, uint256 _value) public returns (bool _success){
     require(balances[msg.sender] >= _value,'Insufficient Balance');
     require(msg.sender != _to,"You can't transfer funds to yourself");
     balances[msg.sender] -= _value;
     balances[_to] += _value;
     emit Transfer(msg.sender,_to,_value);
     _success = true;
  }

  /*
   * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
   * this function is called again it overwrites the current allowance with _value. SHOULD emit the Approval event.
   * @param _spender The address of the account able to transfer the tokens.
   * @param _value The amount of tokens to be approved for transfer.
   */
  function approve(address _spender,uint256 _value) public returns (bool _success) {
       require(balances[msg.sender] >= _value,'Insufficient funds to sign-off.');
       require(msg.sender != _spender,"You can't approve yourself");
       allowed[msg.sender][_spender] = _value;
       emit Approval(msg.sender,_spender,_value);
       _success = true;
  }

  /*
   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
   * @param _owner The address of the account owning tokens.
   * @param _spender The address of the account able to transfer the tokens.
   */
  function allowance(address _owner,address _spender) public view returns (uint256 _remaining){
       _remaining = allowed[_owner][_spender];
  }

  /*
   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
   * Transfer event.
   * @param _from The address of the sender.
   * @param _to The address of the recipient.
   * @param _value The amount of token to be transferred.
   */
  function transferFrom(address _from,address _to,uint256 _value) public returns (bool _success){
       require(allowance(_from,msg.sender) >= _value,'Amount exceeds allowance');
       require(balances[_from] >= _value,'Insufficient funds');
       allowed[_from][msg.sender] = allowance(_from,msg.sender) - _value;
       balances[_from] -= _value;
       balances[_to] += _value;
       emit Transfer(_from,_to,_value);
       _success = true;
       
  }

}
