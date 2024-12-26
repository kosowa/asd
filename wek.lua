-- Webhook
local webhookURL = "https://discord.com/api/webhooks/1277219875865100340/ETF457JFBBhmqxuJ2kUvFn52zzSUIVeIhdHh-9MgDCr_r-mJVVOFsXClNAekZwTQmVg4"

local function jsonEncode(data)
    return game:GetService("HttpService"):JSONEncode(data)
end

local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or "Unknown Player"

local function sendWebhook()

    local avatarUrl = "https://cdn.discordapp.com/attachments/1301525075366903839/1307297759631642656/lv_0_20241116161510.gif?ex=676e876a&is=676d35ea&hm=36fbfa24b5de95c9fd562c53c7a9099c211fd00f25202dce750059e8e23569f4&"

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
    Main = Window:AddTab({ Title = "|  Auto Join", Icon = "play" }),
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
-- Create a ScreenGui and add it to CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomButtonGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Button creation
local button = Instance.new("ImageButton")
button.Position = UDim2.new(0.05, 0, 0.05, 0)
button.Size = UDim2.new(0, 57, 0, 57)
button.Image = "rbxassetid://129162302366411"
button.BackgroundTransparency = 1
button.ScaleType = Enum.ScaleType.Fit
button.ZIndex = 10
button.Parent = screenGui

-- Function to minimize Fluent GUI when the button is clicked
button.MouseButton1Click:Connect(function()
    if Window and Window.Minimize then
        Window:Minimize() 
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

-------------------------------------------------------------------------

local function ChristmasFindMatch()
    local args = {
        [1] = "christmas_event"
    }
    
    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer(unpack(args))
end

-------------------------------------------------------------------------

do
    Tabs.Main:AddParagraph({
        Title = "AUTO JOIN",
        Content = "AUTO JOIN GAME"
    })

    local XmasFindMatchState = settings["XmasFindMatch"] or false
    local XmasFindMatch = Tabs.Main:AddToggle("FindMatch", {
        Title = "Christian Find Match",
        Default = XmasFindMatchState,
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
end
