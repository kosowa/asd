--v2.7
-- Webhook
local webhookURL = "https://discord.com/api/webhooks/1277219875865100340/ETF457JFBBhmqxuJ2kUvFn52zzSUIVeIhdHh-9MgDCr_r-mJVVOFsXClNAekZwTQmVg4"

local function jsonEncode(data)
    return game:GetService("HttpService"):JSONEncode(data)
end

local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or "Unknown Player"

local function sendWebhook()

    local avatarUrl = "https://cdn.discordapp.com/attachments/942805757936672821/1307254555796307998/xmaslogo.png?ex=6771022d&is=676fb0ad&hm=5e86e3ebdfe413903f7cc793f60e98bf114e84e23abdf4d5282f5f0d518ec67b&"

    local data = {
        ["embeds"] = {{
            ["title"] = "Script Execution",
            ["description"] = "Script executed by:\n **" .. playerName .. "**",
            ["color"] = 15158332,
            ["thumbnail"] = {
                ["url"] = avatarUrl
            },
            ["footer"] = {
                ["text"] = "Execution Info"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local jsonData = jsonEncode(data)

    local response = request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })

    if response.StatusCode ~= 200 then
        warn("Webhook failed to send. Status code: " .. response.StatusCode .. "\nResponse: " .. response.Body)
    else
        print("Webhook sent successfully!")
    end
end

sendWebhook()
---------------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

------------------------------------------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "ANIME ADVENTURES | BY ATHAN NIGRO",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 300),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "|  Christian Event", Icon = "play" }),
    Optimize = Window:AddTab({ Title = "|  Optimizer", Icon = "boxes" }),
    Summon = Window:AddTab({ Title = "|  Summon", Icon = "coins" }),
    Settings = Window:AddTab({ Title = "|  Settings", Icon = "settings" })
}

local Options = Fluent.Options
Window:SelectTab(1)
Window:Minimize()

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

--------------------------------------------------------------------------------------
--AUTO LOAD SETTINGS
-- Services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local saveFileName = "AAMCNRS.json"

-- Function to load settings
local function loadSettings()
    if isfile(saveFileName) then
        local settingsData = readfile(saveFileName)
        return HttpService:JSONDecode(settingsData)
    else
        return {}
    end
end

-- Function to save settings
local function saveSettings(settings)
    local settingsData = HttpService:JSONEncode(settings)
    writefile(saveFileName, settingsData)
end

-- Load settings on startup
local settings = loadSettings()
-------------------------------------------------------------------------

-- BUTTON MINIMIZE
-- Button creation
local button = Instance.new("ImageButton")
button.Position = UDim2.new(0.9, 0, 0.1, 0)
button.Size = UDim2.new(0, 45, 0, 45)
button.Image = "rbxassetid://129162302366411"
button.BackgroundTransparency = 1
button.ScaleType = Enum.ScaleType.Fit
button.ZIndex = 10

local parentPath = game:GetService("CoreGui"):FindFirstChild("TopBarApp")
if parentPath then
    local unibarLeftFrame = parentPath:FindFirstChild("UnibarLeftFrame")
    if unibarLeftFrame then
        local stackedElements = unibarLeftFrame:FindFirstChild("StackedElements")
        if stackedElements then
            button.Parent = stackedElements
        else
            warn("StackedElements not found in UnibarLeftFrame.")
        end
    else
        warn("UnibarLeftFrame not found in TopBarApp.")
    end
else
    warn("TopBarApp not found in CoreGui.")
end

-- Function to minimize Fluent GUI when the button is clicked
button.MouseButton1Click:Connect(function()
    local originalSize = button.Size

    local tweenService = game:GetService("TweenService")
    local popTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local shrinkTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    local popGoal = {Size = UDim2.new(0, 55, 0, 55)}
    local popTween = tweenService:Create(button, popTweenInfo, popGoal)

    local shrinkGoal = {Size = originalSize}
    local shrinkTween = tweenService:Create(button, shrinkTweenInfo, shrinkGoal)

    if Window and Window.Minimize then
        Window:Minimize() 
    else
        warn("Fluent GUI window not found or minimize function unavailable!")
    end

    popTween:Play()
    popTween.Completed:Connect(function()
        shrinkTween:Play()
    end)
end)

-------------------------------------------------------------------------

local function safezone()
    if not workspace:FindFirstChild("_map") then
        print("no map detected")
        return
    end

    for _, child in ipairs(workspace._map:GetChildren()) do
        if child:FindFirstChild("snow") then
            child.snow:Destroy()
        end
    end
    
    if workspace._map.player:FindFirstChild("Beacon") then
        workspace._map.player.Beacon:Destroy()
    end
    
    local area = workspace._map.player:FindFirstChild("area")
    if area then
        area.BrickColor = BrickColor.new("Lime green")
        area.Color = Color3.fromRGB(0, 255, 0)
        area.Size = Vector3.new(0.3, 15, 15)
        area.Shape = Enum.PartType.Block
        
        local attachment = area:FindFirstChild("Attachment")
        if attachment then
            attachment:Destroy()
        end
    end
    
    for _, bisaya in ipairs(workspace._map:GetChildren()) do
        if bisaya:IsA("Model") then
            for _, child in ipairs(bisaya:GetChildren()) do
                if child.Name == "Model" or child.Name == "side" then
                    child:Destroy()
                end
            end
        end
    end
    
    for _, child in ipairs(workspace._map:GetChildren()) do
        if child:IsA("MeshPart") then
            child:Destroy()
        end
    end
    
    local wind_beams = workspace._map:FindFirstChild("_wind_beams")
    if wind_beams then
        wind_beams:Destroy()
    end
    
    local folder = workspace._map:FindFirstChild("Folder")
    if folder then
        folder:Destroy()
    end
