#!/usr/bin/python3
from wayfire import WayfireSocket

print('{"class":""}', flush=True)

sock = WayfireSocket()
sock.watch(["view-mapped", "view-unmapped"])
while True:
    msg = sock.read_next_event()
    if msg["view"]["app-id"] == "rofi":
        print('{"class":"alt"}' if msg["event"] == "view-mapped" else '{"class":""}', flush=True)
