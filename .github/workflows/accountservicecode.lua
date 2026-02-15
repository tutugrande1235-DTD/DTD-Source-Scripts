local username = os.getenv("USER")
local pass = os.getenv("PASS")
local token = os.getenv("PAT")

print("\27[93minitializing...")

if not username then print("\27[91mno username provided!") end
if not pass then print("\27[91mno pass provided!") end

print("loading service 1...")

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/ServerPostService.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91mfailed loading service...") end
end

print("loading service 2...")

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
    if s then load(s:read("*a"))() s:close() else print("\27[91mfailed loading service...") end
end

print("generating user...")

do
    local s = io.popen("curl -s -H 'Authorization: token "..token.."' https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
    if s then
        local c = s:read("*a")
        s:close()
        if c ~= "" then
            local users = {}
            local id = 0
            for v in c:gmatch("\"name\"%s*:%s*\"(.-)\"") do
                table.insert(users, v)
                id = id + 1
            end
            for i,v in ipairs(users) do
                if v == username then
                    print("\27[91muser already exists!")
                    return
                end
            end
            
            local salt = generate_salt(16)
            if salt then
                local hash = simple_hash(pass, salt)
                if hash then
                    local strucn = hash.."\n"..id.."\n"..salt
                    
                    _G.ServerPostService.post("Accounts/"..strucn, username, "POST")
                    print("\27[92mgenerated!")
                else
                    print("\27[91mfailed while generating hash...")
                end
            else
                print("\27[91mfailed while generating salt...")
            end
        else
            print("\27[91mfailed while reading content...")
        end
    else
        print("\27[91mfailed getting users")
        return
    end
end