#!/usr/bin/env python3

from requests import request
import sys, time, os

COINS_FILE=f"{os.path.expanduser('~')}/.coins_name"
REQUEST_URL="https://api.binance.com/api/v3/ticker/24hr"

try:
    coinsFile = open(COINS_FILE, "r")
    coins = coinsFile.read().strip()
    coinsFile.close()

    url = f'{REQUEST_URL}?symbols=[{coins}]'

    result = request("GET", url)
    coinsList = result.json()

    for coin in coinsList:
        askPrice = coin["askPrice"]
        priceChangePercent = coin["priceChangePercent"]
        symbol = coin["symbol"].replace("USDT", "")

        if not os.path.isfile(f"/tmp/shm-{symbol}.shm"):
            os.system(f"shmm {symbol} -a 128")

        os.system(f"shmm {symbol} -w '{askPrice} {priceChangePercent} {symbol}'")
except:
    pass
