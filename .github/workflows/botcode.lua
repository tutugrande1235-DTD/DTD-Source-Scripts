
local comment = os.getenv("COMMENT_BODY")
local token = os.getenv("GITHUB_TOKEN")
local issue = os.getenv("ISSUE_NUMBER")

if issue ~= 7 then return end

if not DTDUser then DTDUser = { name = "System" } end

if not comment then comment = "test@to@abc" end

local user, to, body = comment:match("^(.-)@(.-)@(.*)$")
print(user)
print(to)
print(body)

if user == DTDUser.name then return end
if to ~= DTDUser.name then return end

print("\27[93mloading issue service...")
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91merror... abort.") return end
end

local reply = ""

do
    if body:sub(1,4) == "play" then
        local number = tonumber(body:sub(6))
        if number then
            local random = math.floor(math.random(1, 10) + 0.5)
            if random == number then
                reply = "YOU WIN number got "..random
            else
                reply = "hmm... you lose, number got "..random.." and you chose "..number
            end
        end
    elseif body:match("ugly") then
        reply = "you too"
    else
        reply = "im a not a COMMON USER "..user.."!!!"
    end
end

if reply and reply ~= "" then
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