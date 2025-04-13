-- Reordered and structured variable declarations
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Game Services
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local wrk = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Player Variables
local plr = players.LocalPlayer
local camera = wrk.CurrentCamera
local mouse = plr:GetMouse()

-- Character Variables
local hrp
local humanoid

local function onCharacterAdded(character)
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

plr.CharacterAdded:Connect(onCharacterAdded)

if plr.Character then
    onCharacterAdded(plr.Character)
end

-- HTTP Request handling for different executors
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Aimbot Variables
local aimFov = 100
local aimParts = {"Head"}
local aiming = false
local predictionStrength = 0.065
local smoothing = 0.05

local aimbotEnabled = false
local wallCheck = true
local stickyAimEnabled = false
local teamCheck = false
local healthCheck = false
local minHealth = 0

-- Combat Variables (Merged from Combat Tab)
local triggerBotEnabled = false
local autoWallbangEnabled = false
local silentAimEnabled = false
local silentAimFov = 100
local autoShootEnabled = false
local recoilControlEnabled = false
local recoilControlStrength = 50

-- FOV Circle Variables
local hue = 0
local rainbowFov = false
local rainbowSpeed = 0.005
-- Changed default FOV colors
local circleColor = Color3.fromRGB(0, 255, 0)  -- Changed from red to green
local targetedCircleColor = Color3.fromRGB(128, 0, 128)  -- Changed to purple

-- Silent Aim Circle Variables
local silentAimCircle = Drawing.new("Circle")
silentAimCircle.Thickness = 2
silentAimCircle.Radius = silentAimFov
silentAimCircle.Filled = false
silentAimCircle.Color = Color3.fromRGB(255, 0, 255)
silentAimCircle.Visible = false
silentAimCircle.Transparency = 0.7

-- SpinBot Variables
local spinBot = false
local spinBotSpeed = 20

-- Aim Viewer Variables
local aimViewerEnabled = false
local ignoreSelf = true

-- ESP Variables
local espEnabled = false
local boxEsp = false
local nameEsp = false
local distanceEsp = false
local healthBarEsp = false
local tracerEsp = false
local teamColorEsp = false
local espObjects = {}

-- Chams Variables
local chamsEnabled = false
local chamsTransparency = 0.5
local chamsObjects = {}

-- Movement Variables
local speedHackEnabled = false
local speedMultiplier = 2
local flyEnabled = false
local flySpeed = 50
local infiniteJumpEnabled = false

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Glyph Hub",
    LoadingTitle = "Loading.",
    LoadingSubtitle = "by glyphaj",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GlyphHub",
        FileName = "glyphaj"
    },
})

-- Create Tabs
local Main = Window:CreateTab("Main")
local Aimbot = Window:CreateTab("Aimbot")
local VisualTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")
local Miscellaneous = Window:CreateTab("Miscellaneous")

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = aimFov
fovCircle.Filled = false
fovCircle.Color = circleColor
fovCircle.Visible = false

local currentTarget = nil

local function checkTeam(player)
    if teamCheck and player.Team == plr.Team then
        return true
    end
    return false
end

