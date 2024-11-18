-- v2
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
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 280),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Optimizer", Icon = "boxes" }),
    BossRush = Window:AddTab({ Title = "Boss Rush", Icon = "calendar" }),
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
--Open Boss rush event
local player = game.Players.LocalPlayer

local function teleportToGojo()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    local humanoidRootPart = player.Character.HumanoidRootPart
    local targetPosition = Vector3.new(-294, 39, 617)
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local playerGui = player:WaitForChild("PlayerGui")

local function pressEnter()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function BossRush()
    teleportToGojo()
    wait(1)
    
    local clickGojo = playerGui:FindFirstChild("Gujo")
    local holder, button

    for i = 1, 5 do
        clickGojo = playerGui:FindFirstChild("Gujo")
        if clickGojo then
            holder = clickGojo:FindFirstChild("Holder")
            if holder then
                button = holder:FindFirstChild("Button")
                if button then
                    GuiService.SelectedObject = button
                    if GuiService.SelectedObject == button then
                        break
                    end
                end
            end
        end
        wait(0.5)
    end
    
    if GuiService.SelectedObject == button then
        wait(0.5)
        pressEnter()
    end
end



--select boss
local function sukuna()
    local player = game:GetService("Players").LocalPlayer
    local sukuna = player.PlayerGui.BossRush.SwitchButtons.SukonoEvent:FindFirstChild("Button")
    
    if sukuna then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = sukuna
        wait(1)
        pressEnter()
    end
end

local function igris()
    local player = game:GetService("Players").LocalPlayer
    local igris = player.PlayerGui.BossRush.SwitchButtons.IgrosEvent:FindFirstChild("Button")
    
    if igris then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = igris
        wait(1)
        pressEnter()
    end
end

local function clickStartButton()
    local player = game:GetService("Players").LocalPlayer
    local igris = player.PlayerGui.BossRush.SwitchButtons:FindFirstChild("IgrosEvent")
    local buttonStart = player.PlayerGui.BossRush.Holder.StageInfo.Buttons.Start:FindFirstChild("Button")

    if buttonStart then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = buttonStart
        wait(1)
        pressEnter()
    end
end

--AUTO START GAME FUNCTION
local detectionEnabled = false

local function startGame()
    if not detectionEnabled then return end

    local player = game:GetService("Players").LocalPlayer
    local GuiService = game:GetService("GuiService")

    local button = player:WaitForChild("PlayerGui")
        :WaitForChild("MiniLobbyInterface")
        :WaitForChild("Holder")
        :WaitForChild("Buttons")
        :WaitForChild("Start")
        :WaitForChild("Button")

    if button then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = button
        wait(0.1)
        pressEnter()
    end
end

local function onChildAdded(child)
    if detectionEnabled and child.Name == "MiniLobbyInterface" then
        startGame()
    end
end

local function enableStart()
    detectionEnabled = true
    print("auto start enabled")
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    if playerGui:FindFirstChild("MiniLobbyInterface") then
        startGame()
    end
end

local function disableStart()
    detectionEnabled = false
    print("auto start disabled")
end

local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
playerGui.ChildAdded:Connect(onChildAdded)

----------------------------------------------------------------------------
-- AUTOJOIN CHALLENGE
local player = game.Players.LocalPlayer

local function teleportToDaily()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        local targetPosition = Vector3.new(-258, 42, 683)
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end
local function teleportToChallenge()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        local targetPosition = Vector3.new(-236, 42, 683)
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

local function tpToChallenge()
    if not workspace:FindFirstChild("MainLobby") then
        print("MainLobby does not exist. NOT JOINING CHALLENGE")
        return
    end

    teleportToDaily()
    wait(0.7)
    teleportToChallenge()
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
--------------------------------------------------------------------------------------

--------------------------------------------------

-- Black screen GUI setup
local player = game.Players.LocalPlayer

