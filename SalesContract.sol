pragma solidity ^0.4.2;

import './IERC20.sol';
import './SafeMath.sol';

contract DMIToken is ERC20Interface {

	using SafeMath for uint256;

	uint256 _totalSupply = 0; 
    string _symbol = "DMIT";
	string _name = "Distributed Meritocratic Investment Token";
    uint8 _decimals = 18;

	//1 ether = RATE_quantity DMIToken
	uint256 public constant rate = 500;
	address public owner;

	mapping(address => uint256) balances;
	mapping(address => mapping(address => uint256)) allowed;

	constructor(DMIToken) public {
		owner = msg.sender;

	}

	function createTokens() public payable {
		require(msg.value > 0);
		uint256 tokens = msg.value.mul(rate);
		balances[msg.sender] = balances[msg.sender].add(tokens);
		_totalSupply = _totalSupply.add(tokens);
		owner.transfer(msg.value);
	}

	function () public payable{
		createTokens();
	}

	function totalSupply() constant public returns (uint256 balance){
		return _totalSupply;
	}

	function balanceOf(address _owner) constant public returns(uint256 balance){
		return balances[_owner];
	}

	function  transfer(address _to, uint256 _value) public returns(bool success){
		require(
			balances[msg.sender] >= _value
			&& _value >= 0
		);

		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
		require(
			allowed[_from][msg.sender] >= _value
			&& balances[_from] >= _value
			&& _value > 0
		);

		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		emit Transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success){
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) constant public returns(uint256 remaining){
		return allowed[_owner][_spender];
	}

}