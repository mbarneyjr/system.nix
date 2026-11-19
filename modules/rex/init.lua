rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>s", "pane.split", { direction = "down" })
rex.bind("ctrl+b>f", "pane.zoom")
rex.bind("ctrl+b>[", "pane.copy_mode.enter")
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

rex.action({
	name = "sessionizer",
	title = "Project Sessions",
	args = { dir = "string?" },
	run = function(ctx, args)
		local labels = {}
		local dir = args.dir
		if dir == nil then
			local home = os.getenv("HOME")
			local listing = rex.exec({
				"/bin/sh",
				"-c",
				'printf "%s\\n" "$HOME/system.nix"; find ~/dev/temp ~/dev/personal ~/dev/work/*/* -mindepth 1 -maxdepth 1 -type d 2>/dev/null',
			})
			local items = {}
			for listed in listing.stdout:gmatch("[^\n]+") do
				labels[listed] = listed == home .. "/system.nix" and "~/system.nix" or listed:match("([^/]+/[^/]+)$")
				table.insert(items, { id = listed, title = labels[listed], subtitle = "~" .. listed:sub(#home + 1), icon = "folder" })
			end
			dir = rex.ui.pick({ title = "Project Sessions", placeholder = "Filter projects", items = items })
			if dir == nil then
				return
			end
		end
		local label = labels[dir] or dir:match("([^/]+/[^/]+)$")

		for _, session in ipairs(rex.call("session.list").sessions or {}) do
			if session.label == label then
				rex.client.queue("session.select", { session_id = session.session_id })
				return
			end
		end

		local session, err = rex.call("session.create", {
			label = label,
			initial_windows = {
				{ layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell", options = { cwd = dir } }) },
			},
		})
		if session == nil then
			error(err, 0)
		end
		rex.client.queue("session.select", { session_id = session.session_id })
	end,
})

float_command("switch_session", "Switch Session", REX_SWITCH_SESSION)
rex.action({
	name = "new_project",
	title = "New Project Session",
	run = function()
		local input = rex.ui.input({ title = "Project directory", placeholder = "work/<company>/…, personal/…, or temp/…" })
		if input == nil then
			return
		end
		if not (input:match("^work") or input:match("^personal") or input:match("^temp")) then
			error("project directory must start with work, personal, or temp", 0)
		end
		local project_dir = os.getenv("HOME") .. "/dev/" .. input
		rex.exec({ "mkdir", "-p", project_dir })

		local git_url = rex.ui.input({ title = "Git remote URL", placeholder = "Leave empty to skip" })
		if git_url == nil then
			return
		end
		if git_url ~= "" then
			local clone = rex.exec({ "git", "clone", git_url, project_dir }, {
				env = { GIT_TERMINAL_PROMPT = "0", GIT_SSH_COMMAND = "ssh -o BatchMode=yes" },
				timeout = 600,
			})
			if not clone.ok then
				error(clone.stderr, 0)
			end
		end

		rex.invoke("sessionizer", { dir = project_dir })
	end,
})

rex.bind("ctrl+f", "sessionizer")
rex.bind("ctrl+;", "switch_session")
rex.bind("ctrl+shift+;", "switch_session")
rex.bind("ctrl+shift+f", "new_project")

rex.bind("ctrl+b>ctrl+l", "pane.resize", { direction = "right" })
rex.bind("ctrl+b>ctrl+h", "pane.resize", { direction = "left" })
rex.bind("ctrl+b>ctrl+j", "pane.balance")
rex.bind("ctrl+b>ctrl+k", "pane.balance")

rex.mode("resize", { exclusive = true })
rex.bind("ctrl+b>r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/shift+h", "pane.resize", { direction = "left", amount = 15 })
rex.bind("resize/shift+j", "pane.resize", { direction = "down", amount = 15 })
rex.bind("resize/shift+k", "pane.resize", { direction = "up", amount = 15 })
rex.bind("resize/shift+l", "pane.resize", { direction = "right", amount = 15 })
rex.bind("resize/=", "pane.balance")

rex.mode("prompt", { exclusive = true })
rex.bind("ctrl+b>p", "client.mode.enter", { name = "prompt" })
rex.bind("prompt/j", "client.prompt.next")
rex.bind("prompt/k", "client.prompt.previous")

rex.bind("ctrl+shift+h", "client.tab.previous")
rex.bind("ctrl+shift+l", "client.tab.next")
rex.bind("ctrl+shift+n", "client.tab.new")
rex.bind("ctrl+shift+/", "client.tab_style.toggle")
rex.bind("ctrl+shift+j", "session.next")
rex.bind("ctrl+shift+k", "session.previous")

require("navigator").setup()
