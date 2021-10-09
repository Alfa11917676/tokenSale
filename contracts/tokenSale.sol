pragma solidity ^0.8.9;

import './Ownable.sol';
import './PriceConsumerV3.sol';
import './SafeMath.sol';
//import './Token.sol';
import '../interfaces/IERC20.sol';

contract tokenSale is PriceConsumerV3, Ownable {
    using SafeMath for uint256;
    using SafeMath for int256;
    uint public startTime;
    uint256 public one_eth_price;
    uint256 public minimumThreshHoldAmount;
    IERC20 internal token;
    mapping (address => uint) receiverBalances;
    uint256 public privateSaleBonus = 25;
    uint256 public preSaleBonus = 20;
    uint256 public crowdSaleBonus;

    uint256 private softCap = 5000000000;
    uint256 public tokenCounter = 0;
    bool private paused;
    event moneyReceived (address _sender, uint amount);

    modifier privateSaleActiveTime () {
        require ( block.timestamp <= startTime+15 days , "Sale time expired");
        require ( paused != true, "Sale is paused");
        _;
    }
    modifier preSaleActiveTime () {
        require (block.timestamp <= startTime+15 days, "Sale time expired");
        require ( paused != true, "Sale is paused");
        _;
    }
    modifier crowdSaleActiveTime () {
        require (block.timestamp <= startTime+30 days, "Sale time expired");
        require ( paused != true, "Sale is paused");
        _;
    }

    constructor () {
        startTime = block.timestamp;
        PriceConsumerV3 chainLinkPrice = new PriceConsumerV3();
        token = IERC20(0xD67270Fe1e7444E6bB143a796F9075BF5d0940dC);
        one_eth_price = uint256(chainLinkPrice.getLatestPrice()).div(1e8);
        minimumThreshHoldAmount = 0.1393 ether;
    }

//todo : makeTheSales function and write the script for it (**begin with line 57 fallback function)
    function privateSale (address _receiver, uint256 _amount) external privateSaleActiveTime{
        require(_amount >= 5000000, 'Minimum limit is 5000000');
        require(receiverBalances[_receiver] >= minimumThreshHoldAmount, 'Insufficient Balance');
        //todo : after minting the token to the receiver address place the balances[_receiver] == 0
        tokenCounter += _amount;
        receiverBalances[_receiver] = 0;
        _amount = _amount.add((_amount.mul(privateSaleBonus)).div(100));

       // token.balances[_receiver] += _amount;
        approveCandidate(_receiver, _amount);
        transferToken(_receiver, _amount);
    }


    function preSale (address _receiver, uint _amount) external preSaleActiveTime {
        require(_amount >= 5000000, 'Minimum limit is 5000000');
        require(receiverBalances[_receiver] >= minimumThreshHoldAmount, 'Insufficient Balance');
        tokenCounter += _amount;
        receiverBalances[_receiver] = 0;
        _amount = _amount.add((_amount.mul(preSaleBonus)).div(100));
        approveCandidate(_receiver, _amount);
        transferToken(_receiver, _amount);
    }

    function crowdSale (address _receiver, uint _amount) external crowdSaleActiveTime {
        require(_amount >= 5000000, 'Minimum limit is 5000000');
        require(receiverBalances[_receiver] >= minimumThreshHoldAmount, 'Insufficient Balances');
        tokenCounter += _amount;
        if (block.timestamp <= startTime+7 days) {
            _amount = _amount.add((_amount.mul(15)).div(100));
        } else if (block.timestamp > startTime+7 days && block.timestamp <= startTime+ 14 days) {
            _amount = _amount.add((_amount.mul(10)).div(100));
        } else if (block.timestamp > startTime+14 days && block.timestamp <= startTime+ 21 days) {
            _amount = _amount.add((_amount.mul(5)).div(100));
        } else if (block.timestamp > startTime+21 days && block.timestamp <= startTime+ 30 days){
            _amount = _amount;
        }
        approveCandidate(_receiver, _amount);
        transferToken(_receiver, _amount);
    }

    function approveCandidate (address _receiver,  uint _amount) private onlyOwner returns (bool) {
        return token.approve(_receiver, _amount);
    }

    function transferToken (address _receiver , uint _amount) private onlyOwner returns (bool) {
        return token.transferFrom(_msgSender(), _receiver, _amount);
    }

    function pausable () external onlyOwner returns (bool) {
        return paused = true;
    }

    function resume () external onlyOwner returns (bool) {
        return paused = false;
    }

    fallback () external payable {
        receiverBalances[msg.sender] += msg.value;
    }
    receive () external payable {
        emit moneyReceived(msg.sender, msg.value);
    }
}