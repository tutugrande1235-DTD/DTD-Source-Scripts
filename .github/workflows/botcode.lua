
local comment = os.getenv("COMMENT_BODY")
local token = os.getenv("PAT")
local issue = os.getenv("ISSUE_NUMBER")

if issue == "7" then
    print(issue)
else
    print(issue)
    return
end

if not comment then return end

if not DTDUser then DTDUser = { name = "System" } end

local user, to, body = comment:match("^(.-)@(.-)@(.*)$")

if user and to and body then
    print(user)
    print(to)
    print(body)
end

if user == DTDUser.name then return end
if to ~= DTDUser.name then return end

print("\27[93mloading issue service...")
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/ServerIssueService.lua")
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
        else
            reply = "BRO CHOOSE A NOMBER!"
        end

    elseif body:match("ugly") and (not body:match("not")) then

        reply = "you too"

    elseif body:match("info") and body:match("give") and (not body:match("dont")) then
        reply = "if you try to vanish the market you will get what you want...\nOKAY!!!\n your ugly name is "..user.."\n and i dont know your id...\nSTOP BEING LAZY AND GET THE AccountStatus PACKAGE!!!!"

    else

        reply = "im a not a COMMON USER "..user.."!!!"

    end

end



if reply and reply ~= "" then
    local form = "System@"..user.."@"..reply
    local ins = nil
    if form then
        local issues = ServerIssueService.get()
        for i,v in ipairs(issues) do
            if v.content == "inbox" then
                ins = v.id
                break
            end
        end
        if ins ~= nil then
            ServerIssueService.comment.add(ins, form)
            print("\27[92mcommented sucess!")
            print("\27[93mremoving garbage...")
            local comments = ServerIssueService.comment.read(ins)
            if not comments then print("\27[91mfail") else
                for i,v in ipairs(comments) do
                    if v.body == comment then
                        ServerIssueService.comment.remove(v.id)
                        print("\27[92mremoved!!!")
                        break
                    end
                end
            end
        end
    end
end

print("\27[32m[PROCESS COMPLETED!]:")