local function checkWall(targetCharacter)
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return true end

    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin).unit * (targetHead.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {plr.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = wrk:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function getClosestPart(character)
    local closestPart = nil
    local shortestCursorDistance = aimFov
    local cameraPos = camera.CFrame.Position

    for _, partName in ipairs(aimParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local partPos = camera:WorldToViewportPoint(part.Position)
            local screenPos = Vector2.new(partPos.X, partPos.Y)
            local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

            if cursorDistance < shortestCursorDistance and partPos.Z > 0 then
                shortestCursorDistance = cursorDistance
                closestPart = part
            end
        end
    end

    return closestPart
end

local function getTarget()
    local nearestPlayer = nil
    local closestPart = nil
    local shortestCursorDistance = aimFov

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= plr and player.Character and not checkTeam(player) then
            if player.Character.Humanoid.Health >= minHealth or not healthCheck then
                local targetPart = getClosestPart(player.Character)
                if targetPart then
                    local screenPos = camera:WorldToViewportPoint(targetPart.Position)
                    local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                    if cursorDistance < shortestCursorDistance then
                        if not wallCheck or not checkWall(player.Character) then
                            shortestCursorDistance = cursorDistance
                            nearestPlayer = player
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end

    return nearestPlayer, closestPart
end

local function predict(player, part)
    if player and part then
        local velocity = player.Character.HumanoidRootPart.Velocity
        local predictedPosition = part.Position + (velocity * predictionStrength)
        return predictedPosition
    end
    return nil
end

local function smooth(from, to)
    return from:Lerp(to, smoothing)
end

local function aimAt(player, part)
    local predictedPosition = predict(player, part)
    if predictedPosition then
        if player.Character.Humanoid.Health >= minHealth or not healthCheck then
            local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
            camera.CFrame = smooth(camera.CFrame, targetCFrame)
        end
    end
end

-- Auto Wallbang Function
local function autoWallbang(target, part)
    if target and part and autoWallbangEnabled then
        local gun = plr.Character:FindFirstChildWhichIsA("Tool")
        if gun then
            local fireEvent = gun:FindFirstChild("Fire") or gun:FindFirstChild("Shoot") or gun:FindFirstChild("MouseClick") or gun:FindFirstChild("Attack")
            if fireEvent and fireEvent:IsA("RemoteEvent") then
                local args = {
                    [1] = part.Position
                }
                fireEvent:FireServer(unpack(args))
            end
        end
    end
end

-- Trigger Bot Function
local function checkTriggerBot()
    if triggerBotEnabled then
        local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {plr.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = wrk:Raycast(ray.Origin, ray.Direction * 1000, rayParams)
        if raycastResult and raycastResult.Instance then
            local hitPlayer = players:GetPlayerFromCharacter(raycastResult.Instance.Parent)
            if hitPlayer and hitPlayer ~= plr and (not teamCheck or hitPlayer.Team ~= plr.Team) then
                mouse1press()
                task.wait(0.1)
                mouse1release()
            end
        end
    end
end

-- Silent Aim Function
local function applySilentAim()
    if silentAimEnabled then
        local target, part = getTarget()
        if target and part then
            local predictedPosition = predict(target, part)
            if predictedPosition then
                return predictedPosition
            end
        end
    end
    return nil
end

-- ESP Functions
local function createESPObjects(player)
    if player == plr then return end
    
    local esp = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        healthBar = Drawing.new("Square"),
        healthBarFill = Drawing.new("Square"),
        tracer = Drawing.new("Line")
    }
    
    esp.box.Thickness = 1
    esp.box.Filled = false
    esp.box.Color = Color3.fromRGB(255, 255, 255)
    esp.box.Visible = false
    
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = Color3.fromRGB(255, 255, 255)
    esp.name.Size = 14
    esp.name.Visible = false
    
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.Color = Color3.fromRGB(255, 255, 255)
    esp.distance.Size = 12
    esp.distance.Visible = false
    
    esp.healthBar.Thickness = 1
    esp.healthBar.Filled = false
    esp.healthBar.Color = Color3.fromRGB(255, 255, 255)
    esp.healthBar.Visible = false
    
    esp.healthBarFill.Thickness = 1
    esp.healthBarFill.Filled = true
    esp.healthBarFill.Color = Color3.fromRGB(0, 255, 0)
    esp.healthBarFill.Visible = false
    
    esp.tracer.Thickness = 1
    esp.tracer.Color = Color3.fromRGB(255, 255, 255)
    esp.tracer.Visible = false
    
    espObjects[player] = esp
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local head = player.Character:FindFirstChild("Head")
            
            if head then
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen and espEnabled then
                    local teamColor = player.TeamColor.Color
                    
                    -- Update box
                    if boxEsp then
                        local rootPos = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        local size = Vector2.new(1000 / rootPos.Z, 2000 / rootPos.Z)
                        esp.box.Size = size
                        esp.box.Position = Vector2.new(headPos.X - size.X / 2, headPos.Y - size.Y / 2)
                        esp.box.Color = teamColorEsp and teamColor or Color3.fromRGB(255, 255, 255)
                        esp.box.Visible = true
                    else
                        esp.box.Visible = false
                    end
                    
                    -- Update name
                    if nameEsp then
                        esp.name.Text = player.Name
                        esp.name.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        esp.name.Color = teamColorEsp and teamColor or Color3.fromRGB(255, 255, 255)
                        esp.name.Visible = true
                    else
                        esp.name.Visible = false
                    end
                    
                    -- Update distance
                    if distanceEsp then
                        local distance = math.floor((plr.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
                        esp.distance.Text = tostring(distance) .. "m"
                        esp.distance.Position = Vector2.new(headPos.X, headPos.Y - 25)
                        esp.distance.Color = teamColorEsp and teamColor or Color3.fromRGB(255, 255, 255)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end
                    
                    -- Update health bar
                    if healthBarEsp then
                        local rootPos = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        local size = Vector2.new(1000 / rootPos.Z, 2000 / rootPos.Z)
                        local barPos = Vector2.new(headPos.X - size.X / 2 - 10, headPos.Y - size.Y / 2)
                        
                        esp.healthBar.Size = Vector2.new(4, size.Y)
                        esp.healthBar.Position = barPos
                        esp.healthBar.Visible = true
                        
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.healthBarFill.Size = Vector2.new(4, size.Y * healthPercent)
                        esp.healthBarFill.Position = Vector2.new(barPos.X, barPos.Y + size.Y * (1 - healthPercent))
                        esp.healthBarFill.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        esp.healthBarFill.Visible = true
                    else
                        esp.healthBar.Visible = false
                        esp.healthBarFill.Visible = false
                    end
                    
                    -- Update tracer
                    if tracerEsp then
                        esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(headPos.X, headPos.Y)
                        esp.tracer.Color = teamColorEsp and teamColor or Color3.fromRGB(255, 255, 255)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end
                else
                    esp.box.Visible = false
                    esp.name.Visible = false
                    esp.distance.Visible = false
                    esp.healthBar.Visible = false
                    esp.healthBarFill.Visible = false
                    esp.tracer.Visible = false
                end
            end
        else
            esp.box.Visible = false
            esp.name.Visible = false
            esp.distance.Visible = false
            esp.healthBar.Visible = false
            esp.healthBarFill.Visible = false
            esp.tracer.Visible = false
            
            if not player or not player.Parent then
                esp.box:Remove()
                esp.name:Remove()
                esp.distance:Remove()
                esp.healthBar:Remove()
                esp.healthBarFill:Remove()
                esp.tracer:Remove()
                espObjects[player] = nil
            end
        end
    end
end

-- Chams Functions
local function applyChams(player)
    if player == plr then return end
    
    if player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = player.TeamColor.Color
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = chamsTransparency
                highlight.OutlineTransparency = 0
                highlight.Parent = part
                
                table.insert(chamsObjects, highlight)
            end
        end
    end
end

local function updateChams()
    for _, highlight in ipairs(chamsObjects) do
        if highlight and highlight.Parent then
            highlight.FillTransparency = chamsTransparency
            highlight.Enabled = chamsEnabled
        end
    end
end

local function removeChams()
    for _, highlight in ipairs(chamsObjects) do
        if highlight then
            highlight:Destroy()
        end
    end
    chamsObjects = {}
end

-- Initialize ESP for existing players
for _, player in ipairs(players:GetPlayers()) do
    if player ~= plr then
        createESPObjects(player)
    end
end

-- Connect player added event
players.PlayerAdded:Connect(function(player)
    createESPObjects(player)
end)

-- Connect player removing event
players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        local esp = espObjects[player]
        esp.box:Remove()
        esp.name:Remove()
        esp.distance:Remove()
        esp.healthBar:Remove()
        esp.healthBarFill:Remove()
        esp.tracer:Remove()
        espObjects[player] = nil
    end
end)

-- Recoil Control Function
local function applyRecoilControl()
    if recoilControlEnabled then
        local gun = plr.Character:FindFirstChildWhichIsA("Tool")
        if gun then
            local recoilModule = gun:FindFirstChild("RecoilModule") or gun:FindFirstChild("GunRecoil")
            if recoilModule and recoilModule:IsA("ModuleScript") then
                local success, recoilData = pcall(function()
                    return require(recoilModule)
                end)
                
                if success and type(recoilData) == "table" then
                    for key, value in pairs(recoilData) do
                        if type(value) == "number" then
                            recoilData[key] = value * (1 - (recoilControlStrength / 100))
                        end
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local offset = 50
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + offset)

        if rainbowFov then
            hue = hue + rainbowSpeed
            if hue > 1 then hue = 0 end
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        else
            if aiming and currentTarget then
                fovCircle.Color = targetedCircleColor
            else
                fovCircle.Color = circleColor
            end
        end

        if aiming then
            if stickyAimEnabled and currentTarget then
                local headPos = camera:WorldToViewportPoint(currentTarget.Character.Head.Position)
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if cursorDistance > aimFov or (wallCheck and checkWall(currentTarget.Character)) or checkTeam(currentTarget) then
                    currentTarget = nil
                end
            end

            if not stickyAimEnabled or not currentTarget then
                local target, targetPart = getTarget()
                currentTarget = target
                currentTargetPart = targetPart
            end

            if currentTarget and currentTargetPart then
                aimAt(currentTarget, currentTargetPart)
                
                -- Auto Shoot logic
                if autoShootEnabled then
                    mouse1press()
                    task.wait(0.1)
                    mouse1release()
                end
                
                -- Auto Wallbang logic
                autoWallbang(currentTarget, currentTargetPart)
            end
        else
            currentTarget = nil
        end
    end
    
    -- Update Silent Aim FOV Circle
    if silentAimEnabled then
        silentAimCircle.Position = Vector2.new(mouse.X, mouse.Y + 50)
        silentAimCircle.Radius = silentAimFov
        silentAimCircle.Visible = true
    else
        silentAimCircle.Visible = false
    end
    
    -- Check TriggerBot logic
    checkTriggerBot()
    
    -- Apply recoil control
    applyRecoilControl()
    
    -- Update ESP
    updateESP()
    
    -- Update Chams
    updateChams()
    
    -- Handle speed hack
    if speedHackEnabled and humanoid then
        humanoid.WalkSpeed = 16 * speedMultiplier
    end
    
    -- Handle fly hack
    if flyEnabled and hrp then
        local flyForce = Instance.new("BodyVelocity")
        flyForce.Parent = hrp
        flyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            flyForce.Velocity = camera.CFrame.LookVector * flySpeed
        elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
            flyForce.Velocity = camera.CFrame.LookVector * -flySpeed
        else
            flyForce.Velocity = Vector3.new(0, 0, 0)
        end
        
        game:GetService("Debris"):AddItem(flyForce, 0.1)
    end
end)

-- Hooking mouse events for silent aim
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if silentAimEnabled and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
        local silentAimPos = applySilentAim()
        if silentAimPos then
            args[1] = Ray.new(camera.CFrame.Position, (silentAimPos - camera.CFrame.Position).Unit * 1000)
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        aiming = true
    end
end)

mouse.Button2Up:Connect(function()
    if aimbotEnabled then
        aiming = false
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Main Tab
Main:CreateSection("Welcome to  Glyph Hub by glyphaj")

Main:CreateLabel("The Ultimate Cheating Hub For Free.")

Main:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("discord.gg/C6KDYq9Peb")
        Rayfield:Notify({
            Title = "Discord Link",
            Content = "Copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Aimbot Tab (Merged with Combat Tab)
Aimbot:CreateSection("Aimbot Settings")

local aimbot = Aimbot:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        fovCircle.Visible = Value
    end
})

local aimpart = Aimbot:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head","HumanoidRootPart","Left Arm","Right Arm","Torso","Left Leg","Right Leg"},
    CurrentOption = {"Head"},
    MultipleOptions = true,
    Flag = "AimPart",
    Callback = function(Options)
        aimParts = Options
    end,
})

