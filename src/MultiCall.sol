pragma solidity 0.4.24;

/// @title Multi Call - Batch multiple constant function calls into one
/// @author Michael Elliot - <mike@makerdao.com>
/// @author Joshua Levine - <joshua@makerdao.com>

contract MultiCall {
    function multiCallTest(address scAddress, bytes4 sig) public view returns (uint result) {
        assembly {
            let ptr := mload(0x40) // Move pointer to free memory spot
            mstore(ptr, sig) // Put function sig at memory spot

            let r := call(
                60000, // Gas limit
                scAddress, // Contract address
                0, // No transfer of eth
                ptr, // Inputs are stored at location ptr
                0x24, // Inputs are 36 bytes long
                ptr, // Store output over input
                0x20) // Outputs are 32 bytes long

            if eq(r, 0) {
                revert(0, 0)
            }

            result := mload(ptr) // Assign output to result var
            mstore(0x40,add(ptr, 0x24)) // Set storage pointer to new space
        }
    }
}
