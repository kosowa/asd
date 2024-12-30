--v3.8
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Ensure the player's character exists in the Workspace
local character = workspace:WaitForChild(localPlayer.Name)
local vipGradient = character:WaitForChild("Head")
    :WaitForChild("_overhead")
    :WaitForChild("Frame")
    :WaitForChild("Name_Frame")
    :WaitForChild("Name_Text")
    :WaitForChild("VIP_Gradient")

local titleRename = character:WaitForChild("Head")
    :WaitForChild("_overhead")
    :WaitForChild("Frame")
    :WaitForChild("TitleFrame")
    :WaitForChild("Title_Text")

-- Set the title text
titleRename.Text = "MCNRS ON TOP"

-- Enable the gradient
vipGradient.Enabled = true

-- Define rainbow colors
local colors = {
    Color3.new(1, 0, 0),   -- Red
    Color3.new(1, 0.5, 0), -- Orange
    Color3.new(1, 1, 0),   -- Yellow
    Color3.new(0, 1, 0),   -- Green
    Color3.new(0, 1, 1),   -- Cyan
    Color3.new(0, 0, 1),   -- Blue
    Color3.new(0.5, 0, 1), -- Purple
}

local totalSteps = 100
local animationSpeed = 0.02
local step = 0

-- Function to interpolate colors
local function interpolateColors(colors, step, totalSteps)
    local totalColors = #colors
    local progress = step / totalSteps
    local keypoints = {}

    for i = 1, totalColors do
        local currentIndex = ((progress + (i - 1) / totalColors) % 1) * totalColors
        local lowerIndex = math.floor(currentIndex) + 1
        local upperIndex = (lowerIndex % totalColors) + 1

        local lerpFactor = currentIndex % 1
        local startColor = colors[lowerIndex]
        local endColor = colors[upperIndex]
        local interpolatedColor = startColor:Lerp(endColor, lerpFactor)

        table.insert(keypoints, ColorSequenceKeypoint.new((i - 1) / (totalColors - 1), interpolatedColor))
    end

    return ColorSequence.new(keypoints)
end

-- Gradient animation
local function startGradientAnimation()
    RunService.RenderStepped:Connect(function()
        step = (step + 1) % totalSteps
        vipGradient.Color = interpolateColors(colors, step, totalSteps)
    end)
end

startGradientAnimation()
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
    Optimize = Window:AddTab({ Title = "|  Optimizer", Icon = "boxes" }),
    Buffer = Window:AddTab({ Title = "|  Buffer", Icon = "swords" }),
    Cards = Window:AddTab({ Title = "|  Cards", Icon = "book" }),
    Main = Window:AddTab({ Title = "|  Event", Icon = "play" }),
    Summon = Window:AddTab({ Title = "|  Summon", Icon = "coins" }),
    Misc = Window:AddTab({ Title = "|  Misc", Icon = "square" }),
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

------------------------------------------------------------------

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

function configureFocusWave()
    -- credit from : Bocchi World
    getgenv().FocusWave = 5 -- Priority limit wave
    getgenv().PriorityCards = { -- Priority tags when wave = FocusWave
        "+ Range I",
        "- Cooldown I",
        "+ Attack I",
        "+ Gain 2 Random Effects Tier 1",
        "- Cooldown II",
        "+ Range II",
        "+ Attack II",
        "+ Gain 2 Random Effects Tier 2",
        "- Cooldown III",
        "+ Range III",
        "+ Attack III",
        "+ Gain 2 Random Effects Tier 3"
    }
    getgenv().Cards = { -- All cards after FocusWave wave ends
        "+ Explosive Deaths I",
        "+ Explosive Deaths II",
        "+ Explosive Deaths III",
        "+ Gain 2 Random Curses Tier 3",
        "+ Gain 2 Random Curses Tier 2",
        "+ Gain 2 Random Curses Tier 1",
        "+ Enemy Speed III",
        "+ Enemy Speed II",
        "+ Enemy Regen III",
        "+ Enemy Shield III",
        "+ Enemy Health III",
        "+ Enemy Regen II",
        "+ Enemy Shield II",
        "+ Enemy Regen I",
        "+ Enemy Speed I",
        "+ Enemy Shield I",
        "+ Enemy Health II",
        "+ Enemy Health I",
        "+ Yen I",
        "+ Yen II",
        "+ Yen III",
        "+ Boss Damage I",
        "- Cooldown I",
        "+ Gain 2 Random Effects Tier 1",
        "+ Range I",
        "+ Attack I",
        "- Cooldown II",
        "+ Boss Damage II",
        "+ Boss Damage III",
        "- Cooldown III",
        "+ Gain 2 Random Effects Tier 2",
        "+ Range II",
        "+ Attack II",
        "+ Gain 2 Random Effects Tier 3",
        "+ Range III",
        "+ Attack III",
        "+ New Path"
    }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bocchi-World/Bocchi-Main/refs/heads/main/pickcard.lua"))()
end

-------------------------------------------------------------------------

local function Reconnect()
    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        wait(2)
        game:GetService("TeleportService"):Teleport(8304191830)
    end)
end

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

