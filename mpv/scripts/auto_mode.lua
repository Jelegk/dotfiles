--[[

    https://github.com/stax76/mpv-scripts

    This script changes options depending on what type of
    file is played. It uses the file extension to detect
    if the current file is a video, audio or image file.

    The changes happen not on every file load, but only
    when a mode change is detected.

    On mode change 3 things can be done:

    1. Change options
    2. Change key bindings
    3. Send messages

    The configuration is done in code.

]]--

local AV_SCRIPTS_DIR = "~~/scripts-if-AV"
function audiovisual_profile()
    mp.set_property("cover-art-file", string.format("%s/cover-placeholder.png", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/mpv-osc-simple", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/cut.lua", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/evafast.lua", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/pause_indicator_lite.lua", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/persist-properties.lua ", AV_SCRIPTS_DIR))
    mp.command(string.format("load-script %s/slim-progressbar.lua ", AV_SCRIPTS_DIR))
end

----- start config

-- video mode

function on_video_mode_activate()
    --mp.set_property("osd-playing-msg", "${media-title}")       -- in video mode use media-title
    mp.command("script-message osc-visibility auto no_osd")    -- set osc visibility to auto
    mp.set_property("keep-open", "yes")
    mp.set_property("directory-mode", "lazy")
    audiovisual_profile()
end

function on_video_mode_deactivate()
end

-- audio mode

function on_audio_mode_activate()
    mp.set_property("osd-playing-msg", "${media-title}")       -- in audio mode use media-title
    mp.command("script-message osc-visibility never no_osd")   -- in audio mode disable the osc
    mp.set_property("keep-open", "yes")
    mp.set_property("directory-mode", "recursive")
    audiovisual_profile()
end

function on_audio_mode_deactivate()
end

-- image mode

function on_image_mode_activate()
    mp.set_property("osd-playing-msg", "")                     -- disable osd-playing-msg for images
    mp.set_property("background-color", "#181818")             -- use dark grey background for images
    mp.command("script-message osc-visibility never no_osd")   -- disable osc for images
    mp.set_property("keep-open", "always")
    mp.set_property("directory-mode", "lazy")
end

function on_image_mode_deactivate()
    mp.set_property("background-color", "#181818")             -- use black background for audio and video
end

-- called whenever the file extension changes

function on_type_change(old_ext, new_ext)
    if new_ext == ".gif" then
        mp.set_property("loop-file", "inf")                    -- loop GIF files
    end

    if old_ext == ".gif" then
        mp.set_property("loop-file", "no")                     -- use loop-file=no for anything except GIF
    end
end

-- binding configuration

audio_mode_bindings = {
    { "Left",   function () mp.command("no-osd seek -10") end, "repeatable" }, -- make audio mode seek length longer than video mode seek length
    { "Right",  function () mp.command("no-osd seek  10") end, "repeatable" }, -- make audio mode seek length longer than video mode seek length
}

image_mode_bindings = {
    { "Shift+UP",      function () mp.command("no-osd add video-pan-y  0.01") end,  "repeatable" }, -- move image up
    { "Shift+DOWN",    function () mp.command("no-osd add video-pan-y -0.01") end,  "repeatable" }, -- move image down
    { "Shift+LEFT",    function () mp.command("no-osd add video-pan-x  0.01") end,  "repeatable" }, -- move image left
    { "Shift+RIGHT",   function () mp.command("no-osd add video-pan-x -0.01") end,  "repeatable" }, -- move image right
    { "UP",            nil },
    { "DOWN",          nil },
    { "LEFT",          function () mp.command("no-osd playlist-prev") end }, -- show previous image
    { "RIGHT",         function () mp.command("no-osd playlist-next") end }, -- show next image
    { "SPACE",         function () mp.command("no-osd playlist-next") end }, -- show next image
    { "WHEEL_UP",      function () mp.command("add video-zoom  0.1") end },  -- increase image size
    { "WHEEL_DOWN",    function () mp.command("add video-zoom -0.1") end },  -- decrease image size
    { "BS",            function () mp.command("no-osd set video-pan-y 0; no-osd set video-pan-x 0; no-osd set video-zoom 0") end }, -- reset image options
    { "MBTN_MID",      function () mp.command("no-osd set video-pan-y 0; no-osd set video-pan-x 0; no-osd set video-zoom 0") end }, -- reset image options
    { "MBTN_LEFT_DBL", function () mp.command("no-osd set video-pan-y 0; no-osd set video-pan-x 0; no-osd set video-zoom 0") end }, -- reset image options
}

-- extension configuration

image_file_extensions = { ".jpg", ".png", ".bmp", ".gif", ".webp" }
audio_file_extensions = { ".mp3", ".ogg", ".opus", ".flac", ".m4a", ".mka", ".ac3", ".dts", ".dtshd", ".dtshr", ".dtsma", ".eac3", ".mp2", ".mpa", ".thd", ".w64", ".wav", ".aac" }

----- end config


----- string

function ends_with(value, ending)
    return ending == "" or value:sub(-#ending) == ending
end

----- path

function get_file_ext(path)
    if path == nil then return nil end
    local val = path:match("^.+(%.[^%./\\]+)$")
    if val == nil then return nil end
    return val:lower()
end

----- list

function list_contains(list, value)
    for _, v in pairs(list) do
        if v == value then
            return true
        end
    end

    return false
end

----- key bindings

function add_bindings(definition)
    if type(active_bindings) ~= "table" then
        active_bindings = {}
    end

    local script_name = mp.get_script_name()

    for _, bind in ipairs(definition) do
        local name = script_name .. "_key_" .. (#active_bindings + 1)
        active_bindings[#active_bindings + 1] = name
        mp.add_forced_key_binding(bind[1], name, bind[2], bind[3])
    end
end

function remove_bindings()
    if type(active_bindings) == "table" then
        for _, name in ipairs(active_bindings) do
            mp.remove_key_binding(name)
        end
    end
end

----- main

active_mode = ""
last_type = nil

function enable_video_mode()
    if active_mode == "video" then return end
    active_mode = "video"
    remove_bindings()
    on_video_mode_activate()
end

function enable_audio_mode()
    if active_mode == "audio" then return end
    active_mode = "audio"
    remove_bindings()
    add_bindings(audio_mode_bindings)
    on_audio_mode_activate()
end

function enable_image_mode()
    if active_mode == "image" then return end
    active_mode = "image"
    remove_bindings()
    add_bindings(image_mode_bindings)
    on_image_mode_activate()
end

function disable_video_mode()
    if active_mode ~= "video" then return end
    active_mode = ""
    remove_bindings()
    on_video_mode_deactivate()
end

function disable_image_mode()
    if active_mode ~= "image" then return end
    active_mode = ""
    remove_bindings()
    on_image_mode_deactivate()
end

function disable_audio_mode()
    if active_mode ~= "audio" then return end
    active_mode = ""
    remove_bindings()
    on_audio_mode_deactivate()
end

function on_start_file(event)
    local ext = get_file_ext(mp.get_property("path"))

    if list_contains(image_file_extensions, ext) then
        disable_video_mode()
        disable_audio_mode()
        enable_image_mode()
    elseif list_contains(audio_file_extensions, ext) then
        disable_image_mode()
        disable_video_mode()
        enable_audio_mode()
    else
        disable_audio_mode()
        disable_image_mode()
        enable_video_mode()
    end

    if last_type ~= ext then
        on_type_change(last_type, ext)
        last_type = ext
    end
end

mp.register_event("file-loaded", on_start_file)