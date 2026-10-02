local mod = "SUPER"

hl.monitor({ output = "", scale = 1 })

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
	},
	decoration = {
		blur = {
			enabled = true,
			size = 16,
			noise = 0,
			passes = 3,
		},
	},
	misc = {
		disable_splash_rendering = true,
	},
})

hl.layer_rule({ match = { namespace = "quickshell:bar" }, blur = true, xray = true })

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("helium"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

local MAX_ZOOM = 8
local MIN_ZOOM = 1
---@param offset number
---@return nil
local function zoom(offset)
	local current = hl.get_config("cursor.zoom_factor")
	current = current + offset
	current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
	hl.config({ cursor = { zoom_factor = current } })
end
hl.bind("SUPER + equal", function()
	zoom(0.5)
end, { repeating = true })
hl.bind("SUPER + minus", function()
	zoom(-0.5)
end, { repeating = true })
