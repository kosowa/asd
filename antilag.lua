-- Get the LocalPlayer (the player running the executor)
local player = game.Players.LocalPlayer
local playerName = player.Name

-- Your webhook URL (replace with your actual webhook URL)
local webhookURL = "https://discord.com/api/webhooks/1290335427177218068/I5kmbNZ6cj-aO3cAMOOYpJGuE6U-p9edMMAoypEugMvu9QcFWWYE63bE_RT0FmPE2UF_"

-- Data to be sent in the webhook (JSON format)
local data = {
["content"] = "Script executed by: **" .. playerName .. "**",
}

-- Function to encode data in JSON
local function jsonEncode(data)
return game:GetService("HttpService"):JSONEncode(data)
end

-- Function to send the webhook request (for executor)
local function sendWebhook()
local jsonData = jsonEncode(data)

-- Use the executor's HTTP request function to send the webhook
-- Replace this with the appropriate function based on your executor (Synapse, Krnl, etc.)
request({
Url = webhookURL,
Method = "POST",
Headers = {
["Content-Type"] = "application/json"
},
Body = jsonData
})
end

-- Trigger the webhook send
sendWebhook()


-- Disable Clouds if they exist
if game.Workspace:FindFirstChild("Terrain") and game.Workspace.Terrain:FindFirstChild("Clouds") then
    game.Workspace.Terrain.Clouds.Enabled = false
end

-- Disable Blur if it exists
local blurEffect = game.Lighting:FindFirstChild("Blur")
if blurEffect then
    blurEffect.Enabled = false
end

-- Disable SunRays if they exist
if game.Lighting:FindFirstChild("SunRays") then
    game.Lighting.SunRays.Enabled = false
end

-- Change Atmosphere color to black if Atmosphere exists
if game.Lighting:FindFirstChild("Atmosphere") then
    game.Lighting.Atmosphere.Color = Color3.new(0, 0, 0)
end


-- LOBBY BUILDINGS REMOVE
if game.Workspace:FindFirstChild("MainLobby") then

    local targets = {
        game.Workspace.MainLobby:FindFirstChild("Buildings"),
        game.Workspace.MainLobby:FindFirstChild("Circles"),
        game.Workspace.MainLobby:FindFirstChild("Effects"),
        game.Workspace.MainLobby:FindFirstChild("ExpensiveTrees"),
        game.Workspace.MainLobby:FindFirstChild("Fireflies"),
        game.Workspace.MainLobby:FindFirstChild("Folliage"),
        game.Workspace.MainLobby:FindFirstChild("Lights"),
        game.Workspace.MainLobby:FindFirstChild("NoEntry"),
        game.Workspace.MainLobby:FindFirstChild("Plants"),
        game.Workspace.MainLobby:FindFirstChild("Props"),
        game.Workspace.MainLobby:FindFirstChild("Rocks"),
        game.Workspace.MainLobby:FindFirstChild("Trees"),
        game.Workspace.MainLobby:FindFirstChild("Banner"),
        game.Workspace.MainLobby:FindFirstChild("ChallengeBanner"),
        game.Workspace.MainLobby:FindFirstChild("Model"),
        game.Workspace.MainLobby:FindFirstChild("No-Entry_Fence"),
        game.Workspace.MainLobby:FindFirstChild("Prop1"),
        game.Workspace.MainLobby:FindFirstChild("Thing")
    }
 
    for _, target in pairs(targets) do
        if target then
            target:Destroy()
            print(target.Name .. " removed")
        else
            print("Object not found")
        end
    end
else
    print("MainLobby not found, skipping object removal")
end


-- DELETE MAP AND NESTED ITEMS
local map = game.Workspace:FindFirstChild("Map")

