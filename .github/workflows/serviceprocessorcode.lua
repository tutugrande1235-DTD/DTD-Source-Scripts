local user = os.getenv("USER")
local pass = os.getenv("PASS")
local token = os.getenv("PAT")
local file = os.getenv("FILE")
local content = os.getenv("CONTENT")
local mode = os.getenv("MODE")
local users = {}

print("\27[93minitializing...")

if file:match("^Cloud/") then print("\27[91mcannot post at cloud! cloud have a own service to it!") return end
if file:match("^Accounts/") then print("\27[91mcannot post at Accounts! accounts have a own service to it!") return end
if not file:match("^(.-)/") then print("\27[91mcannot post without a folder!") return end

if not token then print("\27[91mno token found!") return end
if not user then print("\27[91mno user provided!") return end
if not pass then print("\27[91mno pass provided!") return end
if not file then print("\27[91mno file provided!") return end
if not content then print("\27[91mno content received!") return end

print("\27[93mloading services...")
do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/ServerPostService.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91merror while loading service 1...") return end
end

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91merror while loading service 2...") return end
end

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/ServerIssueService.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91merror while loading service 3...") return end
end

local check = false
local procced = false

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
    if s then
        local c = s:read("*a")
        s:close()
        if c ~= "" then
            for v in c:gmatch("\"name\"%s*:%s*\"(.-)\"") do
                if v == user then
                    check = true
                    break
                end
            end
        end
    else
        print("\27[91merror while autheticate user...")
        return
    end
end

do
    if check == true then
        local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Accounts/"..user)
        if s then
            local c = s:read("*a")
            s:close()
            if c ~= "" then
                local args = {}
                for v in c:gmatch("%S+") do
                    table.insert(args, v)
                end

                if args[1] then
                    local hash = simple_hash(pass, args[3])
                    if hash == args[1] then
                        print("\27[92mauthentication sucess.")
                        procced = true
                    end
                end
            end
        else
            print("\27[91mfailed while authenticate user pass...")
        end
    else
        print("\27[91minvalid user!")
        return
    end
end

if procced == true then
    if file:match("^(.-)/") then
        _G.ServerPostService.post(content, file.."@"..user, mode)
        if mode == "POST" and file:match("^Market/") and (not file:match("/description$")) then
            _G.ServerIssueService.new(file:gsub("/content","").."@comments")
        elseif mode == "DELETE" and file:match("^Market/") and (not file:match("/description$")) then
            local issues = _G.ServerIssueService.get()
            for i,v in ipairs(issues) do
                if v.content == file:gsub("/content","").."@comments" then
                    _G.ServerIssueService.close(v.id)
                    break
                end
            end
        end
    else
        print("\27[91muse a folder to create organizated files!")
    end
end

os.execute("cls")