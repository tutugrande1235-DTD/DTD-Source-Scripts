local user = os.getenv("USER")
local pass = os.getenv("PASS")
local token = os.getenv("PAT")
local issue = os.getenv("ISSUE")
local action = os.getenv("ACTION")
local content = os.getenv("CONTENT")

if not user then print("\27[91mno user provided!") return end
if not pass then print("\27[91mno pass provided!") return end
if not token then print("token not found...") return end
if not issue then print("\27[91mno issue number provided!") return end
if not action then print("\27[91mno action provided!") return end
if not content then print("\27[91mno content provided!") return end

print("\27[93mloading service 1")
do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/ServerIssueService.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91failed loading service 1...") return end
end
print("loading service 2")
do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91mfailed loading service 2...") return end
end
local procced = false
do
    print("\27[93mloading users...")
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Accounts/"..user)
    if s then
        local c = s:read("*a")
        s:close()
        if c:sub(1,3) ~= "404" then
            local args = {}
            for v in c:gmatch("%S+") do
                table.insert(args, v)
            end
            local hash = args[1]
            local salt = args[3]
            local hash2 = simple_hash(pass, salt)
            if hash2 == hash then
                procced = true
            else
                print("\27[91mincorrect password...")
            end
        else
            print("\27[91minvalid user!")
        end
    else
        print("\27[91merror while loading users...")
        return
    end
end

if procced == true then
    local id = nil
    if action == "add" then
        local issues = ServerIssueService.get()
        for i,v in ipairs(issues) do
            if v.content == issue then
                id = v.id
                break
            end
        end
    end
    if id ~= nil or action == "remove" then
        if action == "add" then
            print("adding at "..issue.." from user "..user.." and comment body:\n  "..content)
            local strucn = user.."@"..content
            ServerIssueService.comment.add(id, strucn)
        elseif action == "remove" then
            print("removing "..issue)
            ServerIssueService.comment.remove(issue)
        end
    end
end
print("\27[30m[proccess completed!]")