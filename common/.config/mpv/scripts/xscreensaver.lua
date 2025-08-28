-- this script deactivates xscreensaver when video playback is active

local function heartbeat()
  if mp.get_property_bool("pause") then
  --or mp.get_property_native("idle")
  --or not mp.get_property_native("vo-configured")
    mp.command_native_async(
      {
        name           = "subprocess",
        args           = { "xscreensaver-command", "-activate" },
        capture_stdout = true,
      },
      function () end)
    mp.msg.info("xscreensaver enabled")
  else
    mp.command_native_async(
      {
        name           = "subprocess",
        args           = { "xscreensaver-command", "-deactivate" },
        capture_stdout = true,
      },
      function () end)
    mp.msg.info("xscreensaver disabled")
  end
end

-- for _, prop in ipairs({"pause", "idle", "vo-configured"}) do
--     mp.observe_property(prop, nil, heartbeat)
-- end

mp.observe_property("pause", nil, heartbeat)

mp.msg.fatal("LOADED")
