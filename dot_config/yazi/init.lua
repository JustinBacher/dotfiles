require("git"):setup()
require("no-status"):setup()

--- @diagnostic disable: undefined-global
Status:children_add(function()
	local h = cx.active.current.hovered
	return ui.Line({
		ui.Span(os.date(_, tostring(h.cha.modified):sub(1, 10))):fg("blue"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)
