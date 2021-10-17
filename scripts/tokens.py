#!/usr/bin/python3
import requests
from brownie import Token, PriceConsumerV3, tokenSale, accounts, config, network, interface, Contract
from web3 import Web3

NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat", "development", "ganache"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS + [
    "mainnet-fork",
    "binance-fork",
    "matic-fork",
]
contract_to_mock = {
    "arnab_token": Token,
    "weth": Token,
}

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
    # token =  Token.deploy(
    #      "Arnab Coin",
    #      "AC",
    #      1,
    #      5e10,
    #      '0xC6cF8bE45AF84d417D4AF34021c1bAFbb6358ee6',
    #      '0x9007351a71ea72985fDB5cE810d43E10cb14B665',
    #      '0x928425434B09990fce62Cb307b7f125c9EA85A25',
    #      '0xFF628BDAbc401c573FCF9433383BBE003AC0a4DA',
    #      '0xCEDC601D1E9696DD34C0F132812198E250109183',
    #      {'from': account}
    #  )
    sale = fundRaiser(approve_contract('arnab_token'))
    print (sale)
    # sale = tokenSale.deploy(
    #     token.address,
    #     {'from': account}
    # )
    # print(sale.address)

def get_eth_usd_price(account):
    contract = PriceConsumerV3.deploy({'from': account})
    priceof = contract.getLatestPrice()
    return priceof


def fundRaiser(tokenAddress):
    saleDeploy = tokenSale.deploy(
        tokenAddress,
        {'from': get_account()}
    )
    return saleDeploy



def approve_contract(contract_name):
    contract_type = contract_to_mock[contract_name]
    contract_address = config["networks"][network.show_active()][contract_name]
    contract = Contract.from_abi(contract_type._name, contract_address, contract_type.abi)
    return contract

#todo got getContractAt() python version @71 now we just have to transfer WETH and take ARNAB_TOKEN from this contract and distribute it among the address