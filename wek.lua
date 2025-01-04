--v6.2
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

--GUILD RANK WEBHOOK

-- Webhook URL (without message ID)
local webhookURL = "https://discord.com/api/webhooks/1325046141129199687/-q9mzEQwSji3KERcaTLBBnim5SyCOOBcRu4jgTP0GULByr5abvNd4Gr_twp-y6aFqaaU"
-- Message ID of the message to edit
local messageID = "1325047047958695997"

-- JSON Encoding Helper Function
local function jsonEncode(data)
    return game:GetService("HttpService"):JSONEncode(data)
end

-- Function to format time for Discord (ISO8601 format)
local function getDiscordTimestamp()
    return os.date("!%Y-%m-%dT%H:%M:%SZ") -- UTC format
end

-- Local Player
local player = game.Players.LocalPlayer
local playerName = player and player.Name or "Unknown Player"

-- Function to edit webhook message
local function editWebhookMessage(rankText)
    -- Get the current time for the latest update
    local discordTimestamp = getDiscordTimestamp()

    -- Prepare the data payload
    local data = {
        ["content"] = nil,
        ["embeds"] = { {
            ["title"] = "MERCENARIES RANK UPDATES",
            ["description"] = "Latest Update: <t:" .. math.floor(os.time()) .. ":R>",
            ["color"] = 16711680,
            ["fields"] = { {
                ["name"] = "GUILD RANK",
                ["value"] = "" .. rankText .. ""
            }},
            ["image"] = {
                ["url"] = "https://media.discordapp.net/attachments/1178003403432013954/1178003720227794944/image.png?ex=677a0535&is=6778b3b5&hm=438b04dec7e6b8dd93f164a344141b0afd7308df4a29b29f9b18d4d985d07659&=&format=webp&quality=lossless&width=494&height=213"
            },
            ["thumbnail"] = {
                ["url"] = "https://media.discordapp.net/attachments/942805757936672821/1307254555796307998/xmaslogo.png?ex=677a3cad&is=6778eb2d&hm=b58b687a627a8f9adbbdd70868bf59af042d50d30492b5b077c6b065537c0017&=&format=webp&quality=lossless&width=609&height=609"
            }
        }},
        ["attachments"] = {}
    }

    local jsonData = jsonEncode(data)

    -- Append message ID to the webhook URL
    local editURL = webhookURL .. "/messages/" .. messageID

    -- Perform the request to edit the message
    local response = request({
        Url = editURL,
        Method = "PATCH",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })

    if response.StatusCode ~= 200 then
        warn("Failed to edit webhook message. Status code: " .. response.StatusCode .. "\nResponse: " .. response.Body)
    else
        print("Webhook message edited successfully!")
    end
end

-- Main Logic
local function checkGuildRank()
    -- Attempt to find the relevant objects
    local success, result = pcall(function()
        return player.Character:WaitForChild("Head"):WaitForChild("_overhead")
            .Frame.Guild_Frame.GuildIconFrame.Frame
    end)

    if success then
        local guildNameText = result:FindFirstChild("Name_Text")
        local rankNameText = result:FindFirstChild("_rank") and result._rank:FindFirstChild("Name_Text")

        if guildNameText and rankNameText and guildNameText.Text == "mercenariess" then
            -- Edit the existing webhook message with the updated rank text
            editWebhookMessage(rankNameText.Text)
        else
            warn("Guild Name does not match 'mercenariess' or objects are missing.")
        end
    else
        warn("Failed to find target objects.")
    end
end

-- Loop to check rank every 10 seconds
task.spawn(function()
    while true do
        checkGuildRank()
        task.wait(10)
    end
end)

----------------------------------------------------------------

settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
settings().Rendering.EagerBulkExecution = false
settings().Network.IncomingReplicationLag = -1000

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
    Title = "ANIME ADVENTURES | MERCENARIES",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 350),
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

---------------------------------------------------------------------------

local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
if screenGui then
    screenGui.IgnoreGuiInset = true
    print("IgnoreGuiInset set to true for ScreenGui.")
else
    warn("ScreenGui not found in CoreGui.")