-- Create ScreenGui in CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "zBLACKSCREEN"
screenGui.DisplayOrder = -1
screenGui.IgnoreGuiInset = true  -- Ignore the Roblox top bar inset
screenGui.Parent = game:GetService("CoreGui")  -- Parent to CoreGui for higher layering

-- Create black frame
local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black color
blackFrame.Visible = false  -- Start hidden
blackFrame.Parent = screenGui

-- Vertical layout to arrange items
local layout = Instance.new("UIListLayout")
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)  -- Space between rows
layout.Parent = blackFrame

-- Function to create a row with an image and a label
local function createRow(imageId, text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.5, 0, 0, 50)
    row.BackgroundTransparency = 1
    row.Parent = blackFrame

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rowLayout.Padding = UDim.new(0, 10)  -- Space between image and text
    rowLayout.Parent = row

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0, 50, 0, 50)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://" .. imageId
    image.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 50)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)  -- White color
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 24
    label.Text = text
    label.Parent = row

    return label
end

-- Create rows for Gems, Gold, and Rerolls
local gemsLabel = createRow("95858760477365", "GEMS: 0")
local goldLabel = createRow("75136334344816", "GOLD: 0")
local rerollsLabel = createRow("122851858665013", "REROLLS: 0")

-- Function to update text labels with Gems, Gold, and Rerolls values
local function updateText()
    local gems = player:GetAttribute("Gems") or 0
    local gold = player:GetAttribute("Gold") or 0
    local rerolls = player:GetAttribute("TraitRerolls") or 0

    gemsLabel.Text = tostring(gems)
    goldLabel.Text = tostring(gold)
    rerollsLabel.Text = tostring(rerolls)
end

-- Update the text when Gems, Gold, or Rerolls attributes change
player:GetAttributeChangedSignal("Gems"):Connect(updateText)
player:GetAttributeChangedSignal("Gold"):Connect(updateText)
player:GetAttributeChangedSignal("TraitRerolls"):Connect(updateText)

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
-- Create a ScreenGui and add it to CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomButtonGUI"  -- Unique name
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")  -- Parent to CoreGui for higher layering