local function autoBuff()
    -- Configuration
    local Identifier = {
        ["Erwin"] = "erwin",
        ["Wendy"] = "wendy",
        ["Leafa"] = "leafa_evolved",
    }
    local Delay = 16.4

    -- Ensure the game is loaded
    repeat task.wait() until game:IsLoaded()
    if game.PlaceId == 8304191830 then return end
    repeat task.wait() until workspace:WaitForChild("_waves_started").Value == true

    -- Services and dependencies
    local Player = game:GetService("Players").LocalPlayer
    local GameFinished = game:GetService("Workspace"):WaitForChild("_DATA"):WaitForChild("GameFinished")
    local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
    local ItemInventoryService = Loader.load_client_service(script, "ItemInventoryServiceClient")

    -- Auto Buff logic
    for ID, Name in pairs(Identifier) do
        local Start = false
        for _, UUID in pairs(ItemInventoryService["session"]["collection"]["collection_profile_data"]["equipped_units"]) do
            if ItemInventoryService["session"]["collection"]["collection_profile_data"]["owned_units"][UUID]["unit_id"] == Name then
                Start = true
                break
            end
        end
        if Start then
            task.spawn(function()
                if getgenv().Library then
                    getgenv().Library:Notify("Auto Buff [" .. ID .. "] Started", 5)
                else
                    print("Auto Buff [" .. ID .. "] Started")
                end
                repeat
                    task.wait()
                    if GameFinished.Value then break end
                    local Container = {}

                    for _, Unit in pairs(game:GetService("Workspace"):WaitForChild("_UNITS"):GetChildren()) do
                        if GameFinished.Value then break end
                        if Unit:WaitForChild("_stats"):WaitForChild("id").Value ~= Name then continue end
                        if Unit:WaitForChild("_stats"):WaitForChild("active_attack").Value == "nil" then continue end
                        if Unit:WaitForChild("_stats"):WaitForChild("player").Value == Player then
                            table.insert(Container, Unit)
                        end
                    end

                    if #Container == 4 then
                        local Broken = false
                        while not Broken do
                            task.wait()
                            for Idx = 1, 4 do
                                if GameFinished.Value then Broken = true break end
                                if #Container < 4 then Broken = true break end
                                if Container[Idx].Parent ~= game:GetService("Workspace"):WaitForChild("_UNITS") then
                                    Broken = true
                                    break
                                end
                                pcall(function()
                                    game:GetService("ReplicatedStorage")["endpoints"]["client_to_server"]["use_active_attack"]:InvokeServer(Container[Idx])
                                end)
                                task.wait(Delay)
                            end
                        end
                    end
                until GameFinished.Value
                if getgenv().Library then
                    getgenv().Library:Notify("Auto Buff [" .. ID .. "] Ended", 5)
                else
                    print("Auto Buff [" .. ID .. "] Ended")
                end
            end)
        end
    end
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
    Tabs.Optimize:AddParagraph({
        Title = "OPTIMIZER",
        Content = "ANTILAG"
    })

    Tabs.Buffer:AddParagraph({
        Title = "AUTO BUFF",
        Content = "ERWIN,WENDA,LEAFY"
    })

    Tabs.Cards:AddParagraph({
        Title = "AUTO CARD PICKER",
        Content = "JUANMEL BASCO PALAKITO"
    })

    Tabs.Main:AddParagraph({
        Title = "AUTO JOIN",
        Content = "AUTO JOIN GAME"
    })

    Tabs.Summon:AddParagraph({
        Title = "AUTO SUMMON",
        Content = "NIGGRO"
    })

    Tabs.Misc:AddParagraph({
        Title = "MISCELLANEOUS",
        Content = "NIGGRO"
    })

    local AutoReconnectState = settings["AutoReconnect"] or false
    local AutoReconnect = Tabs.Misc:AddToggle("AutoReconnect", {
        Title = "Auto Reconnect",
        Default = AutoReconnectState,
    })

    local XmasFindMatchState = settings["XmasFindMatch"] or false
    local XmasFindMatch = Tabs.Main:AddToggle("FindMatch", {
        Title = "Frozen Matchmake",
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
        Title = "FPS Boost",
        Default = AntiLagState
    })

    local AutoBuffState = settings["AutoBuff"] or false
    local AutoBuff = Tabs.Buffer:AddToggle("AutoBuff", {
        Title = "Better Buffer",
        Default = AutoBuffState,
    })

    local AutoCardState = settings["AutoCard"] or false
    local AutoCard = Tabs.Cards:AddToggle("AutoCard", {
        Title = "Card Picker",
        Default = AutoCardState,
    })

    local DeleteEnemyState = settings["DeleteEnemies"] or false
    local DeleteEnemiesToggle = Tabs.Optimize:AddToggle("DeleteEnemies", {
        Title = "Delete Entities",
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

    AutoReconnect:OnChanged(function(isEnabled)
        AutoReconnectState = isEnabled
        settings["AutoReconnect"] = isEnabled
        saveSettings(settings)
    
        if AutoReconnectState then
            Reconnect()
        end
    end)

    AutoBuff:OnChanged(function(isEnabled)
        AutoBuffState = isEnabled
        settings["AutoBuff"] = isEnabled
        saveSettings(settings)
    
        if AutoBuffState then
            autoBuff()
        end
    end)

    AutoCard:OnChanged(function(isEnabled)
        AutoCardState = isEnabled
        settings["AutoCard"] = isEnabled
        saveSettings(settings)
    
        if AutoCardState then
            configureFocusWave()
        end
    end)

    DeleteEnemiesToggle:OnChanged(function(isEnabled)
        DeleteEnemyState = isEnabled
        settings["DeleteEnemies"] = isEnabled
        saveSettings(settings)
    
        if DeleteEnemyState then
            StartDeleteEnemies()
            Window:Dialog({
                Title = "ATTENTION!",
                Content = "DO NOT USE DELETE ENTITIES WHEN RECORD MACRO",
                Buttons = {
                    {
                        Title = "YES BOSS",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    }
                }
            })
        else
            StopDeleteEnemies()
        end
    end)
end
