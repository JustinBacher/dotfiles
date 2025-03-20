local censor_extmark_opts = function(x, match, y)
    print(tostring(x), tostring(match))
    for k, v in pairs(y) do
        print(k, v)
    end
end

return {
    "echasnovski/mini.hipatterns",
    opts = {
        highlighters = {
            fixme = {
                pattern = "%f[%w]()FIXME()%f[%W]",
                group = "MiniHipatternsFixme",
                extmark_opts = censor_extmark_opts,
            },
            todo = {
                pattern = "%f[%w]()TODO()%f[%W]",
                group = "MiniHipatternsTodo",
            },
            -- Add other patterns as needed
        },
    },
}