local smoothingslider = Aimbot:CreateSlider({
    Name = "Smoothing",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 5,
    Flag = "Smoothing",
    Callback = function(Value)
        smoothing = 1 - (Value / 100)
    end,
})

local predictionstrength = Aimbot:CreateSlider({
    Name = "Prediction Strength",
    Range = {0, 0.2},
    Increment = 0.001,
    CurrentValue = 0.065,
    Flag = "PredictionStrength",
    Callback = function(Value)
        predictionStrength = Value
    end,
})

Aimbot:CreateSection("FOV Settings")

local fovvisibility = Aimbot:CreateToggle({
    Name = "Fov Visibility",
    CurrentValue = true,
    Flag = "FovVisibility",
    Callback = function(Value)
        fovCircle.Visible = Value and aimbotEnabled
    end
})

local aimbotfov = Aimbot:CreateSlider({
    Name = "Aimbot Fov",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Flag = "AimbotFov",
    Callback = function(Value)
        aimFov = Value
        fovCircle.Radius = aimFov
    end,
})

local circlecolor = Aimbot:CreateColorPicker({
    Name = "Fov Color",
    Color = circleColor,
    Callback = function(Color)
        circleColor = Color
        if not aiming or not currentTarget then
            fovCircle.Color = Color
        end
    end
})