-- Button creation
local button = Instance.new("ImageButton")
button.Position = UDim2.new(0.05, 0, 0.05, 0)
button.Size = UDim2.new(0, 57, 0, 57)
button.Image = "rbxassetid://83204245116453"  -- Set your image asset ID here
button.BackgroundTransparency = 1  -- Make the background fully transparent
button.ScaleType = Enum.ScaleType.Fit  -- Ensures the image fits inside the square
button.ZIndex = 10  -- Set a high ZIndex to ensure it stays above other UI elements
button.Parent = screenGui

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
            part.Material = Enum.Material.Glass

            -- Remove SurfaceGuis, Decals, and Textures
            for _, child in pairs(part:GetDescendants()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then
                    child:Destroy()
                end
            end
        -- If it's a MeshPart, set RenderFidelity to Performance
            if part:IsA("MeshPart") then
                part.RenderFidelity = Enum.RenderFidelity.Performance
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
local autoChallengeEnabled = settings["AutoChallenge"] or false
local selectedBoss = settings["SelectedBoss"] or "IGRIS"
local autoBossRush = settings["AutoBossRush"] or false

--------------------------------------------------
do
    Tabs.Main:AddParagraph({
        Title = "GAME OPTIMIZER",
        Content = "Optimize your gameplay!"
    })

    Tabs.BossRush:AddParagraph({
            Title = "JOIN BOSS EVENT",
            Content = "WORKING!"
    })

    Tabs.Autoplay:AddParagraph({
            Title = "BETA TESTING",
            Content = "WORKING!"
    })

    Tabs.AutoChallenge:AddParagraph({
            Title = "BETA TESTING",
            Content = "ENABLE AUTO JOIN MAP IN AUTO PLAY FIRST!"
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
            updateText()
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
    local AutoStartState = settings["AutoStart"] or false
    local ToggleAutoStart = Tabs.Autoplay:AddToggle("Auto Start Game", {
        Title = "Auto Start Lobbies",
        Default = AutoStartState,
    })
    
    ToggleAutoStart:OnChanged(function(isEnabled)
        AutoStartState = isEnabled
        settings["AutoStart"] = isEnabled
    
        -- Save the settings (ensure this works correctly)
        if saveSettings then
            saveSettings(settings)
        end
    
        -- Enable or disable the auto-start feature
        if AutoStartState then
            if enableStart then
                enableStart()
            end
        else
            if disableStart then
                disableStart()
            end
        end
    end)
    
    -- Modes Select Dropdown
    local DropdownMode = Tabs.Autoplay:AddDropdown("Modes Select", {
        Title = "Modes",
        Values = {"Story", "LegendStage", "Raid"},
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

    -- Auto Challenge Toggle
    local ToggleAutoChallenge = Tabs.AutoChallenge:AddToggle("Auto Challenge", {
        Title = "Auto Challenge",
        Default = autoChallengeEnabled,
    })

    ToggleAutoChallenge:OnChanged(function(isEnabled)
        autoChallengeEnabled = isEnabled
        settings["AutoChallenge"] = isEnabled
        saveSettings(settings)
    end)

    -- Function to handle Auto Challenge
    function runAutoChallenge(onComplete)
        if autoChallengeEnabled then
            local repeatCount = 0
            while repeatCount < 3 do
                tpToChallenge()
                wait(3)
                repeatCount = repeatCount + 1

                if not autoChallengeEnabled then
                    break
                end
            end
        end

        -- Callback to notify completion
        if onComplete then
            onComplete()
        end
    end

    -- Function to run Auto Join Loop
    function runAutoJoinLoop()
        -- Check for MainLobby
        if not workspace:FindFirstChild("MainLobby") then
            print("MainLobby does not exist. NOT JOINING")
            return
        end

        -- Run the Auto Join loop
        while autoJoinEnabled do
            autoJoinMap()
            wait(3)

            selectStage(selectedMode, selectedMap, selectedAct, selectDifficulty) -- Pass updated values
            wait(8)

            if not autoJoinEnabled then
                break
            end
        end
    end

    -- Auto Join Toggle
    local ToggleAutoJoin = Tabs.Autoplay:AddToggle("Auto Join", {
        Title = "Auto Join Map",
        Default = autoJoinEnabled,
    })

    ToggleAutoJoin:OnChanged(function(isEnabled)
        autoJoinEnabled = isEnabled
        settings["AutoJoin"] = isEnabled
        saveSettings(settings)

        if autoJoinEnabled then
            -- First run Auto Challenge if enabled, then proceed to Auto Join
            runAutoChallenge(function()
                if autoJoinEnabled then
                    runAutoJoinLoop()
                end
            end)
        end
    end)

    
    local DropdownBoss = Tabs.BossRush:AddDropdown("Select Boss", {
        Title = "Boss",
        Values = {"IGRIS", "SUKUNA",},
        Multi = false,
        Default = selectedBoss,
    })

    DropdownBoss:OnChanged(function(Value)
        selectedBoss = Value
        settings["SelectedBoss"] = Value
        saveSettings(settings)

    end)

    local ToggleBossRush = Tabs.BossRush:AddToggle("Auto Join Boss Rush", {
        Title = "Auto Boss Rush",
        Default = autoBossRush,
    })

    ToggleBossRush:OnChanged(function(isEnabled)
        autoBossRush = isEnabled
        settings["AutoBossRush"] = isEnabled
        saveSettings(settings)
        if not workspace:FindFirstChild("MainLobby") then
            print("MainLobby does not exist. NOT JOINING")
            return
        end
        
        if autoBossRush then
            BossRush()
            wait(1)
            if selectedBoss == "SUKUNA" then
                sukuna()
            elseif selectedBoss == "IGRIS" then
                igris()
            end
            wait(1)
            clickStartButton()
        end
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
