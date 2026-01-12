#!/usr/bin/python3
from wayfire import WayfireSocket

print('{"text":"\uE7C4","class":""}', flush=True)

scale_active = False
sock = WayfireSocket()

sock.watch(["plugin-activation-state-changed"])
while True:
    msg = sock.read_next_event()
    if msg["plugin"] == "scale" and msg["state"] != scale_active:
        scale_active = not scale_active
        if scale_active:
            print('{"text":"\uEB91","class":"alt"}', flush=True)
        else:
            print('{"text":"\uE7C4","class":""}', flush=True)