local targetedcirclecolor = Aimbot:CreateColorPicker({
    Name = "Targeted Fov Color",
    Color = targetedCircleColor,
    Callback = function(Color)
        targetedCircleColor = Color
    end
})

local circlerainbow = Aimbot:CreateToggle({
    Name = "Rainbow Fov",
    CurrentValue = false,
    Flag = "RainbowFov",
    Callback = function(Value)
        rainbowFov = Value
    end
})

Aimbot:CreateSection("Aimbot Checks")

local wallcheck = Aimbot:CreateToggle({
    Name = "Wall Check",
    CurrentValue = true,
    Flag = "WallCheck",
    Callback = function(Value)
        wallCheck = Value
    end
})

local stickyaim = Aimbot:CreateToggle({
    Name = "Sticky Aim",
    CurrentValue = false,
    Flag = "StickyAim",
    Callback = function(Value)
        stickyAimEnabled = Value
    end
})

local teamchecktoggle = Aimbot:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(Value)
        teamCheck = Value
    end
})

local healthchecktoggle = Aimbot:CreateToggle({
    Name = "Health Check",
    CurrentValue = false,
    Flag = "HealthCheck",
    Callback = function(Value)
        healthCheck = Value
    end
})

local minhealth = Aimbot:CreateSlider({
    Name = "Min Health",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "MinHealth",
    Callback = function(Value)
        minHealth = Value
    end,
})