end


local function makeButtonsInvisible(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = false
        elseif child:IsA("Frame") then
            makeButtonsInvisible(child) -- Recursively check nested frames
        end
    end
end

local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
if screenGui then
    makeButtonsInvisible(screenGui)
else
    warn("ScreenGui not found in CoreGui.")
end

local function setFontToFredokaOne(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child.Font = Enum.Font.FredokaOne
        elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
            -- Recursively check nested frames or scrolling frames
            setFontToFredokaOne(child)
        end
    end
end

local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
if screenGui then
    setFontToFredokaOne(screenGui)
else
    warn("ScreenGui not found in CoreGui.")
end
--------------------------------------------------------
--TEXT GRADIENT
local RunService = game:GetService("RunService")

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

local totalSteps = 300 -- Increased steps for slower transition
local animationSpeed = 0.05 -- Slower update speed
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

-- Function to apply UIGradient and update font
local function applyRainbowEffect(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            -- Update the font to FredokaOne
            child.Font = Enum.Font.FredokaOne

            -- Create and apply UIGradient
            local gradient = Instance.new("UIGradient")
            gradient.Parent = child
            gradient.Name = "RainbowGradient"

            -- Animate the gradient
            RunService.RenderStepped:Connect(function()
                step = (step + animationSpeed) % totalSteps
                gradient.Color = interpolateColors(colors, step, totalSteps)
            end)
        elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
            -- Recursively apply to nested frames
            applyRainbowEffect(child)
        end
    end
end

-- Locate the ScreenGui and apply the effect
local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
if screenGui then
    applyRainbowEffect(screenGui)
    print("Rainbow gradient effect applied to all text under ScreenGui.")
else
    warn("ScreenGui not found in CoreGui.")
end
---------------------------------------------------
-- UI STROKE
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

local totalSteps = 300 -- Slower transition for rainbow gradient
local animationSpeed = 1 -- Speed of animation
local step = 0

-- Function to interpolate between two colors
local function interpolateColors(colors, step, totalSteps)
    local progress = step / totalSteps
    local index = math.floor(progress * #colors) + 1
    local nextIndex = (index % #colors) + 1
    local lerpFactor = (progress * #colors) % 1

    local startColor = colors[index]
    local endColor = colors[nextIndex]
    return startColor:Lerp(endColor, lerpFactor)
end

-- Locate the nested Frame
local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
if screenGui then
    local parentFrame = screenGui:GetChildren()[2] -- Get the second child
    if parentFrame and parentFrame:IsA("Frame") then
        local targetFrame = parentFrame:FindFirstChild("Frame") -- Find the nested Frame
        if targetFrame and targetFrame:IsA("Frame") then
            -- Create UIStroke for the outline
            local stroke = Instance.new("UIStroke")
            stroke.Parent = targetFrame
            stroke.Thickness = 3 -- Outline thickness
            stroke.Name = "RainbowOutline"

            -- Animate the stroke color
            RunService.RenderStepped:Connect(function()
                step = (step + animationSpeed) % totalSteps
                stroke.Color = interpolateColors(colors, step, totalSteps)
            end)

            print("Rainbow gradient outline added to the nested Frame.")
        else
            warn("Nested Frame not found or is not a Frame.")
        end
    else
        warn("Parent Frame not found or is not a Frame.")
    end
else
    warn("ScreenGui not found in CoreGui.")
end



-------------------------------------------------------------------------

-- Parent to CoreGui TopBar
local topBar = game:GetService("CoreGui"):WaitForChild("TopBarApp", 5)
local unibarLeftFrame = topBar and topBar:FindFirstChild("UnibarLeftFrame", true)
local stackedElements = unibarLeftFrame and unibarLeftFrame:FindFirstChild("StackedElements", true)

if stackedElements then

    local backgroundTransparency = 0.30

    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 100, 0, 45) -- Adjust size for FPS display
    background.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
    background.BackgroundTransparency = backgroundTransparency -- Apply transparency
    background.Parent = stackedElements

    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- Adjust the radius for rounding
    corner.Parent = background

    -- Create FPS Label
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1, 0, 1, 0) -- Full size of the background
    fpsLabel.BackgroundTransparency = 1 -- Transparent background
    fpsLabel.Font = Enum.Font.FredokaOne
    fpsLabel.TextSize = 25
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = Color3.new(1, 1, 1) -- White text for "FPS:"
    fpsLabel.RichText = true -- Enable RichText for color changes
    fpsLabel.TextStrokeTransparency = 0 -- Add outline
    fpsLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
    fpsLabel.Parent = background

    -- Variables for FPS calculation
    local lastUpdate = tick()
    local frameCount = 0

    -- RenderStepped connection for FPS calculation
    game:GetService("RunService").RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        local deltaTime = now - lastUpdate

        -- Update every 0.5 seconds
        if deltaTime >= 0.5 then
            local fps = math.floor(frameCount / deltaTime)
            local fpsColor

            -- Set color for FPS value
            if fps >= 40 then
                fpsColor = "rgb(0, 255, 0)"
            elseif fps >= 30 then
                fpsColor = "rgb(255, 165, 0)"
            else
                fpsColor = "rgb(255, 0, 0)"
            end

            -- Update the label with RichText
            fpsLabel.Text = string.format('<font color="rgb(255,255,255)">FPS: </font><font color="%s">%d</font>', fpsColor, fps)

            frameCount = 0
            lastUpdate = now
        end
    end)
else
    warn("Could not find TopBarApp -> UnibarLeftFrame -> StackedElements")
end

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
-----------------------------------------------------------------------

-------------------------------------------------------------------------

-- Black screen GUI setup
local player = game.Players.LocalPlayer

-- Create ScreenGui in CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "zBLACKSCREEN"
screenGui.DisplayOrder = -1
screenGui.IgnoreGuiInset = true  -- Ignore the Roblox top bar inset
screenGui.Parent = game:GetService("CoreGui")  -- Parent to CoreGui for higher layering

-- Create black frame with gradient
local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen
blackFrame.BackgroundTransparency = 0  -- Fully opaque
blackFrame.Visible = false  -- Start hidden
blackFrame.Parent = screenGui

-- Add gradient to black frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),  -- Black
    ColorSequenceKeypoint.new(1, Color3.new(0.27, 0.27, 0.27))  -- Slightly gray white
}
gradient.Rotation = 90  -- Vertical gradient
gradient.Parent = blackFrame

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
    label.Size = UDim2.new(0, 200, 0, 50)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)  -- White color
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 24
    label.Text = text
    label.Parent = row

    return label
