local cmd = "playlist-shuffle"
function shuffletoggle()
    mp.command(cmd)
    if "playlist-shuffle" == cmd then cmd = "playlist-unshuffle" else cmd = "playlist-shuffle" end
end

mp.add_forced_key_binding(nil , "toggle-shuffle", shuffletoggle)

mp.msg.fatal("LOADED (S)")
