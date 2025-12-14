#!/usr/bin/env python3

import json
import sys
import os
import re

separator=":"
field_list=[]
input_file=""
output_file=""
stdin=False

index = 1
while index < len(sys.argv):
    arg = sys.argv[index]
    if arg == '-s':
        separator = sys.argv[index+1]
        index += 1
    elif arg == "-i":
        input_file = sys.argv[index+1]
        index += 1
    elif arg == "-o":
        output_file = sys.argv[index+1]
        index += 1
    elif arg == "-r":
        data = { "mode": "read", "field": sys.argv[index+1]}
        field_list.append(data)
        index += 1
    elif arg == "-d":
        data = { "mode": "delete", "field": sys.argv[index+1]}
        field_list.append(data)
        index += 1
    elif arg == "-w":
        data = { "mode": "write", "field": sys.argv[index+1], "value": sys.argv[index+2]}
        field_list.append(data)
        index += 2
    elif arg == "-":
        stdin = True
        index += 1
    else:
        print("Error:", arg, "is not a valid param.")
        sys.exit(1)
    index += 1

json_dict = None
if stdin:
    json_input = input()
    json_dict = json.loads(json_input)
else:
    if input_file:
        if not os.path.exists(input_file):
            print("File", "\"%s\"" % input_file, "not found!")
            sys.exit(3)
        buff = open(input_file, "rb")
        json_dict = json.loads(buff.read())
        buff.close()
    else:
        json_dict = {}

    pass

output_data = []
for data_dict in field_list:
    data_json = json_dict
    data_json_pv = json_dict
    path = data_dict["field"].split(".")
    mode = data_dict["mode"]
    value = data_dict.get("value", None)
    index = 0

    while index < len(path):
        key = path[index]

        if mode == "write":
            if not type(data_json) is dict or not type(data_json) is list:
                if index > 0:
                    data_json_pv[path[index-1]] = {}
                    data_json = data_json_pv[path[index-1]]
                else:
                    data_json_pv = {}

        index += 1
        data_json_pv = data_json
        if type(data_json) is list:
            if key == path[len(path)-1]:
                if mode == "write":
                    if key == '-':
                        data_json.append(value)
                    else:
                        data_json[int(key)] = value
                    continue
                elif mode == "delete":
                    data_json.pop(int(key))
                    continue
                else:
                    output_data.append(data_json[int(key)])

            data_json = data_json[int(key)]
            continue
        elif type(data_json) is dict:
            if key == path[len(path)-1]:
                if mode == "write":
                    data_json[key] = value
                    continue
                elif mode == "delete":
                    data_json.pop(key)
                    continue
                else:
                    output_data.append(data_json.get(key, None))
            data_json = data_json.get(key, None)
            continue
        break


if output_file:
    with open(output_file, "w") as file:
        file.write(json.dumps(json_dict))
        file.close()

if len(output_data) > 0:
    print(separator.join(output_data))