
local c = {}

function c.run(code)
    local out = {}
    local bf = {}
    local sbf = nil
    local cd = {}
    for v in code:gmatch("%S+") do
        table.insert(cd, v)
    end
    
    local script = {
        {
            key = ".open",
            act = function(i,n)
                local bff = n[i + 1]
                sbf = tonumber(bff)
                if sbf == nil then io.stderr:write("t:"..i..": INVALID BUFFER ID") return end
                bf[sbf] = {}
            end
        },
        {
            key = ".close",
            act = function(i,n)
                local buff = n[i + 1]
                local code = n[i + 1]
                buff = tonumber(buff)
                if buff == nil then io.stderr:write("t:"..i..": INVALID BUFFER CLOSE") return end
                code = tonumber(code)
                if code == nil then io.stderr:write("t:"..i..": INVALID EXIT CODE") return end
                if code == 1 then
                    bf[sbf] = nil
                elseif code == 0 then
                    bf[sbf] = bf[sbf]
                else
                    bf[sbf] = code
                end
                return code
            end
        },
        {
            key = "mm",
            act = function(i,n)
                local val = n[i + 1]
                local pos = n[i + 2]
                local buffer = bf[sbf]
                val = tonumber(val)
                pos = tonumber(pos)
                if val == nil then io.stderr:write("t:"..i..": NO INT GOT") return end
                if pos == nil then io.stderr:write("t:"..i..": NO BIN POS GOT") return end
                buffer[pos] = val
            end
        },
        {
            key = "rr",
            act = function(i,n)
                local val = n[i + 1]
                local pos = n[i + 2]
                local pos2 = n[i + 3]
                local tt = n[i + 4]
                val = tonumber(val)
                pos = tonumber(pos)
                pos2 = tonumber(pos2)
                local buffer = bf[sbf]
                if val == nil then io.stderr:write("t:"..i..": NO MEMORY REFERENCE") return end
                if pos == nil or pos2 == nil then io.stderr:write("t:"..i..": NO POSITION") return end
                if tt == "bin" then
                    io.write("\27["..pos..";"..pos2.."H"..val)
                else
                    io.write("\27["..pos..";"..pos2.."H"..string.char(buffer[val]))
                end
                return string.char(val)
            end
        },
        {
            key = ".thread",
            act = function(i,n)
                local time = n[i + 1]
                time = tonumber(time)
                if time == nil then io.stderr:write("t:"..i..": INVALID THREAD") return end
                os.execute("sleep "..time)
            end
        },
        {
            key = "add",
            act = function(i,n)
                local m1 = n[i + 1]
                local m2 = n[i + 2]
                local m = n[i + 3]
                m = tonumber(m)
                m1 = tonumber(m1)
                m2 = tonumber(m2)
                if m1 == nil or m2 == nil or m == nil then io.stderr:write("t:"..i..": NO MEMORY REFERENCE") return end
                local a = bf[sbf][m1]
                local b = bf[sbf][m2]
                if a == nil or b == nil then io.stderr:write("t:"..i..": INVALID MEMORY REFERENCE") return end
                local r = a + b
                bf[sbf][m] = r
                return r
            end
        }
    }
    local cout = ""
    
    local st = io.popen("stty size")
    if st then
        local d = st:read("*a")
        st:close()
        local a,b = d:match("(%d*) (%d*)")
        a = a * b
        for i = 1,a do
            io.write(" ")
            io.flush()
        end
    end io.write("\27[0;0H")
    
    for i,v in ipairs(cd) do
        for j,k in pairs(script) do
            if v == k.key then
                local out, er = pcall(k.act, i,cd)
                if out then
                    cout = cout .. tostring(out) .. "\n"
                else
                    io.stderr:write("cfy: \27[91mERROR: \27[0m"..er.."\n\n")
                end
            end
        end
    end
    
    return cout
end

return c