function run(argv) {
  ObjC.import('AppKit')

  const screens = $.NSScreen.screens
  const idx = parseInt(argv[0], 10) - 1
  if (!(idx >= 0 && idx < screens.count)) return

  const primaryHeight = screens.objectAtIndex(0).frame.size.height
  const f = screens.objectAtIndex(idx).visibleFrame

  const ratio = 16 / 9
  let w = f.size.width
  let h = w / ratio
  if (h > f.size.height) {
    h = f.size.height
    w = h * ratio
  }
  w = Math.round(w)
  h = Math.round(h)

  const x = Math.round(f.origin.x + (f.size.width - w) / 2)
  const y = Math.round(primaryHeight - f.origin.y - f.size.height + (f.size.height - h) / 2)

  const proc = Application('System Events').processes.whose({ unixId: parseInt(argv[1], 10) })[0]
  const win = proc.windows[0]
  win.size = [w, h]
  win.position = [x, y]
  win.size = [w, h]
}
