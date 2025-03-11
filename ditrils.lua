-- Services
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Cam = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Prevent duplicate UI
if CoreGui:FindFirstChild("CustomUI") then
    CoreGui:FindFirstChild("CustomUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUI"
ScreenGui.Parent = CoreGui

local function createButton(text, position, size)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 50, 0, 50) -- Default to square 50x50
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Parent = ScreenGui
    button.Font = Enum.Font.FredokaOne
    button.TextSize = 10
    button.AutoButtonColor = true

    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    -- Smooth color transition on hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)

    return button
end

-- Upper Left Corner for Aimbot Button (80x80)
local AimbotButton = createButton("AIM", UDim2.new(0, 10, 0, 10), UDim2.new(0, 80, 0, 80))

-- Arrange other buttons in a horizontal line (Upper Right)
local spacing = 10
local baseX = 1
local baseY = 0
local buttonSize = 50

local ESPButton = createButton("ESP", UDim2.new(baseX, -buttonSize*5 - spacing*5, baseY, spacing))
local NightVisionButton = createButton("NV", UDim2.new(baseX, -buttonSize*4 - spacing*4, baseY, spacing))
local ThirdPersonButton = createButton("TP", UDim2.new(baseX, -buttonSize*3 - spacing*3, baseY, spacing))
local NoclipButton = createButton("NOC", UDim2.new(baseX, -buttonSize*2 - spacing*2, baseY, spacing))
local FlashlightButton = createButton("FL", UDim2.new(baseX, -buttonSize - spacing, baseY, spacing))

--------------------------
-- DYNAMIC TIME DISPLAY
--------------------------
-- Prevent duplicate UI
if CoreGui:FindFirstChild("TimeDisplayUI") then
    CoreGui:FindFirstChild("TimeDisplayUI"):Destroy()
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeDisplayUI"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true -- Ensures proper centering

-- Create Time Label
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 50)
TimeLabel.Position = UDim2.new(0.5, -100, 0, 10) -- Centered at the top
TimeLabel.BackgroundTransparency = 1
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Default white
TimeLabel.TextScaled = true
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.Text = "--:--"
TimeLabel.Parent = ScreenGui

-- Function to convert time string to numeric hour
local function parseTime(timeString)
    local hour, minute, period = timeString:match("(%d+):(%d+) (%a+)")
    if hour and minute and period then
        hour = tonumber(hour)
        if period == "PM" and hour ~= 12 then
            hour = hour + 12
        elseif period == "AM" and hour == 12 then
            hour = 0
        end
        return hour
    end
    return nil
end

-- Function to update time and color
local function updateTime()
    local timeText = workspace:FindFirstChild("Train") 
        and workspace.Train:FindFirstChild("TrainControls") 
        and workspace.Train.TrainControls:FindFirstChild("TimeDial") 
        and workspace.Train.TrainControls.TimeDial:FindFirstChild("SurfaceGui") 
        and workspace.Train.TrainControls.TimeDial.SurfaceGui:FindFirstChild("TextLabel") 
        and workspace.Train.TrainControls.TimeDial.SurfaceGui.TextLabel.Text 
        or "--:--"

    TimeLabel.Text = timeText

    local hour = parseTime(timeText)

    if hour then
        if hour == 20 then -- 8:00 PM
            TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
        elseif hour == 21 then -- 9:00 PM
            TimeLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
        elseif hour >= 22 or hour <= 4 then -- 10:00 PM - 4:00 AM
            TimeLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red
        else -- 5:00 AM - 7:00 PM
            TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White
        end
    else
        TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Default white if no valid time
    end
end

-- Update time every frame
RunService.Heartbeat:Connect(updateTime)


----------------
-- ESP System
----------------
local ESPHandles = {}
local ESPEnabled = false

local YellowItems = {"Vampire", "Werewolf"}
local RedItems = {"Bond"}
local GreenItems = {"BankCombo"}
local GoldItems = {"GoldBar", "GoldCup", "MoneyBag", "Molotov", "Crucifix"}
local SilverItems = {"SilverBar", "SilverCup", "SheetMetal", "Rifle", "RifleAmmo", "Revolver", "RevolverAmmo",
    "Shotgun", "ShotgunAmmo", "BarbedWire", "Cavalry Sword", "Bolt Action Rifle", "SilverPlate",
    "TurretAmmo", "Coal"}
local WhiteItems = {"Bandage", "Holy Water", "Snake Oil"}

local MaxDistance = 800

local function IsInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local function GetItemColor(itemName)
    if IsInTable(YellowItems, itemName) then return Color3.new(1, 1, 0) end -- Yellow
    if IsInTable(RedItems, itemName) then return Color3.new(1, 0, 0) end -- Red
    if IsInTable(GreenItems, itemName) then return Color3.new(0, 1, 0) end -- Green
    if IsInTable(GoldItems, itemName) then return Color3.fromRGB(255, 215, 0) end -- Gold
    if IsInTable(SilverItems, itemName) then return Color3.fromRGB(192, 192, 192) end -- Silver
    if IsInTable(WhiteItems, itemName) then return Color3.new(1, 1, 1) end -- White
    return nil
end

local function CreateESP(object, color)
    if not object or not object.PrimaryPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = object.PrimaryPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = object.Name
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextColor3 = color
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 7
    textLabel.Parent = billboard

    ESPHandles[object] = {Highlight = highlight, Billboard = billboard}
end

local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Billboard then handles.Billboard:Destroy() end
    end
    ESPHandles = {}
end

