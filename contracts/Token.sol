pragma solidity ^0.8.9;

import "./SafeMath.sol";

contract Token {

    using SafeMath for uint256;

    string public symbol;
    string public name;
    uint256 public decimals;
    uint256 public totalSupply;
    uint256 public reserveWallet;
    uint256 public interestPayoutWallet;
    uint256 public teamMemberHRWallet;
    uint256 public companyGeneralFundWallet;
    uint256 public airDropWallet;
    uint256 public TokenSaleWallet;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _totalSupply,
        address reserveWalletAddress,
        address interestPayoutWalletAddress,
        address teamMembersHRWalletAddress,
        address companyGeneralFundWalletAddress,
        address airdropWalletAddress

    )
        public
    {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        reserveWallet = (totalSupply.mul(30)).div(100);
        interestPayoutWallet = (totalSupply.mul(20)).div(100);
        teamMemberHRWallet = (totalSupply.mul(10)).div(100);
        companyGeneralFundWallet = (totalSupply.mul(10)).div(100);
        airDropWallet = (totalSupply.mul(10)).div(100);
        TokenSaleWallet = (totalSupply.mul(25)).div(100);
        balances[msg.sender] = TokenSaleWallet;
        balances[reserveWalletAddress]= reserveWallet;
        balances[interestPayoutWalletAddress] = interestPayoutWallet;
        balances[teamMembersHRWalletAddress] = teamMemberHRWallet;
        balances[companyGeneralFundWalletAddress] = companyGeneralFundWallet;
        balances[airdropWalletAddress] = airDropWallet;
        //emit Transfer(address(0), msg.sender, _totalSupply);
        emit Transfer(address(0), reserveWalletAddress, reserveWallet);
        emit Transfer(address(0), interestPayoutWalletAddress, interestPayoutWallet);
        emit Transfer(address(0), teamMembersHRWalletAddress, teamMemberHRWallet);
        emit Transfer(address(0), companyGeneralFundWalletAddress, companyGeneralFundWallet);
        emit Transfer(address(0), airdropWalletAddress, airDropWallet);
        emit Transfer(address(0), msg.sender, TokenSaleWallet);

    }

    /**
        @notice Getter to check the current balance of an address
        @param _owner Address to query the balance of
        @return Token balance
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    /**
        @notice Getter to check the amount of tokens that an owner allowed to a spender
        @param _owner The address which owns the funds
        @param _spender The address which will spend the funds
        @return The amount of tokens still available for the spender
     */
    function allowance(
        address _owner,
        address _spender
    )
        public
        view
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    /**
        @notice Approve an address to spend the specified amount of tokens on behalf of msg.sender
        @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
             and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
             race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
             https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        @param _spender The address which will spend the funds.
        @param _value The amount of tokens to be spent.
        @return Success boolean
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /** shared logic for transfer and transferFrom */
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(balances[_from] >= _value, "Insufficient balance");
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }

    /**
        @notice Transfer tokens to a specified address
        @param _to The address to transfer to
        @param _value The amount to be transferred
        @return Success boolean
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
        @notice Transfer tokens from one address to another
        @param _from The address which you want to send tokens from
        @param _to The address which you want to transfer to
        @param _value The amount of tokens to be transferred
        @return Success boolean
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        returns (bool)
    {
        require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }

}
