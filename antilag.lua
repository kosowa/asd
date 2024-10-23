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
button.Image = "rbxassetid://119520675879398"
button.BackgroundTransparency = 1  -- Make the background fully transparent
button.ScaleType = Enum.ScaleType.Fit  -- Ensures the image fits inside the square
button.ZIndex = 2  -- Set a higher ZIndex to ensure it is on top of the black screen

-- Watermark text
local watermark = Instance.new("TextLabel", screenGui)
watermark.Size, watermark.Position = UDim2.new(0.2, 0, 0.05, 0), UDim2.new(0, 10, 1, -40)
watermark.Text, watermark.TextScaled, watermark.BackgroundTransparency = "test12", true, 1
watermark.TextColor3 = Color3.new(1, 1, 1)
watermark.ZIndex = 2  -- Set a higher ZIndex to ensure it is visible on top of the black screen

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

-- Function to disable 3D rendering and show black screen
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera

local function disableRendering()
    if Camera then
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = CFrame.new(0, 0, 0)  -- Arbitrary position
        RunService:Set3dRenderingEnabled(false)
        blackFrame.Visible = true  -- Show black screen
        print("3D rendering has been disabled and black screen is enabled.")
    else
        warn("Camera not found! 3D rendering was not disabled.")
    end
end

local function enableRendering()
    if Camera then
        Camera.CameraType = Enum.CameraType.Custom  -- Reset the camera type
        RunService:Set3dRenderingEnabled(true)
        blackFrame.Visible = false  -- Hide black screen
        print("3D rendering has been re-enabled and black screen is disabled.")
    else
        warn("Camera not found! 3D rendering was not re-enabled.")
    end
end

-- Toggle 3D rendering with button click
local isRenderingDisabled = false
button.MouseButton1Click:Connect(function()
    isRenderingDisabled = not isRenderingDisabled
    if isRenderingDisabled then
        disableRendering()
        button.ImageColor3 = Color3.new(0, 0, 0)  -- Make the button black when rendering is disabled
    else
        enableRendering()
        button.ImageColor3 = Color3.fromRGB(255, 255, 255)  -- Restore to white when rendering is enabled
    end
end)

-- Initial setup
enableRendering()  -- Start with rendering enabled by default