local function UpdateESP()
    ClearESP()
    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart then return end

    local runtimeItems = workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetChildren()) do
            if item:IsA("Model") and item.PrimaryPart then
                local color = GetItemColor(item.Name)
                if color then
                    local distance = (character.PrimaryPart.Position - item.PrimaryPart.Position).Magnitude
                    if distance <= MaxDistance then
                        CreateESP(item, color)
                    end
                end
            end
        end
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        UpdateESP()
    else
        ClearESP()
    end
end

-- Connect ESP to button click
ESPButton.MouseButton1Click:Connect(ToggleESP)

-- Auto-update ESP while enabled
RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        UpdateESP()
    end
end)

-------------------------------
-- Aimbot Script
-------------------------------
local validNPCs = {}
local aimbotEnabled = false
local lastUpdate = 0
local updateInterval = 0.5 -- Update NPC list every 0.5 seconds

local function isNPC(obj)
    return obj:IsA("Model") 
        and obj:FindFirstChild("Humanoid")
        and obj.Humanoid.Health > 0
        and obj:FindFirstChild("Head")
        and obj:FindFirstChild("HumanoidRootPart")
        and not Players:GetPlayerFromCharacter(obj)
end

local function updateNPCs()
    local tempTable = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            tempTable[obj] = true
        end
    end
    for i = #validNPCs, 1, -1 do
        if not tempTable[validNPCs[i]] then
            table.remove(validNPCs, i)
        end
    end
    for obj in pairs(tempTable) do
        if not table.find(validNPCs, obj) then
            table.insert(validNPCs, obj)
        end
    end
end

local function getHeadPosition(target)
    local head = target:FindFirstChild("Head")
    return head and head.Position or nil
end

local function getTarget()
    local now = tick()
    if now - lastUpdate > updateInterval then
        updateNPCs()
        lastUpdate = now
    end

    local nearest, minDistance = nil, math.huge
    local viewportCenter = Cam.ViewportSize / 2

    for _, npc in ipairs(validNPCs) do
        local headPos = getHeadPosition(npc)
        if headPos then
            local screenPos, visible = Cam:WorldToViewportPoint(headPos)
            if visible and screenPos.Z > 0 then
                local dx, dy = screenPos.X - viewportCenter.X, screenPos.Y - viewportCenter.Y
                local distance = dx * dx + dy * dy -- Using squared distance for efficiency
                if distance < minDistance then
                    minDistance = distance
                    nearest = npc
                end
            end
        end
    end
    return nearest
end

local function aim(targetPosition)
    if not targetPosition then return end
    local currentCF = Cam.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit

    if (Cam.CFrame.LookVector - targetDirection).Magnitude > 0.001 then
        Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + currentCF.LookVector:Lerp(targetDirection, 0.5))
    end
end

RunService.Heartbeat:Connect(function()
    if aimbotEnabled then
        local target = getTarget()
        if target then
            aim(getHeadPosition(target))
        end
    end
end)

-------------------------------
-- Link Aimbot to UI Button
-------------------------------
AimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(30, 30, 30)
end)

------------------------------
-- Third-Person View Function
------------------------------
local thirdPersonEnabled = false
local thirdPersonOffset = Vector3.new(0, 3, 10) -- Camera distance behind the player

local function toggleThirdPerson()
    thirdPersonEnabled = not thirdPersonEnabled
    local character = LocalPlayer.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    if thirdPersonEnabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        local targetCFrame = CFrame.new(rootPart.Position + thirdPersonOffset, rootPart.Position)
        local tween = TweenService:Create(Cam, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {CFrame = targetCFrame})
        tween:Play()
    else
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end

-- Bind Third-Person Toggle to the "TP" Button
ThirdPersonButton.MouseButton1Click:Connect(toggleThirdPerson)


-----------------
-- Night Vision
-----------------
-- Night Vision Function
local nightVisionEnabled = false

-- Store original lighting values
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalFogEnd = Lighting.FogEnd
local originalGlobalShadows = Lighting.GlobalShadows

local function updateNightVision()
    if nightVisionEnabled then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.FogEnd = 100000
        if Lighting:FindFirstChild("Atmosphere") then
            Lighting.Atmosphere.Density = 0.2
        end
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.FogEnd = originalFogEnd
        if Lighting:FindFirstChild("Atmosphere") then
            Lighting.Atmosphere.Density = 0.4
        end
        Lighting.GlobalShadows = originalGlobalShadows
    end
end

local function toggleNightVision()
    nightVisionEnabled = not nightVisionEnabled
    updateNightVision()
end

-- Bind Night Vision Toggle to the "NV" Button
NightVisionButton.MouseButton1Click:Connect(toggleNightVision)

--------------------
-- Noclip Function
--------------------
local noclipEnabled = false
local noclipConnection

local function updateNoclip()
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    updateNoclip()
end

-- Bind Noclip Toggle to the "NOC" Button
NoclipButton.MouseButton1Click:Connect(toggleNoclip)

-------------------------
-- Flashlight Function
-------------------------
local flashlightEnabled = false
local flashlight = nil

local function toggleFlashlight()
    flashlightEnabled = not flashlightEnabled
    
    if flashlightEnabled then
        if not flashlight then
            flashlight = Instance.new("PointLight")
            flashlight.Brightness = 2
            flashlight.Range = 20
            flashlight.Color = Color3.fromRGB(255, 255, 200)
            flashlight.Parent = LocalPlayer.Character:FindFirstChild("Head") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
    else
        if flashlight then
            flashlight:Destroy()
            flashlight = nil
        end
    end
end

-- Link button to flashlight function
FlashlightButton.MouseButton1Click:Connect(toggleFlashlight)
