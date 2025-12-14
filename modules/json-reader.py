#!/usr/bin/env python3

import json
import sys

SEPARATOR=":"

json_input = input()
weather_json = json.loads(json_input)

args = sys.argv
args.pop(0)

data = []
for arg in args:
    arg_parts = arg.split('.')
    data_json = weather_json

    for key in arg_parts:
        if type(data_json) is list:
            data_json = data_json[int(key)]
            continue
        elif not key in data_json: break
        data_json = data_json[key]
    
    data.append(data_json)

data = ":".join(map(str, data))
print(data)
