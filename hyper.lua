-- HYPER
--
-- Hyper is a hyper shortcut modal.
--
-- Feel free to modify... I use karabiner-elements.app on my laptop and QMK on
-- my mech keyboards to bind a single key to `F19`, which fires all this
-- Hammerspoon-powered OSX automation.
--
-- I chiefly use it to launch applications quickly from a single press,
-- although I also use it to create "universal" local bindings inspired by
-- Shawn Blanc's OopsieThings.
-- https://thesweetsetup.com/oopsiethings-applescript-for-things-on-mac/
--
-- Optional:
-- Hyper hooks into Headspace's block lists. If you configure a space using
-- Headspace, it'll block launching apps that are currently on the blocked
-- lists via hs.settings.

local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
end

hyper.released = function()
  hyper:exit()
end

-- Set the key you want to be HYPER to F19 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, 'F19', hyper.pressed, hyper.released)

hyper.allowed = function(app)
  if hyper.blocking_enabled and app.tags and hs.settings.get("headspace") then
    local space = hs.settings.get("headspace")
    if space.only then
      return hs.fnutils.some(space.only, function(tag)
        return hs.fnutils.contains(app.tags, tag)
      end)
    else
      if space.never then
        return hs.fnutils.every(space.never, function(tag)
          return not hs.fnutils.contains(app.tags, tag)
        end)
      end
    end
  end
  return true
end

hyper.launch = function(app)
  if hyper.allowed(app) then
    hs.application.launchOrFocusByBundleID(app.bundleID)
  else
    local space = hs.settings.get("headspace")
    hs.notify.show(
      "Blocked " .. app.bundleID,
      "Current headspace: " .. space.text,
      ""
    )
  end
end

-- Expects a configuration table with an applications key that has the
-- following form:
-- config_table.applications = {
--   ['com.culturedcode.ThingsMac'] = {
--     bundleID = 'com.culturedcode.ThingsMac',
--     hyper_key = 't',
--     tags = {'#planning', '#review'},
--     local_bindings = {',', '.'}
--   },
-- }
hyper.start = function(config_table)
  -- Use the hyper key with the application config to use the `hyper_key`
  hs.fnutils.map(config_table.applications, function(app)
    -- Apps that I want to jump to
    if app.hyper_key then
      hyper:bind({}, app.hyper_key, function() hyper.launch(app); end)
    end

    -- I use hyper to power some shortcuts in different apps If the app is closed
    -- and I press the shortcut, open the app and send the shortcut, otherwise
    -- just send the shortcut.
    if app.local_bindings then
      hs.fnutils.map(app.local_bindings, function(key)
        hyper:bind({}, key, nil, function()
          if hs.application.get(app.bundleID) then
            hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
          else
            hyper.launch(app)
            hs.timer.waitWhile(
              function()
                return not hs.application.get(app.bundleID):isFrontmost()
              end,
              function()
                hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
              end
            )
          end
        end)
      end)
    end
  end)
end

hyper.enable_blocking = function(self)
  self.blocking_enabled = true
end

return hyper
