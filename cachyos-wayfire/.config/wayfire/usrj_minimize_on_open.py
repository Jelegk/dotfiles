#!/usr/bin/python3
from wayfire import WayfireSocket

# -------------------------
WIN_TITLE_GLOBS = [
    "OBS",
    "Discord",
    "Caprine"
]
# -------------------------

sock = WayfireSocket()
sock.watch(['view-mapped'])
while True:
    try:
        msg = sock.read_next_event()
        if any(needle in msg['view']['title'] for needle in WIN_TITLE_GLOBS):
            sock.set_view_minimized(msg['view']['id'], True)
    except Exception as e:
        print(".config/wayfire/usrj_minimize_on_open.py: it's a cosmic ray!")
        break

# TODO: this is the best solution as of now, but it shows the window for a frame. Not ideal.
