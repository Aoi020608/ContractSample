pragma solidity 0.7.8;

contract GovermentContract {

	struct Transaction {
		address from;
		address to;
		uint amount;
		uint id;
	}

	transaction[] transactionLog;

	function addTransaction(address _from, address _to, uint _amount) external {
		transactionLog.push(Transaction(_from, _to, _amount, transactionLog.length));		
	}

	function getTransaction(uint _index) public returns(address, address, uint){
		return (transactionLog[_index].from, transactionLog[_index].to, transactionLog[_index].id);
	}

	
}
