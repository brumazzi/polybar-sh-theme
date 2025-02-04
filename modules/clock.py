#!/usr/bin/env python3

from requests import request
import sys, time, os

URL="http://wttr.in/Palhoca?format=1"
TMP_WEATHER_PATH="/tmp/WEATHER_INFO.tmp"

CLOCK_LIST=[
    ["🕛","🕧"],
    ["🕐","🕜"],
    ["🕑","🕝"],
    ["🕒","🕞"],
    ["🕓","🕟"],
    ["🕔","🕠"],
    ["🕕","🕡"],
    ["🕖","🕢"],
    ["🕗","🕣"],
    ["🕘","🕤"],
    ["🕙","🕥"],
    ["🕚","🕦"]
]
CALENDAR="📅"

timeKey = time.strftime("%M%S")
timeKeyRange = [ f"{index}000" for index in [0] ]

"""
if timeKey in timeKeyRange:
    response = request("GET", URL)
    if response.ok:
        data = response.text[:-1]
        if not data.startwith("Unknown"):
            f = open(TMP_WEATHER_PATH, "w")
            f.write(data.replace("   "," "))
            f.close()
"""

curHour = int(time.strftime("%l"))
curMin = int(time.strftime("%M"))

weather = ""
if os.path.exists(TMP_WEATHER_PATH):
    f = open(TMP_WEATHER_PATH, "r")
    weather = f.read()
    f.close()

clockIcon = CLOCK_LIST[curHour-1][0 if curMin < 30 else 1]

print(time.strftime(f'{CALENDAR} %a %d %b {clockIcon} %H:%M {weather}'))
