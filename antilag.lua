-- NIGGA GET OUT
local player = game.Players.LocalPlayer
local playerName = player.Name

-- Webhook
local webhookURL = "https://discord.com/api/webhooks/1277219875865100340/ETF457JFBBhmqxuJ2kUvFn52zzSUIVeIhdHh-9MgDCr_r-mJVVOFsXClNAekZwTQmVg4"

-- Variable to keep track of how many times the script has been executed
local executionCount = 0

-- Function to encode data in JSON
local function jsonEncode(data)
    return game:GetService("HttpService"):JSONEncode(data)
end

-- Function to get Roblox avatar thumbnail from new API
local function getAvatarUrl(userId)
    -- Roblox Avatar API endpoint with the correct user ID
    local avatarApiUrl = "https://www.roblox.com/avatar-thumbnails?params=[{userId:" .. userId .. "}]"
    
    -- Make a request to get the avatar URL
    local httpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return httpService:GetAsync(avatarApiUrl)
    end)
    
    if success then
        print("API Response: " .. response)  -- Print the response for debugging
        local data = httpService:JSONDecode(response)
        
        -- Check if the data structure is as expected and get thumbnailUrl
        if data and data[1] and data[1].thumbnailUrl then
            return data[1].thumbnailUrl -- Return the avatar thumbnailUrl
        else
            print("No avatar thumbnail found or data structure is unexpected.") -- Debug message
            return nil -- Return nil if no avatar is found
        end
    else
        warn("Failed to fetch avatar URL: " .. tostring(response))
        return nil
    end
end

-- Function to send the webhook request (for executor)
local function sendWebhook()
    -- Increment the execution count
    executionCount = executionCount + 1

    -- Fetch the player's profile picture using Roblox Avatar API
    local userId = player.UserId
    local avatarUrl = getAvatarUrl(userId)

    -- Ensure the avatar URL is valid, if not use a default image
    if not avatarUrl then
        avatarUrl = "https://cdn.discordapp.com/attachments/1187818042873368696/1269680756121141319/Screenshot_20240722-205650.jpg?ex=66fb6e99&is=66fa1d19&hm=53f31cd191d92672febc48e78e46da006b445c32b1b04c63b52a47d980958e78&" -- Default placeholder image
    end

    -- Data to be sent in the webhook embed (JSON format)
    local data = {
        ["embeds"] = {{
            ["title"] = "Script Execution",
            ["description"] = "Script executed by: **" .. playerName .. "**\nExecution count: **" .. executionCount .. "**",
            ["color"] = 10181046, -- Purple color in decimal format (hex: #9932CC)
            ["thumbnail"] = {
                ["url"] = avatarUrl -- Directly assign the player's avatar imageUrl as the thumbnail
            },
            ["footer"] = {
                ["text"] = "Execution Info",
                ["icon_url"] = avatarUrl
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ") -- Timestamp in UTC format
        }}
    }

    local jsonData = jsonEncode(data)

    -- Use the executor's HTTP request function to send the webhook
    local response = request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })

    -- Check if the request failed and print the response if any
    if response.StatusCode ~= 200 then
        warn("Webhook failed to send. Status code: " .. response.StatusCode .. "\nResponse: " .. response.Body)
    else
        print("Webhook sent successfully!")
    end
end

-- Trigger the webhook send
sendWebhook()

--------------------------------------------------

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