-- Combat Settings (Now in Aimbot Tab)
Aimbot:CreateSection("Combat Settings")

local triggerbot = Aimbot:CreateToggle({
    Name = "Trigger Bot",
    CurrentValue = false,
    Flag = "TriggerBot",
    Callback = function(Value)
        triggerBotEnabled = Value
    end
})

local autowallbang = Aimbot:CreateToggle({
    Name = "Auto Wallbang",
    CurrentValue = false,
    Flag = "AutoWallbang",
    Callback = function(Value)
        autoWallbangEnabled = Value
    end
})

local silenttarget = Aimbot:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        silentAimEnabled = Value
        silentAimCircle.Visible = Value
    end
})

local silentaimfov = Aimbot:CreateSlider({
    Name = "Silent Aim FOV",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Flag = "SilentAimFOV",
    Callback = function(Value)
        silentAimFov = Value
        silentAimCircle.Radius = silentAimFov
    end,
})

local autoshoot = Aimbot:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        autoShootEnabled = Value
    end
})

local recoilcontrol = Aimbot:CreateToggle({
    Name = "Recoil Control",
    CurrentValue = false,
    Flag = "RecoilControl",
    Callback = function(Value)
        recoilControlEnabled = Value
    end
})

local recoilstrength = Aimbot:CreateSlider({
    Name = "Recoil Control Strength",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "RecoilStrength",
    Callback = function(Value)
        recoilControlStrength = Value
    end,
})

local esptoggle = VisualTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        espEnabled = Value
    end
})

local boxesptoggle = VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        boxEsp = Value
    end
})

local nameesptoggle = VisualTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Flag = "NameESP",
    Callback = function(Value)
        nameEsp = Value
    end
})

