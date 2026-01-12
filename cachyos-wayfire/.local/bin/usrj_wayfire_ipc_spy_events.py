#!/usr/bin/python3

from wayfire import WayfireSocket
import json

sock = WayfireSocket()
sock.watch()

while True:
    try:
        msg = sock.read_next_event()
        if "event" in msg:
            print(json.dumps(msg, indent=4), "\n")
    except KeyboardInterrupt:
        exit(0)
