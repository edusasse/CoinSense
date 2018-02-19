pragma solidity ^0.4.18;

contract ERC223 {
    function balanceOf(address _owner) public constant returns (uint balance);
    function transfer(address to, uint value) public returns (bool);
   
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}