local distanceesptoggle = VisualTab:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,
    Flag = "DistanceESP",
    Callback = function(Value)
        distanceEsp = Value
    end
})

local healthbaresptoggle = VisualTab:CreateToggle({
    Name = "Health Bar ESP",
    CurrentValue = false,
    Flag = "HealthBarESP",
    Callback = function(Value)
        healthBarEsp = Value
    end
})

local traceresptoggle = VisualTab:CreateToggle({
    Name = "Tracer ESP",
    CurrentValue = false,
    Flag = "TracerESP",
    Callback = function(Value)
        tracerEsp = Value
    end
})

local teamcoloresptoggle = VisualTab:CreateToggle({
    Name = "Team Color ESP",
    CurrentValue = false,
    Flag = "TeamColorESP",
    Callback = function(Value)
        teamColorEsp = Value
    end
})

VisualTab:CreateSection("Chams Settings")

local chamstoggle = VisualTab:CreateToggle({
    Name = "Player Chams",
    CurrentValue = false,
    Flag = "PlayerChams",
    Callback = function(Value)
        chamsEnabled = Value
        
        if Value then
            for _, player in pairs(players:GetPlayers()) do
                if player ~= plr then
                    applyChams(player)
                end
            end
        else
            removeChams()
        end
    end
})

local chamstransparencytoggle = VisualTab:CreateSlider({
    Name = "Chams Transparency",
    Range = {0, 1},
    Increment = 0.01,
    CurrentValue = 0.5,
    Flag = "ChamsTransparency",
    Callback = function(Value)
        chamsTransparency = Value
        updateChams()
    end,
})

-- Movement Tab
MovementTab:CreateSection("Speed Settings")

local speedhacktoggle = MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        speedHackEnabled = Value
        if not Value and humanoid then
            humanoid.WalkSpeed = 16 -- Reset to default
        end
    end
})

local speedmultiplierslider = MovementTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 0.1,
    CurrentValue = 2,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        speedMultiplier = Value
    end,
})

MovementTab:CreateSection("Flight Settings")

local flytoggle = MovementTab:CreateToggle({
    Name = "Fly Hack",
    CurrentValue = false,
    Flag = "FlyHack",
    Callback = function(Value)
        flyEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Flight Enabled",
                Content = "Press W/S to fly forward/backward",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

local flyspeedslider = MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

local infinitejumptoggle = MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

-- Miscellaneous Tab
Miscellaneous:CreateSection("Player Settings")

local spinbottoggle = Miscellaneous:CreateToggle({
    Name = "Spin-Bot",
    CurrentValue = false,
    Flag = "SpinBot",
    Callback = function(Value)
        spinBot = Value
        if Value and hrp then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = false
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,spinBotSpeed,0)
            Rayfield:Notify({Title = "Spin Bot", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            if hrp then
                for i,v in pairs(hrp:GetChildren()) do
                    if v.Name == "Spinning" then
                        v:Destroy()
                    end
                end
                plr.Character.Humanoid.AutoRotate = true
                Rayfield:Notify({Title = "Spin Bot", Content = "Disabled!", Duration = 1, Image = 4483362458,})
            end
        end
    end
})

local spinbotspeed = Miscellaneous:CreateSlider({
    Name = "Spin-Bot Speed",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 20,
    Flag = "SpinBotSpeed",
    Callback = function(Value)
        spinBotSpeed = Value
        if spinBot and hrp then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,Value,0)
        end
    end,
})

Miscellaneous:CreateSection("Server Settings")

local ServerHop = Miscellaneous:CreateButton({
    Name = "Server Hop",
    Callback = function()
        if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
            local body = HttpService:JSONDecode(req.Body)
        
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
        
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
            else
                Rayfield:Notify({Title = "Server Hop", Content = "Couldn't find a valid server!!!", Duration = 1, Image = 4483362458,})
            end
        else
            Rayfield:Notify({Title = "Server Hop", Content = "Your executor is ass!", Duration = 1, Image = 4483362458,})
        end
    end,
})

local rejoinserver = Miscellaneous:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, plr)
    end,
})

