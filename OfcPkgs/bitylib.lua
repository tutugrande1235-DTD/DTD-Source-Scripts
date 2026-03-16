local m = {}

function m.run(code)
    local t = {}
    for v in code:gmatch("%S+") do
        v = tonumber(v, 2)
        table.insert(t, v)
    end
    local script = {
        {
            byte = 1,
            code = function(h,i)
                
            end
        }
    }
    for i,v in pairs(t) do
        local got = false
        for _,n in pairs(script) do
            if v == n.byte then
                got = true
                v.code(t, i)
            end
        end if got == false then
            io.write(string.char(v))
        end
    end
end

return m