-- Doesn't work under wayland (changed xinput to libinput, yet still doesn't work.
-- Maybe the escaped " (that must be there) are not doing their job.
-- Anyways, fixed with niri, so useless
-- mp.register_event("start-file", function() os.execute("[ \"$(libinput list-devices | grep -e Touchpad)\" ] && sed -i 's/WHEEL_UP        add volume +2/WHEEL_UP        add volume -2/g; s/WHEEL_DOWN      add volume -2/WHEEL_DOWN      add volume +2/g' ~/.config/mpv/input.conf || sed -i 's/WHEEL_UP        add volume -2/WHEEL_UP        add volume +2/g; s/WHEEL_DOWN      add volume +2/WHEEL_DOWN      add volume -2/g' ~/.config/mpv/input.conf") end)

-- mp.msg.fatal("LOADED")
