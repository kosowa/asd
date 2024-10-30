-- 1.GET THE HELL OUT OF HERE NIGGA 
-- Get the LocalPlayer (the player running the executor)
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

-- delete atmosphere
local lighting = game:GetService("Lighting")
local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")

if atmosphere then
    atmosphere:Destroy()
    print("Atmosphere removed")
else
    print("Atmosphere not found")
end

-- LOBBY BUILDINGS REMOVE
local lobby = game.Workspace:FindFirstChild("MainLobby")

if lobby then
    local targets = {
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
        lobby:FindFirstChild("ChallengeBanner"),
        lobby:FindFirstChild("Floor_Raids"),
        lobby:FindFirstChild("Neon Sign 1"),
        lobby:FindFirstChild("Raid_Pillar"),
        lobby:FindFirstChild("Space Ship Green"),
        lobby:FindFirstChild("Space Ship Orange"),
        lobby:FindFirstChild("Thing"),
        lobby:FindFirstChild("Cylinder.072"),
        lobby:FindFirstChild("Cylinder.021"),
    }

    local targetNames = {
        ["Image Ad Unit 2"] = true,
        ["No-Entry_Fence"] = true,  -- Added quotes to fix key
        ["Model"] = true,
        ["Doorway"] = true,
        ["Prop1"] = true,
        ["Sign_Capybara"] = true,
        ["Small_wall"] = true
    }
    
    if lobby then
        for _, child in ipairs(lobby:GetChildren()) do
            if targetNames[child.Name] then
                table.insert(targets, child)
            end
        end
    end
    
    -- DESTROY
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

-- DELETE MAP AND NESTED ITEMS
-- DEMON SLAYER MAP DELETE
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

--SHIBUYAS STATION MAP DELETE
local map = game.Workspace:FindFirstChild("Map")

if map then
    local building = map:FindFirstChild("Building")
    local targets = {
        map:FindFirstChild("Hill Spots"),
        map:FindFirstChild("Invisible Walls"),
        map:FindFirstChild("Pillars"),
        map:FindFirstChild("Rails"),
        map:FindFirstChild("Vents"),
        building and building:FindFirstChild("Stairways"),
        building and building:FindFirstChild("Wall Strips"),
        building and building:FindFirstChild("Lights")
    }

    -- Find all "default" parts under "Building" and add them to targets
    if building then
        for _, child in ipairs(building:GetChildren()) do
            if child.Name == "default" then
                table.insert(targets, child)
            end
        end
    end

    -- Destroy each target
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

--SHIBUYAS LEGENDSTAGE MAP DELETE
local map = game.Workspace:FindFirstChild("Map")

if map then
    local objects = map:FindFirstChild("Objects")
    
    if objects then
        for _, part in ipairs(objects:GetChildren()) do
            if part.Name ~= "Road Base" then
                part:Destroy()
                print(part.Name .. " removed")
            else
                print(part.Name .. " kept")
            end
        end
    else
        print("Objects not found")
    end
else
    print("Map not found")
end

-- ANTI LAG PART
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.IgnoreGuiInset, screenGui.Name = true, "RenderingControlGui"

-- Black screen frame
local blackFrame = Instance.new("Frame", screenGui)
blackFrame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black color
blackFrame.Visible = false  -- Hidden by default
blackFrame.ZIndex = 1  -- Set a lower ZIndex so that the button stays above this frame

-- Button creation
local button = Instance.new("ImageButton", screenGui)
button.Position = UDim2.new(0.4, 0, 0.05, 0)
button.Size = UDim2.new(0, 57, 0, 57)
button.Image = "rbxassetid://83204245116453"
button.BackgroundTransparency = 1  -- Make the background fully transparent
button.ScaleType = Enum.ScaleType.Fit  -- Ensures the image fits inside the square
button.ZIndex = 3  -- Set an even higher ZIndex to ensure it stays above everything

-- Watermark text
local watermark = Instance.new("TextLabel", screenGui)
watermark.Size, watermark.Position = UDim2.new(0.2, 0, 0.05, 0), UDim2.new(0, 10, 1, -40)
watermark.Text, watermark.TextScaled, watermark.BackgroundTransparency = "🟢this user loves to watch gay porn", true, 1
watermark.TextColor3 = Color3.new(1, 1, 1)
watermark.ZIndex = 3  -- Set a high ZIndex to ensure it stays visible

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

-- Create a ScreenGui and add it to the PlayerGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Countdown display
local countdownText = Instance.new("TextLabel", screenGui)
countdownText.Size = UDim2.new(0.3, 0, 0.2, 0)
countdownText.Position = UDim2.new(0.35, 0, 0.4, 0)
countdownText.TextScaled = false  -- Disable automatic scaling
countdownText.TextSize = 14  -- Set a smaller text size (adjust this as needed)
countdownText.BackgroundTransparency = 1
countdownText.TextColor3 = Color3.new(1, 1, 1)  -- White text
countdownText.Visible = true

-- Function to remove laggy objects and textures
local function removeLaggyObjects()
    -- Countdown before removal
    for i = 10, 0, -1 do
        countdownText.Text = "Optimizing " .. i .. " seconds"
        wait(1)
    end
    countdownText.Visible = false

    -- Disable unnecessary visual effects
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Remove textures from parts and change material to SmoothPlastic
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
            -- Set the material to SmoothPlastic to reduce lag
            part.Material = Enum.Material.SmoothPlastic

            -- Remove SurfaceGuis, Decals, and Textures
            for _, child in pairs(part:GetDescendants()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then
                    child:Destroy()
                end
            end
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
        terrain.Decoration = false
    end
end

-- Function to show blackscreen
local Camera = game.Workspace.CurrentCamera
local player = game.Players.LocalPlayer

-- Function to show black screen
local function showBlackScreen()
    if Camera then
        blackFrame.Visible = true  -- Show black screen
        print("Black screen is enabled.")
    else
        warn("Camera not found! Black screen was not enabled.")
    end
end

-- Function to hide black screen
local function hideBlackScreen()
    if Camera then
        blackFrame.Visible = false  -- Hide black screen
        print("Black screen is disabled.")
    else
        warn("Camera not found! Black screen was not disabled.")
    end
end

-- Toggle black screen with button click
local isBlackScreenEnabled = true
button.MouseButton1Click:Connect(function()
    isBlackScreenEnabled = not isBlackScreenEnabled
    if isBlackScreenEnabled then
        showBlackScreen()
    else
        hideBlackScreen()
    end
end)

-- Initial setup (show black screen automatically on script execution)
showBlackScreen()
removeLaggyObjects()
