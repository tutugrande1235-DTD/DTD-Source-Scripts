local event_path = os.getenv("GITHUB_EVENT_PATH")

local f = io.open(event_path, "r")
local raw = f:read("*a")
f:close()

local function extract(key)
  return raw:match('"' .. key .. '"%s*:%s*"([^"]*)"')
end

local user    = extract("user")
local pass    = extract("pass")
local content = extract("content")
local target  = extract("target")
local put_url = extract("put_url")

print("=== PUT OBSERVADO ===")
print("user   :", user)
print("pass   :", pass)
print("target :", target)
print("content:", content)
print("url    :", put_url)