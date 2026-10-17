--- @sync entry
return {
    entry = function()
        local mode = cx.active.pref.linemode == "size_mtime" and "none" or "size_mtime"
        ya.emit("linemode", { mode })
    end,
}
