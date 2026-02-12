
local comment = os.getenv("COMMENT_BODY")
local token = os.getenv("GITHUB_TOKEN")
local issue = os.getenv("ISSUE_NUMBER")

if not DTDUser then DTDUser = { name = "System" } end

if not comment then comment = "test@to@abc" end

local user, to, body = comment:match("^(.-)@(.-)@(.*)$")
print(user)
print(to)
print(body)

print("\27[93mloading issue service...")
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91merror... abort.") return end
end

local reply = ""

if to == DTDUser.name then
    
end

if reply then
    local form = "System@"..user.."@"..reply
    local ins = nil
    if form then
        local issues = DTDIssueService.get()
        for i,v in ipairs(issues) do
            if v.content == "inbox" then
                ins = v.id
                break
            end
        end
        if ins ~= nil then
            DTDIssueService.comment.add(ins, form)
            print("\27[92mcommented sucess!")
        end
    end
end

print("\27[32m[PROCESS COMPLETED!]:")