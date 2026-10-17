require("mime-ext.local"):setup { fallback_file1 = true }
require("git"):setup()
require("full-border"):setup { type = ui.Border.ROUNDED }
require("linemode-plus"):setup { date_mode = "default" }

local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }

function Linemode:mtime()
    local timestamp = self._file.cha.mtime
    if not timestamp then
        return ""
    end
    local seconds = math.floor(timestamp)
    if seconds == 0 then
        return ""
    end
    local date, today = os.date("*t", seconds), os.date("*t")
    if date.year == today.year and date.yday == today.yday then
        return os.date("%H:%M", seconds)
    end
    return string.format("%d %s %02d", date.day, months[date.month], date.year % 100)
end
