#!/usr/bin/python3
from wayfire import WayfireSocket

# -------------------------
LAYOUT_ABBREVIATIONS =	{
  "English (US)":    "ENG",
  "French (Canada)": "FRA",
}
# -------------------------

# In case the kb layout is not found:
TEXT_UNKNOWN = "???"
TOOLTIP_UNKNOWN = "WHAT, HOW??\rFIX THIS OR ALL\rHONDA CIVICS EXPLODE!!"

def print_format(kb_layout):
    global LAYOUT_ABBREVIATIONS, TEXT_UNKNOWN, TOOLTIP_UNKNOWN
    text = LAYOUT_ABBREVIATIONS.get(kb_layout, TEXT_UNKNOWN)
    tooltip = f'{kb_layout}\r{text} keyboard\r\rTo switch input methods, press\rWindows key+Space.'
    print(f'{{"text":"{text}","tooltip":"{TOOLTIP_UNKNOWN if kb_layout == TEXT_UNKNOWN else tooltip}"}}', flush=True)

sock = WayfireSocket()
kb_layout = sock.get_keyboard_layout()["layout"]
print_format(kb_layout)

sock.watch(["keyboard-modifier-state-changed"])
while True:
    msg = sock.read_next_event()
    if msg["state"]["layout"] != kb_layout:
        kb_layout = msg["state"]["layout"]
        print_format(kb_layout)
