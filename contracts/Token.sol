pragma solidity ^0.4.18;

contract Token {

    string internal _symbol;
    string internal _name;

    uint8 internal _decimals;
	string internal _fiat;
    uint256 internal _fiatExchangeRate;
	uint256 internal _demurrageRatePerDay;
    uint public _totalSupply;

    address public owner;
    uint256 public contractBalanceOf;

    mapping (address => mapping (address => uint)) internal _allowances;

    function Token(string symbol, 
            string name, 
            uint8 decimals, 
            uint _initialSupply, 
            uint _totalSupply, 
            string fiat, 
            uint256 fiatExchangeRate, 
            uint256 demurrageRatePerDay) public {
        owner = msg.sender; 
        contractBalanceOf = _initialSupply;
        
        _symbol = symbol;
        _name = name;
        _decimals = decimals;
        _totalSupply = _totalSupply;
        _fiat = fiat;
		_fiatExchangeRate = fiatExchangeRate;
		_demurrageRatePerDay = demurrageRatePerDay;
    }

    function name() public view returns (string) {
        return _name;
    }

    function symbol() public view returns (string) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
}
