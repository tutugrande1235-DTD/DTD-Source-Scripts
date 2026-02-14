local user = os.getenv("USER")
local pass = os.getenv("PASS")
local token = os.getenv("PAT")
local file = os.getenv("FILE")
local content = os.getenv("CONTENT")
local users = {}

if not token then print("\27[91mno token found!") return end
if not user then print("\27[91mno user provided!") return end
if not pass then print("\27[91mno pass provided!") return end
if not file then print("\27[91mno file provided!") return end
if not content then print("\27[91mno content received!") return end

print("\27[93mloading services...")
do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91merror while loading service 1...") return end
end

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91merror while loading service 2...") return end
end

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
    if s then
        local c = s:read("*a")
        s:close()
        if c ~= "" then
            for v in c:gmatch("\"name\"%s*:%s*\"(.-)\"") do
                if v == user then
                    
                end
            end
        end
    else
        print("\27[91merror while autheticate user...")
        return
    end
end