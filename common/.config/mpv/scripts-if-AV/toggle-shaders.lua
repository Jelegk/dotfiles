local cmd_nns = ""
local function noblurtoggle()
    mp.command(string.format("no-osd apply-profile no_blur %s", cmd_nns))
    if "" == cmd_nns then cmd_nns = "restore" else cmd_nns = "" end
end

local cmd_dit = ""
local function dithertoggle()
    mp.command(string.format("no-osd apply-profile dither %s", cmd_dit))
    if "" == cmd_dit then cmd_dit = "restore" else cmd_dit = "" end
end

local cmd_grn = ""
local function graintoggle()
    mp.command(string.format("no-osd apply-profile grain %s", cmd_grn))
    if "" == cmd_grn then cmd_grn = "restore" else cmd_grn = "" end
end

local function noisetoggle() mp.command("no-osd change-list glsl-shaders toggle ~~/shaders/noise.glsl") end
local function filmgraintoggle() mp.command("no-osd change-list glsl-shaders toggle ~~/shaders/filmgrain-smooth.glsl") end
--local function crttoggle() mp.command("no-osd change-list glsl-shaders toggle ~~/shaders/crt-lottes.glsl") end


-- Ctrl+1 reserved for visualizer.lua
mp.add_forced_key_binding("Ctrl+2" , "no_blur-toggle", noblurtoggle)
mp.add_forced_key_binding("Ctrl+3" , "dither-toggle", dithertoggle)
mp.add_forced_key_binding("Ctrl+4" , "grain-toggle", graintoggle)
mp.add_forced_key_binding("Ctrl+5" , "noise-toggle", noisetoggle)
mp.add_forced_key_binding("Ctrl+6" , "filmgrain-toggle", filmgraintoggle)
--mp.add_forced_key_binding("Ctrl+7" , "crt-toggle", crttoggle)

--mp.msg.info()      -- blanc
--mp.msg.warn()      -- jaune
--mp.msg.fatal()     -- orange
--mp.msg.error()     -- rouge

mp.msg.fatal("LOADED (Ctrl + [2-6])")