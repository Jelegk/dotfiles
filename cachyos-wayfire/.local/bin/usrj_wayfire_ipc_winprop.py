#!/usr/bin/python3

from wayfire import WayfireSocket

sock = WayfireSocket()
sock.watch()

while True:
    try:
        msg = sock.read_next_event()
        if "event" in msg and msg["event"] == "view-focused":
            pid    = f"\033[34mpid\033[0m: {msg['view']['pid']:<6}"
            type   = f"\033[32mtype\033[0m: {msg['view']['type']:<9}"
            app_id = f"\033[33mapp-id\033[0m: {msg['view']['app-id']}"
            title  = f"\033[31mtitle\033[0m: {msg['view']['title']}"
            print(f"{pid} {type} {app_id}\t{title}")
    except KeyboardInterrupt:
        exit(0)
