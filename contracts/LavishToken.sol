//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "../interfaces/IERC20.sol";

contract LavishToken is IERC20 {
    using SafeMath for uint256;

    string private constant name = "Lavish";
    string private constant symbol = "LVT";
    uint8 private constant decimals = 18;

    uint256 private _totalSupply;

    address public _owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    modifier validAddress(address _address) {
        require(address(0) != _address, "Invalid address provided");
        _;
    }

    constructor() {
        _owner = msg.sender;
        mint(msg.sender, 1000000);
    }

    function buyToken(address receiver)
        external
        payable
        validAddress(receiver)
    {
        uint256 tokensPerEth = 1000;
        uint256 amountTokenPurchased = msg.value * tokensPerEth;

        payable(_owner).transfer(msg.value);

        mint(receiver, amountTokenPurchased);
    }

    function balanceOf(address _address)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return balances[_address];
    }

    function transfer(address receiver, uint256 value)
        public
        virtual
        override
        validAddress(receiver)
        returns (bool)
    {
        require(value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[receiver] = balances[receiver].add(value);

        emit Transfer(msg.sender, receiver, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual override returns (bool) {
        require(value <= balances[from]);
        require(value <= allowances[from][msg.sender]);

        balances[from] = balances[from].sub(value);
        allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
        balances[to] = balances[to].add(value);

        emit Transfer(from, to, value);
        return true;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function mint(address _address, uint256 amount)
        internal
        virtual
        validAddress(_address)
    {
        _totalSupply += amount;
        balances[_address] = balances[_address].add(amount);

        emit Transfer(address(0), _address, amount);
    }

    function approve(address spender, uint256 value)
        public
        virtual
        override
        returns (bool)
    {
        allowances[msg.sender][spender] = value;
        emit Approved(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return allowances[owner][spender];
    }
}