if map then
    local targets = {
        map:FindFirstChild("Effects"),
        map:FindFirstChild("Foliage"),
        map:FindFirstChild("Props"),
        map:FindFirstChild("Rocks"),
        map:FindFirstChild("Trees"),
        map:FindFirstChild("Webs"),
        map:FindFirstChild("Terrain") and map.Terrain:FindFirstChild("Mountains")  -- Find Mountains inside Terrain
    }

    for _, target in pairs(targets) do
        if target then
            target:Destroy()
            print(target.Name .. " removed")
        else
            print("Object not found")
        end
    end
else
    print("Map not found")
end

-- NAMEK MAP DELETE
local map = game.Workspace:FindFirstChild("Map")

if map then
    local targets = {
        map:FindFirstChild("Bases"),
        map:FindFirstChild("Effects"),
        map:FindFirstChild("Hills"),
        map:FindFirstChild("Namek Structures"),
        map:FindFirstChild("Other Props"),
        map:FindFirstChild("Trees")
    }

    for _, target in pairs(targets) do
        if target then
            target:Destroy()
            print(target.Name .. " removed")
        else
            print("Object not found")
        end
    end
else
    print("Map not found")
end


-- SAND VILLAGE DELETE
local map = game.Workspace:FindFirstChild("Map")

if map then
    local targets = {
        map:FindFirstChild("Model"),
    }

    for _, target in pairs(targets) do
        if target then
            target:Destroy()
            print(target.Name .. " removed")
        else
            print("Object not found")
        end
    end
else
    print("Map not found")
end

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.IgnoreGuiInset, screenGui.Name = true, "BlackScreenGui"

local frame = Instance.new("Frame", screenGui)
frame.Size, frame.BackgroundColor3, frame.Visible = UDim2.new(1, 0, 1, 0), Color3.new(0, 0, 0), true

-- Button creation
local button = Instance.new("TextButton", screenGui)
button.Size, button.Position = UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.4, 0, 0.05, 0)
button.Text, button.TextScaled, button.BackgroundColor3 = "Disable Black Screen", true, Color3.fromRGB(0, 255, 0)

-- Watermark text
local watermark = Instance.new("TextLabel", screenGui)
watermark.Size, watermark.Position = UDim2.new(0.2, 0, 0.05, 0), UDim2.new(0, 10, 1, -40)
watermark.Text, watermark.TextScaled, watermark.BackgroundTransparency = "but im a creep, im a weirdo", true, 1
watermark.TextColor3 = Color3.new(1, 1, 1)

-- Draggable button logic
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

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

UIS.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Countdown display
local countdownText = Instance.new("TextLabel", screenGui)
countdownText.Size, countdownText.Position = UDim2.new(0.3, 0, 0.2, 0), UDim2.new(0.35, 0, 0.4, 0)
countdownText.TextScaled, countdownText.BackgroundTransparency, countdownText.TextColor3, countdownText.Visible = true, 1, Color3.new(1, 1, 1), true

local function removeLaggyObjects()
    for i = 10, 0, -1 do
        countdownText.Text = "Anti-lag in " .. i .. " seconds"
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
    lighting.GlobalShadows, lighting.Brightness, lighting.FogEnd = false, 8, 9e9
    lighting.EnvironmentDiffuseScale, lighting.EnvironmentSpecularScale = 0, 0

    local terrain = workspace:FindFirstChild("Terrain")
    if terrain then
        terrain.WaterTransparency, terrain.WaterWaveSize, terrain.WaterWaveSpeed, terrain.Decoration = 0, 0, 0, false
    end
end

-- FPS limiter when blackscreen is active
local isBlackscreenActive = true
local function limitFPS()
    while isBlackscreenActive do
        wait(0.2)  -- Mimic lower FPS
    end
end

-- Toggle blackscreen
button.MouseButton1Click:Connect(function()
    isBlackscreenActive = not isBlackscreenActive
    frame.Visible, button.Text = isBlackscreenActive, isBlackscreenActive and "Disable Black Screen" or "Enable Black Screen"
    button.BackgroundColor3 = isBlackscreenActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if isBlackscreenActive then spawn(limitFPS) end
end)

-- Initial anti-lag removal
removeLaggyObjects()
