pragma solidity ^0.4.18; 

import './ERC20.sol';
import './ERC223.sol';
import './SafeERC20.sol';
import './SafeMath.sol';
import "./Addresses.sol";
import './Token.sol';
import "./ERC223ReceivingContract.sol";
import './SharedStructs.sol';
import './DateTime.sol';
import './strings.sol';

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract CoinSense is Token("CS", "CoinSense Sample", 3, 100000, 100000, "EURO", 1, 100), ERC20, ERC223 {

    using strings for *;
    using Addresses for address;
    using SafeERC20 for ERC20;
    using SafeMath for uint256;
 
	mapping (address => SharedStructs.PersonWallet) internal mapOfPersonWallets;    
    address[] public arrayOfPersonWalletsAccts;

    mapping (address => SharedStructs.Person) mapOfPersons;
    address[] public arrayOfPersonsAccts;
	
    function DecentralizedBankingToken() { }
	
    function balanceOf(address _owner) public constant returns (uint balance) {
        if (_owner == owner){
            return contractBalanceOf;
        }

	    var personWallet = mapOfPersonWallets[_owner];
        if (personWallet.person.immutableWalletAddress == address(0)){
            revert();
        }
		
		uint _totalAvailable = 0;
	    for (uint i = 0; i < personWallet.arrayOfPersonWalletTransactions.length; ++i) {
	        uint key = DateTime.toTimestamp(personWallet.arrayOfPersonWalletTransactions[i].keyYear,
	            personWallet.arrayOfPersonWalletTransactions[i].keyMonth,
	            personWallet.arrayOfPersonWalletTransactions[i].keyDay);
	        uint _deltaT = (now - key)/86400;
	        uint calc = uint( (1 - int(_demurrageRatePerDay)) * (-1));
	        calc = calc ** _deltaT;
	        calc = SafeMath.mul(personWallet.arrayOfPersonWalletTransactions[i]._balanceOf, calc);
	        calc = divWithPrecision(calc, (_demurrageRatePerDay ** _deltaT), _decimals);
	        
            _totalAvailable = _totalAvailable.add(calc);
        }
	
        return _totalAvailable; 
    }
    
    function divWithPrecision(uint numerator, uint denominator, uint precision) internal constant returns(uint quotient) {
         // caution, check safe-to-multiply here
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return ( _quotient);
  }

    function addPerson(bytes32 _firstName, 
        bytes32 _lastName, 
        uint16 _yearOfBirth, 
        uint8 _monthOfBirth, 
        uint8 _dayOfBirth,
        bytes32 _email,
        bytes32 _country,
        bytes32 _state,
        bytes32 _city,
        bytes32 _defaultCurrency,
        bytes32 _ipfsHashPhoto,
        bytes32 _ipfsHashAdditionalInformation) public {
        var person = mapOfPersons[msg.sender];

        person.immutableWalletAddress = msg.sender;
        person.immutableFirstName = _firstName;
        person.immutableLastName = _lastName;
        person.immutableYearOfBirth = _yearOfBirth;
        person.immutableMonthOfBirth = _monthOfBirth;
        person.immutableDayOfBirth = _dayOfBirth;
        person.email = _email;
        person.country = _country;
        person.state = _state;
        person.city = _city;
        person.defaultCurrency = _defaultCurrency;
        person.ipfsHashPhoto = _ipfsHashPhoto;
        person.ipfsHashAdditionalInformation = _ipfsHashAdditionalInformation;

        var personWallet = mapOfPersonWallets[msg.sender];
        personWallet.person = person;

        arrayOfPersonsAccts.push(msg.sender);
    }
    
    function transferTestOnly(address _to, uint _value, uint16 _year, uint8 _month, uint8 _day) public returns (bool success) { 
        return transferImpl(_to, _value, DateTime.toTimestamp(_year,_month,_day));
    }
    
    function transfer(address _to, uint _value) public returns (bool success) { 
        return transferImpl(_to, _value, now);
    }
    
    // _daysBack is here only to facilitate the tests
    function transferImpl(address _to, uint _value, uint _date) internal returns (bool success) { 
        bool result = false;

        var person = mapOfPersons[_to];
        if (person.immutableWalletAddress == address(0)){
            revert();
        }

        SharedStructs.PersonWallet personWallet = mapOfPersonWallets[_to];
        if (personWallet.person.immutableWalletAddress == address(0)){
            revert();
        }
		
        uint16 curYear = DateTime.getYear(_date);
        uint8 curMonth = DateTime.getMonth(_date);
        uint8 curDay = DateTime.getDay(_date);
	    for (uint i = 0; i < personWallet.arrayOfPersonWalletTransactions.length; ++i) {
            if (personWallet.arrayOfPersonWalletTransactions[i].keyYear == curYear
            && personWallet.arrayOfPersonWalletTransactions[i].keyMonth == curMonth
            && personWallet.arrayOfPersonWalletTransactions[i].keyDay == curDay){
                personWallet.arrayOfPersonWalletTransactions[i]._balanceOf = SafeMath.add(personWallet.arrayOfPersonWalletTransactions[i]._balanceOf, _value);
                result = true;
                break;
            }
        }
        
        if (result == false){
            SharedStructs.PersonWalletTransaction memory pwt;
            pwt._balanceOf = _value;
            pwt.keyYear = curYear;
            pwt.keyMonth = curMonth;
            pwt.keyDay = curDay;
            personWallet.arrayOfPersonWalletTransactions.push(pwt);
            result = true;
        }

        Transfer(msg.sender, _to, _value);
        
        return result; 
    }
    
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
       
        return true; 
    }
    
    function approve(address _spender, uint _value) returns (bool success) {
        
        return true; 
    }
    
    function allowance(address _owner, address _spender) constant returns (uint remaining){
        return _allowances[_owner][_spender]; 
    } 
    
    event Transfer(address indexed _from, address indexed _to, uint _value); 
    event Approval(address indexed _owner, address indexed _spender, uint _value); 

}