end

-- Create rows for stats
local waveLabel = createRow("94267310029580", "WAVE: 0")
local gemsLabel = createRow("73512171500034", "GEMS: 0")
local goldLabel = createRow("10481692479", "GOLD: 0")
local candiesLabel = createRow("11240176807", "CANDIES: 0")
local starsLabel = createRow("11734233284", "HOLIDAY STARS: 0")

-- Function to update text labels with current stats values
local function updateText()
    local stats = player:FindFirstChild("_stats")
    if not stats then return end

    local gems = stats:FindFirstChild("gem_amount") and stats.gem_amount.Value or 0
    local gold = stats:FindFirstChild("gold_amount") and stats.gold_amount.Value or 0
    local candies = stats:FindFirstChild("_resourceCandies") and stats._resourceCandies.Value or 0
    local stars = stats:FindFirstChild("_resourceHolidayStars") and stats._resourceHolidayStars.Value or 0
    local waveNumber = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Waves") and 
        game:GetService("Players").LocalPlayer.PlayerGui.Waves:FindFirstChild("HealthBar") and 
        game:GetService("Players").LocalPlayer.PlayerGui.Waves.HealthBar:FindFirstChild("WaveNumber") and 
        game:GetService("Players").LocalPlayer.PlayerGui.Waves.HealthBar.WaveNumber.Text or "0"

    waveLabel.Text = tostring(waveNumber)
    gemsLabel.Text = tostring(gems)
    goldLabel.Text = tostring(gold)
    candiesLabel.Text = tostring(candies)
    starsLabel.Text = tostring(stars)