-- Additional Miscellaneous Features
Miscellaneous:CreateSection("Additional Features")

local aimviewertoggle = Miscellaneous:CreateToggle({
    Name = "Aim Viewer",
    CurrentValue = false,
    Flag = "AimViewer",
    Callback = function(Value)
        aimViewerEnabled = Value
        
        if Value then
            -- Create aim viewer lines for all players
            for _, player in pairs(players:GetPlayers()) do
                if player ~= plr or not ignoreSelf then
                    local line = Drawing.new("Line")
                    line.Thickness = 1
                    line.Color = Color3.fromRGB(255, 0, 0)
                    line.Visible = true
                    
                    -- Store in table with update logic in RunService
                    if not player:FindFirstChild("AimLine") then
                        local aimViewer = Instance.new("Folder")
                        aimViewer.Name = "AimLine"
                        aimViewer.Parent = player
                        
                        -- Line object is stored in the instance as an attribute
                        aimViewer:SetAttribute("LineObject", line)
                    end
                end
            end
        else
            -- Remove all aim viewer lines
            for _, player in pairs(players:GetPlayers()) do
                local aimViewer = player:FindFirstChild("AimLine")
                if aimViewer then
                    local line = aimViewer:GetAttribute("LineObject")
                    if line then
                        line:Remove()
                    end
                    aimViewer:Destroy()
                end
            end
        end
    end
})

local ignoreselftoggle = Miscellaneous:CreateToggle({
    Name = "Ignore Self (Aim Viewer)",
    CurrentValue = true,
    Flag = "IgnoreSelf",
    Callback = function(Value)
        ignoreSelf = Value
    end
})

-- Update aim viewer lines
RunService.RenderStepped:Connect(function()
    if aimViewerEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if (player ~= plr or not ignoreSelf) and player.Character and player.Character:FindFirstChild("Head") then
                local aimViewer = player:FindFirstChild("AimLine")
                if aimViewer then
                    local line = aimViewer:GetAttribute("LineObject")
                    if line then
                        local head = player.Character.Head
                        local headPos = camera:WorldToViewportPoint(head.Position)
                        
                        -- Calculate where the player is aiming (simplified)
                        local lookVector = (player.Character.Head.CFrame * CFrame.new(0, 0, -10)).Position
                        local lookPos = camera:WorldToViewportPoint(lookVector)
                        
                        if headPos.Z > 0 then
                            line.From = Vector2.new(headPos.X, headPos.Y)
                            line.To = Vector2.new(lookPos.X, lookPos.Y)
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end
                end
            end
        end
    end
end)

-- Server-side anti-cheat bypass (basic approach)
Miscellaneous:CreateSection("Protection")

local antiKickToggle = Miscellaneous:CreateToggle({
    Name = "Anti-Kick",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        if Value then
            -- Hook the kick function to prevent it from executing
            local oldKick
            oldKick = hookfunction(plr.Kick, function(...)
                local args = {...}
                Rayfield:Notify({
                    Title = "Anti-Kick",
                    Content = "Prevented kick: " .. tostring(args[1]),
                    Duration = 3,
                    Image = 4483362458,
                })
                return nil
            end)
        end
    end
})

local antiBanToggle = Miscellaneous:CreateToggle({
    Name = "Anti-Ban",
    CurrentValue = false,
    Flag = "AntiBan",
    Callback = function(Value)
        if Value then
            -- Attempt to hook remote events commonly used for banning
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") and (string.match(v.Name:lower(), "ban") or string.match(v.Name:lower(), "kick") or string.match(v.Name:lower(), "punish")) then
                    local oldFireServer = v.FireServer
                    v.FireServer = function(...)
                        local args = {...}
                        Rayfield:Notify({
                            Title = "Anti-Ban",
                            Content = "Prevented ban/kick remote: " .. v.Name,
                            Duration = 3,
                            Image = 4483362458,
                        })
                        return nil
                    end
                end
            end
        end
    end
})

-- Update notification on script load
Rayfield:Notify({
    Title = "Glyph Hub Loaded",
    Content = "Script successfully loaded! Created by glyphaj",
    Duration = 5,
    Image = 4483362458,
})