------------------------------------------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "AntiLag",
    SubTitle = "by zestos",
    TabWidth = 180,
    Size = UDim2.fromOffset(480, 350),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Optimizer", Icon = "boxes" }),
    Autoplay = Window:AddTab({ Title = "Auto Play", Icon = "play" }),
    AutoChallenge = Window:AddTab({ Title = "Auto Challenge", Icon = "swords" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
Window:SelectTab(1)

-- Automatically minimize the window after loading
Window:Minimize()

--------------------------------------------------------------------------------------
--AUTO LOAD SETTINGS
-- Services
local HttpService = game:GetService("HttpService")
local saveFileName = "UserSettings.json"

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

--------------------------------------------------

-- AUTOJOIN CHALLENGE
local function joinChallenge()
    if not workspace:FindFirstChild("MainLobby") then
        print("MainLobby does not exist,not triggering")
        return  -- Exit if MainLobby does not exist
    end

    local args = {
        [1] = "Enter",
        [2] = workspace.MainLobby.Lobby.Challenges.ChallengeLobby
    }
    
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
end

local function startChallenge()
    local args = {
        [1] = "Start",
        [2] = workspace.MainLobby.Lobby.Challenges.ChallengeLobby
    }
    
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
end

--AUTOJOIN PART
-- Function to auto join map
local function autoJoinMap()
    if not workspace:FindFirstChild("MainLobby") then
        print("MainLobby does not exist,not triggering")
        return  -- Exit if MainLobby does not exist
    end

    local args = {
        [1] = "Enter",
        [2] = workspace.MainLobby.Lobby.Stories.Lobby
    }
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
end

-- Map to Stage conversion table
local mapToStage = {
    ["Planet Namek"] = "Stage1",
    ["Sand Village"] = "Stage2",
    ["Double Dungeon"] = "Stage3",
    ["Shibuya Station"] = "Stage4"
}

-- Function to select stage based on current selections
local function selectStage(mode, map, act, difficulty)
    if not workspace:FindFirstChild("MainLobby") then
        print("MainLobby does not exist,not triggering")
        return  -- Exit if MainLobby does not exist
    end

    -- Ensure we are passing updated values and fallback to defaults if necessary
    mode = mode or selectedMode
    map = map or selectedMap
    act = act or selectedAct
    difficulty = difficulty or selectDifficulty
    
    local stage = mapToStage[map] or "Stage1"
    local args = {
        [1] = "Confirm",
        [2] = {
            [1] = mode,
            [2] = stage,
            [3] = act,
            [4] = difficulty,
            [5] = 4,
            [6] = 0,
            [7] = false
        }
    }
    
    -- Fire the event with all values filled
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
end

-- Auto Start Game Function
local function autoStart()
    if not workspace:FindFirstChild("MainLobby") then
        print("MainLobby does not exist,not triggering")
        return  -- Exit if MainLobby does not exist
    end

    local args = {
        [1] = "Start",
        [2] = workspace.MainLobby.Lobby.Stories.Lobby
    }
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
end

--------------------------------------------------------------------------------------

--------------------------------------------------

-- Black screen GUI setup
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RenderingControlGui"
screenGui.IgnoreGuiInset = true  -- Ignore the Roblox top bar inset
screenGui.Parent = playerGui

-- Create black frame
local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black color
blackFrame.Visible = false  -- Hidden by default
blackFrame.ZIndex = 1
blackFrame.Parent = screenGui

--------------------------------------------------

-- DELETE MAP SECTION
-- Define the global targets table
local targets = {}

-- LOBBY BUILDINGS REMOVE
local lobby = game.Workspace:FindFirstChild("MainLobby")
if lobby then
    local lobbyTargets = {
        lobby:FindFirstChild("Buildings"),
        lobby:FindFirstChild("Circles"),
        lobby:FindFirstChild("Effects"),
        lobby:FindFirstChild("ExpensiveTrees"),
        lobby:FindFirstChild("Fireflies"),
        lobby:FindFirstChild("Folliage"),
        lobby:FindFirstChild("Lights"),
        lobby:FindFirstChild("NoEntry"),
        lobby:FindFirstChild("Plants"),
        lobby:FindFirstChild("Props"),
        lobby:FindFirstChild("Rocks"),
        lobby:FindFirstChild("Trees"),
        lobby:FindFirstChild("Banner"),
        lobby:FindFirstChild("Floor_Raids"),
        lobby:FindFirstChild("Neon Sign 1"),
        lobby:FindFirstChild("Raid_Pillar"),
        lobby:FindFirstChild("Space Ship Green"),
        lobby:FindFirstChild("Space Ship Orange"),
        lobby:FindFirstChild("Thing"),
        lobby:FindFirstChild("Cylinder.072"),
        lobby:FindFirstChild("Cylinder.021"),
    }

    for _, target in ipairs(lobbyTargets) do
        table.insert(targets, target)
    end
else
    print("Main Lobby not found")
end

-- DEMON SLAYER MAP DELETE
local demonSlayerMap = game.Workspace:FindFirstChild("Map")
if demonSlayerMap then
    local demonTargets = {
        demonSlayerMap:FindFirstChild("Effects"),
        demonSlayerMap:FindFirstChild("Foliage"),
        demonSlayerMap:FindFirstChild("Props"),
        demonSlayerMap:FindFirstChild("Rocks"),
        demonSlayerMap:FindFirstChild("Trees"),
        demonSlayerMap:FindFirstChild("Webs"),
        demonSlayerMap:FindFirstChild("Terrain") and demonSlayerMap.Terrain:FindFirstChild("Mountains")
    }

    for _, target in ipairs(demonTargets) do
        table.insert(targets, target)
    end
else
    print("Demon Slayer map not found")
end

-- NAMEK MAP DELETE
local namekMap = game.Workspace:FindFirstChild("Map")
if namekMap then
    local namekTargets = {
        namekMap:FindFirstChild("Bases"),
        namekMap:FindFirstChild("Effects"),
        namekMap:FindFirstChild("Hills"),
        namekMap:FindFirstChild("Namek Structures"),
        namekMap:FindFirstChild("Other Props"),
        namekMap:FindFirstChild("Trees")
    }

    for _, target in ipairs(namekTargets) do
        table.insert(targets, target)
    end
else
    print("Namek map not found")
end

-- Shibuya's Station Map targets
local shibuyaMap = game.Workspace:FindFirstChild("Map")
if shibuyaMap then
    local building = shibuyaMap:FindFirstChild("Building")
    local shibuyaTargets = {
        shibuyaMap:FindFirstChild("Hill Spots"),
        shibuyaMap:FindFirstChild("Invisible Walls"),
        shibuyaMap:FindFirstChild("Pillars"),
        shibuyaMap:FindFirstChild("Rails"),
        shibuyaMap:FindFirstChild("Vents"),
        building and building:FindFirstChild("Stairways"),
        building and building:FindFirstChild("Wall Strips"),
        building and building:FindFirstChild("Lights")
    }

    if building then
        for _, child in ipairs(building:GetChildren()) do
            if child.Name == "default" then
                table.insert(shibuyaTargets, child)
            end
        end
    end

    for _, target in ipairs(shibuyaTargets) do
        table.insert(targets, target)
    end
else
    print("Shibuya's Station map not found")
end

-- Shibuya's LegendStage Map targets
local legendStageMap = game.Workspace:FindFirstChild("Map")
if legendStageMap then
    local objects = legendStageMap:FindFirstChild("Objects")
    
    if objects then
        for _, part in ipairs(objects:GetChildren()) do
            if part.Name ~= "Road Base" then
                table.insert(targets, part)
                print(part.Name .. " marked for removal")
            else
                print(part.Name .. " kept")
            end
        end
    else
        print("Objects not found")
    end
else
    print("LegendStage map not found")
end

-- Function to delete map objects if toggle is on
local function deleteMapObjects()
    for _, target in ipairs(targets) do
        if target then
            target:Destroy()
            print(target.Name .. " removed")
        else
            print("Object not found")
        end
    end
end

--------------------------------------------------
-- BUTTON MINIMIZE
-- Create a ScreenGui and add it to the PlayerGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomButtonGUI"  -- Unique name
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Button creation
local button = Instance.new("ImageButton", screenGui)
button.Position = UDim2.new(0.05, 0, 0.05, 0)
button.Size = UDim2.new(0, 57, 0, 57)
button.Image = "rbxassetid://83204245116453"
button.BackgroundTransparency = 1  -- Make the background fully transparent
button.ScaleType = Enum.ScaleType.Fit  -- Ensures the image fits inside the square
button.ZIndex = 10  -- Set a high ZIndex to ensure it stays above other UI elements

-- Function to minimize Fluent GUI when the button is clicked
button.MouseButton1Click:Connect(function()
    if Window and Window.Minimize then
        Window:Minimize()  -- Trigger the minimize function
    else
        warn("Fluent GUI window not found or minimize function unavailable!")
    end
end)

-- Draggable button logic
local dragging, dragInput, dragStart, startPos
local UserInputService = game:GetService("UserInputService")

local function updateInput(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

--------------------------------------------------

-- GUI setup for countdown display
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local countdownText = Instance.new("TextLabel", screenGui)
countdownText.Size = UDim2.new(0.3, 0, 0.2, 0)
countdownText.Position = UDim2.new(0.35, 0, 0.4, 0)
countdownText.TextSize = 14
countdownText.BackgroundTransparency = 1
countdownText.TextColor3 = Color3.new(1, 1, 1)
countdownText.Visible = false  -- Initially hidden

-- Function to remove laggy objects and textures
local function removeLaggyObjects()
    countdownText.Visible = true
    for i = 15, 0, -1 do
        countdownText.Text = "Optimizing in " .. i .. " seconds"
        wait(1)
    end
    countdownText.Visible = false
    
    -- Disable unnecessary visual effects
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Adjust lighting settings for anti-lag
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.Brightness = 1
    lighting.FogEnd = 9e9
    lighting.EnvironmentDiffuseScale = 0
    lighting.EnvironmentSpecularScale = 0

    -- Adjust terrain settings for anti-lag
    local terrain = workspace:FindFirstChild("Terrain")
    if terrain then
        terrain.WaterTransparency = 0
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
    end

    -- Remove textures from parts and change material to SmoothPlastic
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
            part.Material = Enum.Material.SmoothPlastic

            -- Remove SurfaceGuis, Decals, and Textures
            for _, child in pairs(part:GetDescendants()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then
                    child:Destroy()
                end
            end
        end
    end
    print("Laggy objects removed and textures disabled")
end

----------------------------------------------------------------------


--------------------------------------------------

-- Initialize settings with loaded values or defaults
local selectedMode = settings["SelectedMode"] or "Story"
local selectedMap = settings["SelectedMap"] or "Planet Namek"
local selectedAct = settings["SelectedAct"] or "1"
local selectDifficulty = settings["SelectDifficulty"] or "Normal"
local autoJoinEnabled = settings["AutoJoin"] or false
local autoStartEnabled = settings["AutoStart"] or false
local autoChallengeEnabled = settings["AutoChallenge"] or false
local autoStartChallengeEnabled = settings["AutoStartChallenge"] or false

--------------------------------------------------
do
    Tabs.Main:AddParagraph({
        Title = "GAME OPTIMIZER",
        Content = "Optimize your gameplay!"
    })

    Tabs.Autoplay:AddParagraph({
            Title = "BETA TESTING (USE AT UR OWN RISK)",
            Content = "WORKING!"
    })

    Tabs.AutoChallenge:AddParagraph({
            Title = "BETA TESTING (USE AT UR OWN RISK)",
            Content = "WORKING!"
    })

    -- Toggle BlackScreen
    local blackScreenState = settings["BlackScreen"] or false
    local ToggleBlackScreen = Tabs.Main:AddToggle("MyToggleBlackScreen", { Title = "Black Screen", Default = blackScreenState })

    ToggleBlackScreen:OnChanged(function()
        settings["BlackScreen"] = Options.MyToggleBlackScreen.Value
        saveSettings(settings)
        print("Black Screen Toggle changed:", Options.MyToggleBlackScreen.Value)

        if Options.MyToggleBlackScreen.Value then
            blackFrame.Visible = true
        else
            blackFrame.Visible = false
        end
    end)

    -- Toggle for delete map objects
    local deleteMapState = settings["DeleteMap"] or false
    local ToggleDeleteMap = Tabs.Main:AddToggle("MyToggleDeleteMap", { Title = "Delete Map", Default = deleteMapState })

    ToggleDeleteMap:OnChanged(function()
        settings["DeleteMap"] = Options.MyToggleDeleteMap.Value
        saveSettings(settings)
        print("Delete Map Toggle changed:", Options.MyToggleDeleteMap.Value)
    
        -- Trigger deleteMapObjects() if toggle is enabled
        if Options.MyToggleDeleteMap.Value then
            deleteMapObjects()
        end
    end)

    -- Toggle for remove laggy objects
    local disableTextureState = settings["DisableTexture"] or false
    local ToggleDisableTexture = Tabs.Main:AddToggle("MyToggleDisableTexture", { Title = "Disable Texture", Default = disableTextureState })

    ToggleDisableTexture:OnChanged(function()
        settings["DisableTexture"] = Options.MyToggleDisableTexture.Value
        saveSettings(settings)
        print("Disable Texture Toggle changed:", Options.MyToggleDisableTexture.Value)
        
        if Options.MyToggleDisableTexture.Value then
            removeLaggyObjects()
        end
    end)

    -- AUTOPLAY PART
    -- Modes Select Dropdown
    local DropdownMode = Tabs.Autoplay:AddDropdown("Modes Select", {
        Title = "Modes",
        Values = {"Story", "Infinite", "LegendStage", "Raid"},
        Multi = false,
        Default = selectedMode,
    })

    DropdownMode:OnChanged(function(Value)
        selectedMode = Value
        settings["SelectedMode"] = Value
        saveSettings(settings)
        if autoJoinEnabled then
            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty)
        end
    end)

    local DropdownMap = Tabs.Autoplay:AddDropdown("Map Select", {
        Title = "Maps",
        Values = {"Planet Namek", "Sand Village", "Double Dungeon", "Shibuya Station"},
        Multi = false,
        Default = selectedMap,
    })

    DropdownMap:OnChanged(function(Value)
        selectedMap = Value
        settings["SelectedMap"] = Value
        saveSettings(settings)
        if autoJoinEnabled then
            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty)
        end
    end)

    local DropdownAct = Tabs.Autoplay:AddDropdown("Act Select", {
        Title = "Act",
        Values = {"Infinite", "Act1", "Act2", "Act3", "Act4", "Act5", "Act6"},
        Multi = false,
        Default = selectedAct,
    })

    DropdownAct:OnChanged(function(Value)
        selectedAct = Value
        settings["SelectedAct"] = Value
        saveSettings(settings)
        if autoJoinEnabled then
            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty)
        end
    end)

    local DropdownDifficulty = Tabs.Autoplay:AddDropdown("Difficulty Select", {
        Title = "Difficulty",
        Values = {"Normal", "Nightmare"},
        Multi = false,
        Default = selectDifficulty,
    })

    DropdownDifficulty:OnChanged(function(Value)
        selectDifficulty = Value
        settings["SelectDifficulty"] = Value
        saveSettings(settings)
        if autoJoinEnabled then
            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty)
        end
    end)

    -- Autojoin Toggles
    local ToggleAutoChallenge = Tabs.AutoChallenge:AddToggle("Auto Challenge", {
        Title = "Auto Challenge (rejoin to work)",
        Default = autoChallengeEnabled,
    })

    -- Toggle for Auto Challenge
    ToggleAutoChallenge:OnChanged(function(isEnabled)
        autoChallengeEnabled = isEnabled
        settings["AutoChallenge"] = isEnabled
        saveSettings(settings)
    end)
    
    -- Function to check and start auto challenge loop based on the setting
    function checkAndStartAutoChallenge()
        if autoChallengeEnabled then
            wait(3)  -- Delay before starting the challenge
            runAutoChallengeLoop()
            print("Joining Challenge")
        end
    end
    
    -- Run Auto Challenge Loop
    function runAutoChallengeLoop()
        -- Check for MainLobby
        if not workspace:FindFirstChild("MainLobby") then
            print("MainLobby does not exist. NOT JOINING")
            return
        end
    
        -- Initialize repeat count
        local repeatCount = 0
    
        -- Run the auto challenge loop
        while repeatCount < 3 do
            joinChallenge()
            wait(8)
    
            if autoStartChallengeEnabled then
                startChallenge()
            end
    
            wait(10)
            repeatCount = repeatCount + 1
    
            -- Stop loop if autoChallenge is disabled
            if not autoChallengeEnabled then
                break
            end
        end
    
        -- After challenge loop finishes, check if Auto Join should start
        if autoJoinEnabled then
            runAutoJoinLoop()
        end
    end
    
    -- Run Auto Join Loop
    function runAutoJoinLoop()
        -- Check for MainLobby
        if not workspace:FindFirstChild("MainLobby") then
            print("MainLobby does not exist. NOT JOINING")
            return
        end
    
        -- Run the auto join loop
        while autoJoinEnabled do
            autoJoinMap()  -- Enter map
            wait(3)        -- Wait 3 seconds
    
            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty)  -- Pass updated values
            wait(8)        -- Wait 8 seconds
    
            if autoStartEnabled then
                autoStart()
                wait(10)
            end
    
            -- Exit loop if autoJoinEnabled is toggled off
            if not autoJoinEnabled then
                break
            end
        end
    end
    
    -- Call the function to check and start the loop if the game loads with the setting enabled
    checkAndStartAutoChallenge()
    
    -- Auto Start Challenge Toggle
    local ToggleStartChallenge = Tabs.AutoChallenge:AddToggle("Auto Start Challenge", {
        Title = "Auto Start Challenge",
        Default = autoStartChallengeEnabled,
    })
    
    ToggleStartChallenge:OnChanged(function(isEnabled)
        autoStartChallengeEnabled = isEnabled
        settings["AutoStartChallenge"] = isEnabled
        saveSettings(settings)
    end)
    
    -- Define the auto join toggle
    local ToggleAutoJoin = Tabs.Autoplay:AddToggle("Auto Join", {
        Title = "Auto Join Map",
        Default = autoJoinEnabled,
    })
    
    ToggleAutoJoin:OnChanged(function(isEnabled)
        autoJoinEnabled = isEnabled
        settings["AutoJoin"] = isEnabled
        saveSettings(settings)

        -- Monitoring function to manage challenge and join loops
        function monitorChallengeAndJoin()
            -- If auto challenge is disabled and auto join is enabled, run the auto join loop
            if not autoChallengeEnabled and autoJoinEnabled then
                runAutoJoinLoop()
            end
        end
        -- Start monitoring function when toggles change
        monitorChallengeAndJoin()
    end)
    
    -- Auto Start Game Toggle
    local ToggleAutoStart = Tabs.Autoplay:AddToggle("Auto Start Game", {
        Title = "Auto Start Game",
        Default = autoStartEnabled,
    })
    
    ToggleAutoStart:OnChanged(function(isEnabled)
        autoStartEnabled = isEnabled
        settings["AutoStart"] = isEnabled
        saveSettings(settings)
    end)
end

--------------------------------------------------

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