end

-- Connect value change signals to updateText function
local stats = player:WaitForChild("_stats", 5)  -- Wait for the _stats folder to exist
if stats then
    local function connectValueChange(propertyName, label)
        local property = stats:FindFirstChild(propertyName)
        if property then
            property.Changed:Connect(function()
                updateText()
            end)
        end
    end

    connectValueChange("gem_amount", gemsLabel)
    connectValueChange("gold_amount", goldLabel)
    connectValueChange("_resourceCandies", candiesLabel)
    connectValueChange("_resourceHolidayStars", starsLabel)
end

-- Update the wave number dynamically
local waveGui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Waves", 5)
if waveGui and waveGui:FindFirstChild("HealthBar") and waveGui.HealthBar:FindFirstChild("WaveNumber") then
    waveGui.HealthBar.WaveNumber:GetPropertyChangedSignal("Text"):Connect(function()
        updateText()
    end)
end

-------------------------------------------------------------------------

-- BLACKSCREEN BUTTON
local button = Instance.new("ImageButton")
button.Position = UDim2.new(0.9, 0, 0.1, 0)
button.Size = UDim2.new(0, 45, 0, 45)
button.Image = "rbxassetid://137288117905250"
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
    "+ Gain 2 Random Curses Tier 3",
    "+ Gain 2 Random Curses Tier 2",
    "+ Gain 2 Random Curses Tier 1",
    "+ Boss Damage I",
    "+ Boss Damage II",
    "+ Boss Damage III",
    "+ Enemy Shield III",
    "+ Enemy Shield II",
    "+ Enemy Shield I",
    "+ Range I",
    "+ Cooldown I",
    "+ Attack I",
    "+ Gain 2 Random Effects Tier 1",
    "+ Cooldown II",
    "+ Attack II",
    "+ Gain 2 Random Effects Tier 2",
    "+ Cooldown III",
    "+ Range II",
    "+ Range III",
    "+ Attack III",
    "+ Gain 2 Random Effects Tier 3",
    "+ Explosive Deaths I",
    "+ Explosive Deaths II",
    "+ Explosive Deaths III",
    "+ Enemy Regen I",
    "+ Enemy Regen II",
    "+ Enemy Regen III",
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
local function runAntilag()
    print("runAntilag triggered!") -- Debug print
    if not game:IsLoaded() then
        game.Loaded:Wait()
        wait(10)
    end

    local function check(inst)
        local class = inst.ClassName
        if class == "Decal" or class == "Texture" then 
            inst.Texture = ""
        elseif class == "SpecialMesh" then 
            inst.TextureId = ""
        elseif class == "ParticleEmitter" then
            inst.Texture = ""
            inst.Rate = 0
        elseif inst:IsA("BasePart") then 
            inst.Material = Enum.Material.SmoothPlastic
            inst.Reflectance = 0
            inst.CastShadow = false
            if class == "MeshPart" then 
                inst.TextureID = ""
                inst.CollisionFidelity = Enum.CollisionFidelity.Hull
            elseif class == "UnionOperation" then
                inst.CollisionFidelity = Enum.CollisionFidelity.Hull
            end
            if inst.Anchored and inst.Size.Magnitude < 5 then
                inst.Transparency = 1
                inst.CanCollide = false
            end
        end
    end

    local function removeDups(children)
        if #children > 99 then
            local myname = tostring(game:GetService("Players").LocalPlayer)
            local fake = {Name = myname}
            for i = 1, #children do
                local name1 = children[i].Name
                if name1 ~= myname and name1 ~= "Terrain" then
                    local moved = false
                    for j = i + 1, #children do
                        if children[j].Name == name1 then
                            moved = true
                            children[j].Parent = workspace.Terrain
                            children[j] = fake
                        end
                    end
                    if moved then 
                        children[i].Parent = workspace.Terrain
                    end
                end
            end
        end
    end

    workspace:WaitForChild("Terrain")
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterTransparency = 0

    game:GetService("Lighting").GlobalShadows = false

    workspace.Terrain:Clear()
    local plates = {}

    if not workspace:FindFirstChild("Baseplate") then
        for x = -1, 1, 2 do
            for z = -1, 1, 2 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(2048, 5, 2048)
                part.CFrame = CFrame.new(1024 * x, -5, 1024 * z)
                part.Anchored = true
                part.Material = Enum.Material.SmoothPlastic
                part.Color = Color3.new(0.36, 0.6, 0.3)
                part.Name = "Baseplate"
                part.Parent = workspace
                plates[#plates + 1] = part
            end
        end
    end

    wait(0.3)

    while true do
        for _, v in ipairs(game:GetService("Lighting"):GetDescendants()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end

        local des = workspace:GetDescendants()
        for i = 1, #des do
            check(des[i])
        end

        wait(0.3)
        removeDups(workspace:GetChildren())
        wait(600)
    end
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

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Distance to move the camera
local distance = 100000

-- Function to enable freecam and move the camera
local function enableFreeCam()
    -- Get the player's character and root part
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Set the camera to scriptable mode
    camera.CameraType = Enum.CameraType.Scriptable

    -- Move the camera 1000 studs away from the player's position
    local newPosition = rootPart.Position + Vector3.new(0, 0, distance)
    camera.CFrame = CFrame.new(newPosition, rootPart.Position) -- Make the camera look at the player
end

-- Function to disable freecam and return the camera to the player's default view
local function disableFreeCam()
    -- Get the player's character and root part
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Set the camera back to the default follow mode
    camera.CameraType = Enum.CameraType.Custom
    camera.CFrame = rootPart.CFrame
end

----------------------------------------------------------------------

local function XmasStarSummon()
    local args = {
        [1] = "Christmas2024",
        [2] = "gems"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_from_banner:InvokeServer(unpack(args))
end

local function clickSummonUnits()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendMouseButtonEvent(500, 150, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(500, 150, 0, false, game, 1)
end

----------------------------------------------------------------------

local runService = game:GetService("RunService")
local unitsFolderName = "_UNITS"
local deleteLoopActive = false

local function hasChristmasModel(unitsFolder)
    for _, child in ipairs(unitsFolder:GetChildren()) do
        if child:IsA("Model") and child.Name:sub(1, 9) == "christmas" then
            return true
        end
    end
    return false
end

local function startLoopIfNeeded(unitsFolder)
    if not deleteLoopActive and hasChristmasModel(unitsFolder) then
        deleteLoopActive = true

        task.spawn(function()
            while deleteLoopActive do
                for _, child in ipairs(unitsFolder:GetChildren()) do
                    if child:IsA("Model") and child.Name:sub(1, 9) == "christmas" then
                        child:Destroy()
                    end
                end

                -- Stop the loop if no more matching models exist
                if not hasChristmasModel(unitsFolder) then
                    deleteLoopActive = false
                end

                task.wait() -- Yield to avoid blocking
            end
        end)
    end
end

local function StartDeleteEnemies()
    local unitsFolder = workspace:FindFirstChild(unitsFolderName)
    if not unitsFolder then
        warn(unitsFolderName .. " folder not found in workspace.")
        return
    end

    -- Check for new children being added to `_UNITS`
    unitsFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name:sub(1, 9) == "christmas" then
            startLoopIfNeeded(unitsFolder)
        end
    end)

    -- Initialize loop if models already exist
    startLoopIfNeeded(unitsFolder)
end

local function StopDeleteEnemies()
    deleteLoopActive = false
end

----------------

local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- Function to stop animations on objects with animators
local function stopAnimations(object)
    if object:IsA("Model") then
        -- Stop animations in humanoid-based models
        local humanoid = object:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
    elseif object:IsA("BasePart") or object:IsA("MeshPart") then
        -- Handle custom animations if applicable
        local animator = object:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end
end

-- Function to scan all objects and stop their animations
local function freezeAllAnimations()
    while true do
        for _, descendant in ipairs(workspace:GetDescendants()) do
            stopAnimations(descendant)
        end
        -- Yield to avoid excessive performance impact
        task.wait(0.5) -- Adjust interval as needed
    end
end

-- Start the animation-freezing loop in a separate thread


-- Also monitor newly added objects dynamically
workspace.DescendantAdded:Connect(function(newObject)
    stopAnimations(newObject)
end)

-- Ensure animations are stopped for new players' characters
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        stopAnimations(character)
    end)
end)

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

    local FreezeAnimationState = settings["freezeAnimation"] or false
    local ToggleFreezeAnimation = Tabs.Optimize:AddToggle("freezeAnim", {
        Title = "Freeze Animations",
        Default = FreezeAnimationState,
    })

    local disable3dState = settings["disable3d"] or false
    local Toggledisable3d = Tabs.Optimize:AddToggle("disable3d", {
        Title = "Disable 3d When blackscreen",
        Default = disable3dState,
    })

    local BlackScreenState = settings["BlackScreen"] or false
    local ToggleBlackScreen = Tabs.Optimize:AddToggle("BlackScreen", {
        Title = "Black Screen",
        Default = BlackScreenState,
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
        Default = AntiLagState,
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

    ToggleFreezeAnimation:OnChanged(function(isEnabled)
        FreezeAnimationState = isEnabled
        settings["freezeAnimation"] = isEnabled
        saveSettings(settings)

        if FreezeAnimationState then
            task.spawn(freezeAllAnimations)
        end
    end)

    Toggledisable3d:OnChanged(function(isEnabled)
        disable3dState = isEnabled
        settings["disable3d"] = isEnabled
        saveSettings(settings)

        if disable3dState then
            Window:Dialog({
                Title = "ATTENTION!",
                Content = "TURN THIS OFF IF YOU'RE CRASHING",
                Buttons = {
                    {
                        Title = "YES DADDY",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    }
                }
            })
        end
    end)

    ToggleBlackScreen:OnChanged(function(isEnabled)
        BlackScreenState = isEnabled
        settings["BlackScreen"] = isEnabled
        saveSettings(settings)
    
        if BlackScreenState then
            if disable3dState == true then
                game:GetService("RunService"):Set3dRenderingEnabled(false)
            end
            blackFrame.Visible = true
            enableFreeCam()
            updateText()
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
            blackFrame.Visible = false
            disableFreeCam()
        end
    end)

    local isBlackScreenVisible = BlackScreenState -- Store the state to toggle
    button.MouseButton1Click:Connect(function()
        local originalSize = button.Size
    
        local tweenService = game:GetService("TweenService")
        local popTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local shrinkTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
        local popGoal = {Size = UDim2.new(0, 55, 0, 55)}
        local popTween = tweenService:Create(button, popTweenInfo, popGoal)
    
        local shrinkGoal = {Size = originalSize}
        local shrinkTween = tweenService:Create(button, shrinkTweenInfo, shrinkGoal)
    
        popTween:Play()
        popTween.Completed:Connect(function()
            shrinkTween:Play()
        end)
    
        -- Toggle the BlackScreen state directly
        ToggleBlackScreen:SetValue(not BlackScreenState)
    end)

    XmasFindMatch:OnChanged(function(isEnabled)
        XmasFindMatchState = isEnabled
        settings["XmasFindMatch"] = isEnabled
        saveSettings(settings)
    
        if XmasFindMatchState then
            wait(5)
            ChristmasFindMatch()
        end
    end)

    ToggleAntiLag:OnChanged(function(isEnabled)
        AntiLagState = isEnabled
        settings["Antilag"] = isEnabled
        saveSettings(settings)

        if AntiLagState then
            print("Starting AntiLag...")
            task.spawn(runAntilag)
        else
            print("AntiLag disabled.")
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

    ToggleSummon:OnChanged(function(isEnabled)
        SummonState = isEnabled
        settings["Summon"] = isEnabled
        saveSettings(settings)

        if SummonState then
	    Window:Minimize()
            while SummonState do
                XmasStarSummon()
                wait(0.5)
                clickSummonUnits()
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
                Content = "DO NOT USE DELETE ENTITIES WHEN RECORDING MACRO",
                Buttons = {
                    {
                        Title = "YES DADDY",
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
