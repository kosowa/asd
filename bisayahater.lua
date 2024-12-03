--- x2
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

------------------------------------------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "ANIME REALMS",
    SubTitle = "by zestos",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 280),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Play", Icon = "boxes" }),
}

local Options = Fluent.Options
Window:SelectTab(1)
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
-------------------------------------------------------------------------

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

function joinLobby()
    if not workspace:FindFirstChild("DefaultLobby") then
        print("MLobby does not exist. NOT JOINING")
        return
    end
    local args = {
        [1] = "P10"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(unpack(args))
end

function joinMap()
    if not workspace:FindFirstChild("DefaultLobby") then
        print("MLobby does not exist. NOT JOINING")
        return
    end
    local args = {
        [1] = "P10",
        [2] = "marineford_infinite",
        [3] = true,
        [4] = "Normal"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(unpack(args))
end

function startLobby()
    if not workspace:FindFirstChild("DefaultLobby") then
        print("MLobby does not exist. NOT JOINING")
        return
    end
    local args = {
        [1] = "P10"
    }
    
    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(unpack(args))
end

function voteStart()
    if not workspace:FindFirstChild("_map") then
        print("Map didnt detect")
        return
    end

    game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
end

local function placeItadori()
    if not workspace:FindFirstChild("_map") then
        print("Map didnt detect")
        return
    end

    local args = {
        [1] = "ddfe97d902d04a3",
        [2] = {
            ["Direction"] = Vector3.new(-0.026689914986491203, -0.8567215204238892, -0.5150881409645081),
            ["Origin"] = Vector3.new(-210.1964874267578, 32.95851135253906, 13.914166450500488)
        },
        [3] = 0
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.spawn_unit:InvokeServer(unpack(args))
end

local function upgradeItadori()
    if not workspace:FindFirstChild("_map") then
        print("Map didnt detect")
        return
    end
    
    local args = {
        [1] = "ddfe97d902d04a31"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(unpack(args))
end

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder")

-- Function to set Holder.Visible to false
local function hideHolder()
    holder.Visible = false
end

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder")

-- Function to return to the lobby
local function returntoLobby()
    game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer()
end

-- Listen for changes in the "Visible" property of the Holder
holder:GetPropertyChangedSignal("Visible"):Connect(function()
    if holder.Visible then
        returntoLobby()
    end
end)

-------------------------------------------------------------------------

do
    Tabs.Main:AddParagraph({
        Title = "AUTOPLAY",
        Content = "1 tap auto play"
    })

    
    local autoplayState = settings["AutoPlay"] or false
    local ToggleAutoPlay = Tabs.Main:AddToggle("MyToggleAutoPlay", {
        Title = "Auto Play",
        Default = autoplayState
    })

    ---
    ToggleAutoPlay:OnChanged(function(isEnabled)
        autoplayState = isEnabled
        settings["AutoPlay"] = isEnabled
        saveSettings(settings)

        if autoplayState then
            joinLobby()
            wait(1)
            joinMap()
            wait(1)
            startLobby()
            voteStart()
            hideHolder()
            for i = 1, 5 do
                placeItadori()
                wait(2)
            end
            wait(1)
            for i = 1, 1000 do
                upgradeItadori()
                wait(2)
            end
        end
    end)
end
