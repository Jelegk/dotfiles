#!/usr/bin/python3

from wayfire import WayfireSocket

sock = WayfireSocket()

kb_data = sock.get_keyboard_layout()
nb_layouts = len(kb_data["possible-layouts"])
next_layout = kb_data["layout-index"] + 1

sock.set_keyboard_layout(0 if next_layout >= nb_layouts else next_layout)

kb_data = sock.get_keyboard_layout()
print(kb_data["layout"])
