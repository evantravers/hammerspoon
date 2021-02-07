table.insert(Config.spaces, {
  text = "Focused Meeting",
  subText = "People come first.",
  image = hs.image.imageFromAppBundle('com.flexibits.fantastical2.mac'),
  blacklist = {'distraction', 'communication'},
  launch = {'calendar'},
  toggl_proj = Config.projects.focused_meeting,
})
