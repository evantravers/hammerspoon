table.insert(config.spaces, {
  text = "Communicate",
  subText = "Intentionally engage with Slack and Email (Shallow)",
  image = hs.image.imageFromAppBundle('com.tinyspeck.slackmacgap'),
  always = {'#communication'},
  toggl_proj = config.projects.communications
})
