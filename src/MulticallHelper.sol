pragma solidity ^0.4.25;

contract MulticallHelper {
    function ethBalanceOf(address addr) public view returns (uint256) {
        return addr.balance;
    }
}
