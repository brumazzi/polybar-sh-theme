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
        #askPrice = round(float(coin["askPrice"]), 5)
        #priceChangePercent = round(float(coin["priceChangePercent"]), 2)
        askPrice = coin["askPrice"]
        priceChangePercent = coin["priceChangePercent"]
        symbol = coin["symbol"].replace("USDT", "")

        file = open(f"/tmp/alt-coin-changed.tmp-{symbol}", "w")
        file.write(f"{askPrice} {priceChangePercent} {symbol}")
        file.close()
except:
    pass
