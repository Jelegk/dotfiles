#!/usr/bin/python3
# Since get_view_property() seemingly does not exist (contrary
# to pywayfire's git repo), always-on-top windows are remembered
# by writing to a temporary file, persistent_config.json. Make sure
# to run usrj_always_on_top_init.sh beforehand, in autostart!
from wayfire import WayfireSocket
import subprocess
import os.path
import json

wf_path = os.path.expandvars("$HOME/.config/wayfire/")

try:
  with open(wf_path + "persistent_config.json", 'r') as file:
    data = json.load(file)
except (FileNotFoundError, json.JSONDecodeError):
  data = { "always_on_top": [ ] }

sock = WayfireSocket()
focused_view = sock.get_focused_view()

if "always_on_top" in data:
  if focused_view["id"] in data["always_on_top"]:
    data["always_on_top"].remove(focused_view["id"])
    sock.set_view_always_on_top(focused_view["id"], False)
    subprocess.Popen(["pw-cat", "-p", "--media-role=Event", "--volume=1", wf_path + "Speech Sleep.wav"])
  else:
    data["always_on_top"].append(focused_view["id"])
    sock.set_view_always_on_top(focused_view["id"], True)
    subprocess.Popen(["pw-cat", "-p", "--media-role=Event", "--volume=1", wf_path + "Speech On.wav"])
else:
  data["always_on_top"] = [ focused_view["id"] ]
  sock.set_view_always_on_top(focused_view["id"], True)
  subprocess.Popen(["pw-cat", "-p", "--media-role=Event", "--volume=1", wf_path + "Speech On.wav"])

with open(wf_path + "persistent_config.json", 'w') as file:
  json.dump(data, file, indent=2)
