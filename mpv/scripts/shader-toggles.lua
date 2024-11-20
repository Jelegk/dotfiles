local cmd_deb = ""
function debandtoggle()
    mp.command(string.format("apply-profile deband %s", cmd_deb))
    if "" == cmd_deb then cmd_deb = "restore" else cmd_deb = "" end
end

local cmd_dit = ""
function dithertoggle()
    mp.command(string.format("apply-profile dither %s", cmd_dit))
    if "" == cmd_dit then cmd_dit = "restore" else cmd_dit = "" end
end

local cmd_grn = ""
function graintoggle()
    mp.command(string.format("apply-profile grain %s", cmd_grn))
    if "" == cmd_grn then cmd_grn = "restore" else cmd_grn = "" end
end

local cmd_noz = "append"
function noisetoggle()
    mp.command(string.format("change-list glsl-shaders %s ~~/shaders/noise.glsl", cmd_noz))
    if "append" == cmd_noz then cmd_noz = "remove" else cmd_noz = "append" end
end

local cmd_flm = "append"
function filmgraintoggle()
    mp.command(string.format("change-list glsl-shaders %s ~~/shaders/filmgrain-smooth.glsl", cmd_flm))
    if "append" == cmd_flm then cmd_flm = "remove" else cmd_flm = "append" end
end

--local cmd_crt = "append"
--function crttoggle()
--    mp.command(string.format("change-list glsl-shaders %s ~~/shaders/crt-lottes.glsl", cmd_crt))
--    if "append" == cmd_crt then cmd_crt = "remove" else cmd_crt = "append" end
--end


mp.add_forced_key_binding("Ctrl+1" , "deband-toggle", debandtoggle)
mp.add_forced_key_binding("Ctrl+2" , "dither-toggle", dithertoggle)
mp.add_forced_key_binding("Ctrl+3" , "grain-toggle", graintoggle)
mp.add_forced_key_binding("Ctrl+4" , "noise-toggle", noisetoggle)
mp.add_forced_key_binding("Ctrl+5" , "filmgrain-toggle", filmgraintoggle)
--mp.add_forced_key_binding("Ctrl+6" , "crt-toggle", crttoggle)