local nodes = {}

local function log(mode, ...)
    if mode == true then
        print(...)
    end
end

function nodes.run(code, l)
    local function nt(txt)
        log(l, "\27[92mnds: \27[0m"..txt)
    end
    nt("compiling code...")
    local node = {}
    for g in code:gmatch("\"(.-)\"") do
        v = g:gsub(" ","${nodespace}")
        code = code:gsub(g, v)
    end
    for v in code:gmatch("%S+") do
        table.insert(node, v)
    end
    nt("")
    local m = {}
    local script = {
        {
            key = "log",
            act = function(d, i)
                local arg = d[i + 1]
                if arg then
                    local md = m[arg]
                    if md then
                        io.write(md)
                    else
                        io.write("empty")
                    end
                else
                    io.stderr:write("on key log: NO BOX!")
                end
            end
        },
        {
            key = "box",
            act = function(d, i)
                local it = 0
                local val = false
                local toset = {}
                while true do
                    it = it + 1
                    if val == false then
                        local arg = d[i + it]
                        table.insert(toset, arg)
                    else
                        
                    end
                    if arg == "=" then
                        val = true
                    end
                end
            end
        }
    }
    for i,v in ipairs(node) do
        for _,k in pairs(script) do
            if v == k.key then
                local sucess, error = pcall(k.act, node, i)
                if not sucess then
                    nt("\27[91mERROR!\27[0m\n > "..tostring(error))
                end
            end
        end
    end
end
_G.nds = nodes
return nodes