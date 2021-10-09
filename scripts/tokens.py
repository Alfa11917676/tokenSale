#!/usr/bin/python3

from brownie import Token, PriceConsumerV3, tokenSale, accounts, config, network
from web3 import Web3


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if network.show_active() in config["networks"]:
        return accounts.add(config["wallets1"]["from_key"])
    return None
def get_second_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if network.show_active() in config["networks"]:
        return accounts.add(config["wallets2"]["from_key"])
    return None

def main():
    account = get_account()
    secondAccount = get_second_account()
#    price = get_eth_usd_price(account)
 #   print (f'The price of eth_usd_price {Web3.fromWei(price,"ether")}, price without converstion {price/1e18}')
    fundRaiser(account, secondAccount)
    # token =  Token.deploy(
    #     "Arnab Coin",
    #     "AC",
    #     1,
    #     5e10,
    #     '0xC6cF8bE45AF84d417D4AF34021c1bAFbb6358ee6',
    #     '0x9007351a71ea72985fDB5cE810d43E10cb14B665',
    #     '0x928425434B09990fce62Cb307b7f125c9EA85A25',
    #     '0xFF628BDAbc401c573FCF9433383BBE003AC0a4DA',
    #     '0xCEDC601D1E9696DD34C0F132812198E250109183',
    #     {'from': account}
    # )
# #    token.wait(2)
#     print (f'The balance of wallet is {token.balanceOf("0x9007351a71ea72985fDB5cE810d43E10cb14B665")}')
#     print (f' The totalSupply is {token.totalSupply()}, totalReserve is {token.reserveWallet()}, interestPayoutWallet {token.interestPayoutWallet()}, The minted wallet received {token.TokenSaleWallet()}, ')
def get_eth_usd_price(account):
    contract = PriceConsumerV3.deploy({'from': account})
    priceof = contract.getLatestPrice()
    return priceof
def fundRaiser(account, account2):
    contract = tokenSale.deploy({'from': account})
    tokenTransfer = contract.privateSale( account2 , 50000000)

    print (tokenTransfer)