table.insert(config.spaces, {
  text = "Standup",
  subText = "Run UX Standup.",
  image = hs.image.imageFromAppBundle('com.flexibits.fantastical2.mac'),
  funcs = "standup",
  launch = {'planning'},
  blacklist = {'distraction', 'coding'},
  toggl_proj = config.projects.meeting,
  toggl_desc = "UX Standup"
})

config.funcs.standup = {
  setup = function()
    hs.urlevent.openURL(hs.settings.get("secrets").standupURL)
    local brave = hs.application('com.brave.Browser')
    brave:focusedWindow():moveOneScreenWest()

    brave:selectMenuItem("New Window")
    hs.urlevent.openURL(hs.settings.get("secrets").standupCall)
    brave:focusedWindow():moveOneScreenEast()
  end
}
