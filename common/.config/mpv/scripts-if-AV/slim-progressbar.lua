-- A bare bone "progressbar.lua" when pausing:

-- config
local SEEK_TIMER = 0.2 -- must be > 0
local PAUSE_TIMER = 0 -- 0 and less to disable, aka stay on screen until playback starts again
local COLOR_PROGRESS = "48184F" -- BBGGRR
local COLOR_BACKGROUND = "C0C0C0"
local OPACITY = "0" -- [0, 255] -- not so sure about these numbers anymore, but whatever: 0 = opaque
local BAR_HEIGHT = 3
-- gifnoc

local OSD_INTERNAL_H = 720
local win_w, win_h = mp.get_osd_size()
local vid_w = win_w
local vid_margin_x = 0

local progress_bar = mp.create_osd_overlay("ass-events")
local background_bar = mp.create_osd_overlay("ass-events")

local function px_to_osd_scale(val) return val * OSD_INTERNAL_H / win_h end

local function erase_progressbar()
    progress_bar:remove()
    background_bar:remove()
end

local function render_progressbar(timer)
    local progress_w = math.floor(px_to_osd_scale(vid_w) * 0.01 * mp.get_property_number('percent-pos', 0))
    local background_w = px_to_osd_scale(vid_w + 1) - progress_w -- +1 to ensure that it reaches the right border (sometimes, it's a bit short)

    -- See http://www.tcax.org/docs/ass-specs.htm for strings components
    progress_bar.data = string.format([[{\p1\bord0\alpha&H%s\1c&H%s&\pos(%d,%d)}]], 
                        OPACITY, COLOR_PROGRESS, vid_margin_x, OSD_INTERNAL_H) ..
                        string.format([[m 0 0 l %d 0 %d %d 0 %d]], 
                        progress_w, progress_w, -BAR_HEIGHT, -BAR_HEIGHT)

    background_bar.data = string.format([[{\p1\bord0\alpha&H%s\1c&H%s&\pos(%d,%d)}]], 
                          OPACITY, COLOR_BACKGROUND, vid_margin_x + progress_w, OSD_INTERNAL_H) ..
                          string.format([[m 0 0 l %d 0 %d %d 0 %d]], 
                          background_w, background_w, -BAR_HEIGHT, -BAR_HEIGHT)

    progress_bar:update()
    background_bar:update()

    if timer > 0 then mp.add_timeout(timer, erase_progressbar) end
end

local function resize_progressbar()
    win_w, win_h = mp.get_osd_size()
    local ar = mp.get_property_native("video-params/aspect")
    if nil == ar then vid_w = win_w else vid_w = math.ceil(win_h * ar) end
    vid_margin_x = px_to_osd_scale(mp.get_property_native("osd-dimensions/ml"))
    --alternatively:  vid_margin_x = px_to_osd_scale(math.ceil((win_w - vid_w) * 0.5))
end

local function osc_not_hovered()  -- 100 24
    local _, m_pos_y = mp.get_mouse_pos()
    return m_pos_y < win_h - 100 and m_pos_y > 24
end

local paused = false
local osc_hidden = true

mp.observe_property("pause", "bool", function(_, pause_prop)
    paused = pause_prop
    if paused and osc_not_hovered() then render_progressbar(PAUSE_TIMER)
    else erase_progressbar() end
end)
mp.register_event('file-loaded', function() if paused then erase_progressbar() end end)
mp.observe_property("mouse-pos", "native", function() if paused then erase_progressbar() end end)
mp.register_event("seek", function() if osc_not_hovered() then render_progressbar(SEEK_TIMER) end end)
mp.add_forced_key_binding(nil, "slimbar_on_seek", function() if osc_not_hovered() then render_progressbar(SEEK_TIMER) end end)

mp.observe_property("osd-dimensions", "native", resize_progressbar)

mp.msg.fatal("LOADED")
