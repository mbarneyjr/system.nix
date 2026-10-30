rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>s", "pane.split", { direction = "down" })
rex.bind("ctrl+b>f", "pane.zoom")
rex.bind("ctrl+b>shift+s", "session.switch")
local function float_command(name, title, command)
  rex.action({
    name = name,
    title = title,
    run = function(ctx)
      rex.session.new_layer({
        session_id = ctx.session_id,
        bounds = { 0.2, 0.2, 0.6, 0.6 },
        focus = true,
        layout = rex.layout.block({
          flavor = "com.superlogical.terminal.shell",
          options = { command = { command } },
        }),
      })
    end,
  })
end

float_command("sessionizer", "Project Sessions", REX_SESSIONIZER)
float_command("new_project", "New Project Session", REX_NEW_SESSION)

rex.bind("ctrl+f", "sessionizer")
rex.bind("ctrl+shift+f", "new_project")

rex.bind("ctrl+b>ctrl+l", "pane.resize", { direction = "right" })
rex.bind("ctrl+b>ctrl+h", "pane.resize", { direction = "left" })
rex.bind("ctrl+b>ctrl+j", "pane.balance")
rex.bind("ctrl+b>ctrl+k", "pane.balance")

rex.bind("ctrl+shift+h", "client.tab.previous")
rex.bind("ctrl+shift+l", "client.tab.next")
rex.bind("ctrl+shift+n", "client.tab.new")
rex.bind("ctrl+shift+j", "session.switch")

require("navigator").setup()
