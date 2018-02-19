pragma solidity ^0.4.18;

library SharedStructs {
        
	struct PersonWallet {
		Person person;
		PersonWalletTransaction[] arrayOfPersonWalletTransactions;
	}
	
	struct PersonWalletTransaction {
        uint16 keyYear;
        uint8 keyMonth;
        uint8 keyDay;
		uint _balanceOf;
	}
    
	struct Person {
        // imutable
        address immutableWalletAddress;
        bytes32 immutableFirstName;
        bytes32 immutableLastName;
        uint16 immutableYearOfBirth;
        uint8 immutableMonthOfBirth;
        uint8 immutableDayOfBirth;
        // mutable
        bytes32 email;
		bytes32 country;
        bytes32 state;
        bytes32 city;
        bytes32 defaultCurrency;
        bytes32 ipfsHashPhoto;
        bytes32 ipfsHashAdditionalInformation;
    }
    
}