end

--FROZEN MATCHMAKE
local function ChristmasFindMatch()
    local args = {
        [1] = "christmas_event"
    }
    
    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer(unpack(args))
end

--ANTILAG
local function AntiLag()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    -- Apply settings to parts, meshes, decals, etc.
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end

    -- Remove new objects like forcefields, sparkles, etc.
    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA('ForceField') then
                child:Destroy()
            elseif child:IsA('Sparkles') then
                child:Destroy()
            elseif child:IsA('Smoke') or child:IsA('Fire') then
                child:Destroy()
            end
        end)
    end)
    local Lighting = game:GetService("Lighting") -- Ensure Lighting is properly referenced
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    
    -- Terrain settings
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    
    -- Lighting settings
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
	Lighting.Brightness = 1
    print("ANTILAG ON")
end

----------------------------------------------------------------------

local function XmasStarSummon()
    local args = {
        [1] = "Christmas2024",
        [2] = "gems"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_from_banner:InvokeServer(unpack(args))
end

----------------------------------------------------------------------

local runService = game:GetService("RunService")
local deleteLoop

local function StartDeleteEnemies()
    local unitsFolder = workspace:FindFirstChild("_UNITS")
    if not unitsFolder then
        warn("_UNITS folder not found in workspace.")
        return
    end

    deleteLoop = runService.Heartbeat:Connect(function()
        for _, child in ipairs(unitsFolder:GetChildren()) do
            if child:IsA("Model") and child.Name:sub(1, 9) == "christmas" then
                child:Destroy()
            end
        end
    end)
end

local function StopDeleteEnemies()
    if deleteLoop then
        deleteLoop:Disconnect()
        deleteLoop = nil
    end
end

-------------------------------------------------------------------------

do
    Tabs.Main:AddParagraph({
        Title = "AUTO JOIN",
        Content = "AUTO JOIN GAME"
    })

    Tabs.Optimize:AddParagraph({
        Title = "OPTIMIZER",
        Content = "ANTILAG"
    })

    Tabs.Summon:AddParagraph({
        Title = "AUTO SUMMON",
        Content = "NIGGRO"
    })

    local XmasFindMatchState = settings["XmasFindMatch"] or false
    local XmasFindMatch = Tabs.Main:AddToggle("FindMatch", {
        Title = "Christian FindMatch",
        Default = XmasFindMatchState,
    })

    local SafezoneState = settings["Safezone"] or false
    local Safezone = Tabs.Main:AddToggle("Safezone", {
        Title = "Safezone Abyss",
        Default = SafezoneState,
    })

    local SummonState = settings["Summon"] or false
    local ToggleSummon = Tabs.Summon:AddToggle("Summon Toggle", {
        Title = "Auto Xmas Star",
        Default = SummonState
    })

	local AntiLagState = settings["Antilag"] or false
    local ToggleAntiLag = Tabs.Optimize:AddToggle("Antilag", {
        Title = "Anti Lag",
        Default = AntiLagState
    })

    local DeleteEnemyState = settings["DeleteEnemies"] or false
    local DeleteEnemiesToggle = Tabs.Optimize:AddToggle("DeleteEnemies", {
        Title = "Delete Enemies",
        Default = DeleteEnemyState,
    })

    XmasFindMatch:OnChanged(function(isEnabled)
        XmasFindMatchState = isEnabled
        settings["XmasFindMatch"] = isEnabled
        saveSettings(settings)
    
        if XmasFindMatchState then
            wait(5)
            ChristmasFindMatch()
        end
    end)

    Safezone:OnChanged(function(isEnabled)
        SafezoneState = isEnabled
        settings["Safezone"] = isEnabled
        saveSettings(settings)
    
        if SafezoneState then
            safezone()
        end
    end)

	ToggleAntiLag:OnChanged(function(isEnabled)
        AntiLagState = isEnabled
        settings["Antilag"] = isEnabled
        saveSettings(settings)

        if AntiLagState then
            AntiLag()
        end
    end)

    ToggleSummon:OnChanged(function(isEnabled)
        SummonState = isEnabled
        settings["Summon"] = isEnabled
        saveSettings(settings)

        if SummonState then
	    Window:Minimize()
            while SummonState do
                XmasStarSummon()
                wait(0.1)
                if not SummonState then
                    break
                end
            end
        end
    end)

    DeleteEnemiesToggle:OnChanged(function(isEnabled)
        DeleteEnemyState = isEnabled
        settings["DeleteEnemies"] = isEnabled
        saveSettings(settings)
    
        if DeleteEnemyState then
            StartDeleteEnemies()
        else
            StopDeleteEnemies()
        end
    end)
end
