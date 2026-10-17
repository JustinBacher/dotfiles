local has_targets = ya.sync(function()
    return #cx.active.selected > 0 or cx.active.current.hovered ~= nil
end)

return {
    entry = function()
        ya.emit("mgr:escape", { visual = true })
        if not has_targets() then
            return ya.notify { title = "Command", content = "No file selected or hovered", timeout = 3, level = "warn" }
        end
        local command, event = ya.input {
            title = "Command on selected files:",
            pos = { "top-center", y = 3, w = 70 },
        }
        if event ~= 1 or not command or command:match("^%s*$") then
            return
        end
        local literal_removed = command:gsub("%%%%", "")
        if not literal_removed:find("%%[sSdDhHyYtT]") then
            command = command .. " %s"
        end
        ya.emit("mgr:shell", { command, block = true })
    end,
}
