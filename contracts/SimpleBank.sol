/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */
     
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    
    
    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint amount);
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    
    receive() external payable {}

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      require (enrolled[msg.sender] = true);
      balances[msg.sender] += msg.value;
      
      emit LogDepositMade(msg.sender, msg.value);
      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {

      address sendtoaddress = msg.sender;
      
      require (balances[msg.sender] >= withdrawAmount);
      (bool success, ) = sendtoaddress.call{value: withdrawAmount}("");
      
        if (!success) {
          revert("Withdrawal failed.");
         }
      balances[msg.sender] -= withdrawAmount;      

      emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
      return balances[msg.sender];
    }
}
