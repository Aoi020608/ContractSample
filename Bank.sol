import './Destroyable.sol';
import './Ownable.sol';

interface GovermentInterface {
	function addTransaction(address _from, address _to, uint _amount) external;
}

pragma solidity 0.7.8;

contract Bank is Ownable, Destroyable {

	GovermentInterface govermentInstance = GovermentInterface(contractAddress);

	mapping(address => uint) balance;

	event depositDone(uint amount, address indexed depositedTo);

	function deposit() public payable returns (uint) {
		balance[msg.sender] += msg.value;
		emit depositDone(msg.value, msg.sender);
		return balance[msg.sender];
	}

	function withdraw(uint amount) public onlyOwner returns (uint) {
		require(balance[msg.sender] >= amount);
		msg.sender.transfer(amount);
		return balance[msg.sender];
	}

	function getBalance() public view returns (uint) {
		return balance[msg.sender];
	}

	function transfer(address recipient, uint amount) public {
		require(balance[msg.sender] >= amount, "balance not sufficient");
		require(msg.sender != recipient, "don't transfer yourself");

		uint previousSenderBalance = balance[msg.sender];

		_transfer(msg.sender, recipient, amount);

		govermentInstance.addTransaction(msg.sender, recipient, amount);

		assert(balance[msg.sender] == previousSenderBalance - amount);
	}

	function _transfer(address from, address to, uint amount) private {
		balance[from] -= amount;
		balance[to] += amount;
	}
}
