// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract GasUsage {

    // This function shows the remaining gas
    function getRemainingGas() public view returns (uint256) {
        return gasleft();
    }

// This function allows you to check the gas cost of a sample operation
function checkGasCost() public view returns (uint256) {
    uint256 gasStart = gasleft();

    // Sample operation: simple arithmetic or loop
    uint sum = 0;
    for (uint i = 0; i < 10; i++) {
        sum += i;
    }

    uint256 gasEnd = gasleft();
    return gasStart - gasEnd;
    }   
}


contract BolPV {
        address public owner;

    constructor() {
        // Hardcoded owner address
        owner = 0x977147a147356B47e3753d787090C4627fC9f475;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        owner = newOwner;
    }
}

contract BoldPV is IERC20 {
    string public constant name = "BolPv";
    string public constant symbol = "BPV";
    uint8 public constant decimals = 18;

    
        mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;
    uint256 totalSupply_;

    constructor() {
        // Set total supply to 12 billion with 18 decimals
        totalSupply_ = 12 * 10**9 * 10**18;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
