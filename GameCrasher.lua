-- Print discord banner throughout roblox console (visible by pressing F9)
for i = 1, 50 do
    local spaces = string.rep(" ", i)
    print(spaces .. "https://discord.gg/HkKxTUERxS")
    task.wait(0.05)
end

-- Time to cause havoc -_-

-- Spam Error Messages to rate limit player
local i = 1 -- Initialize i to avoid nil error
while true do
    print("Oops.. Something went wrong! Code:", i)
end

-- Crash Lua with stack overflow
function causeStackOverflow()
    return causeStackOverflow()
end

-- Lots of data in one table to overload memory
local t = {}
for i = 1, 1e7 do
    t[i] = i
end

-- Spam remote events to cause lag
local SomeRemoteEvent = game.ReplicatedStorage:WaitForChild("SomeRemoteEvent") -- Fix for missing reference
while true do
    SomeRemoteEvent:FireServer("Spam data")
end

-- Artificial lag / ping
while true do
    wait(0.001)
    print("Processing...")
end

-- Constantly generate huge strings to stress components
local s = ""
for i = 1, 1e6 do
    s = s .. "spam"
end

-- Un-Anchor all parts
for i = 1, 50 do
    local part = Instance.new("Part")
    part.Anchored = false
    part.Position = Vector3.new(math.random()*50, math.random()*50, math.random()*50)
    part.Parent = workspace
end

-- Even more lag
local RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvent") -- Fix for missing reference
while true do
    RemoteEvent:FireServer("data", tick(), math.random())
end

-- A script that does nothing
for i = 1, 100000 do
    coroutine.wrap(function()
        while true do
            -- Hello :)
        end
    end)()
end
