--- x15
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
---------------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

------------------------------------------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "[✅]ANIME REALMS | BY MARIS RACAL",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 280),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Play", Icon = "play" }),
    Legend = Window:AddTab({ Title = "Legend Stage", Icon = "shield" }),
    Optimize = Window:AddTab({ Title = "Optimizer", Icon = "boxes" }),
}

local Options = Fluent.Options
Window:SelectTab(1)
Window:Minimize()

--------------------------------------------------------------------------------------
--AUTO LOAD SETTINGS
-- Services
local HttpService = game:GetService("HttpService")
local saveFileName = "AnimeRealmsSettings.json"

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

-- Function to remove laggy objects and textures
local function removeLaggyObjects()
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
        -- If it's a MeshPart, set RenderFidelity to Performance
            if part:IsA("MeshPart") then
                part.RenderFidelity = Enum.RenderFidelity.Performance
            end
        end
    end
    print("Laggy objects removed and textures disabled")
end

--------------------------------------------------------------

local function deleteMap()
    wait(1)
    local map = workspace:FindFirstChild("_map")

    if map then
        for _, child in ipairs(map:GetChildren()) do
            child:Destroy()
        end
        print("All children under _map have been deleted.")
    else
        print("_map not found in the workspace.")
    end
end

--------------------------------------------------------------

function joinLobby()
    wait(5)
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

local function joinLegendStage()
    if not workspace:FindFirstChild("DefaultLobby") then
        print("MLobby does not exist. NOT JOINING")
        return
    end
    local args = {
            [1] = "P10",
            [2] = "shibuya_legend_2",
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

-- legend stage getu unit
local function placeUnit()
    local args = {
        [1] = "7ebd5df0938c42f",
        [2] = {
            ["Direction"] = Vector3.new(-0.47703832387924194, -0.6543081998825073, -0.5867838859558105),
            ["Origin"] = Vector3.new(360.7114562988281, 95.65676879882812, -470.47613525390625)
        },
        [3] = 0
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.spawn_unit:InvokeServer(unpack(args))
end

local function upgradeGetu()
    local args = {
        [1] = "7ebd5df0938c42f1"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(unpack(args))
end

-----------------------------------------------------------------------------------------------------
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local function pressEnter()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function resultUI()
    local player = game:GetService("Players").LocalPlayer
    local nextButton = player.PlayerGui.ResultsUI.Holder.Buttons.Next

    if nextButton then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = nextButton
        wait(1)
        pressEnter()
    end
end

local VirtualInputManager = game:GetService("VirtualInputManager")

local function clickRewards()
    for i = 1, 5 do
        VirtualInputManager:SendMouseButtonEvent(500, 150, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(500, 150, 0, false, game, 1)
        wait(1)
    end
end

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder")

-- Function to set Holder.Visible to false
local function hideHolder()
    holder.Visible = false
end

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder")

local function returntoLobby()
    game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer()
end

-- Listen for changes in the "Visible" property of the Holder
holder:GetPropertyChangedSignal("Visible"):Connect(function()
    if holder.Visible then
        resultUI()
        wait(0.5)
        clickRewards()
        wait(1)
        returntoLobby()
    end
end)



-------------------------------------------------------------------------

do
    Tabs.Main:AddParagraph({
        Title = "AUTOPLAY",
        Content = "USE REMOTE SPY TO GET UR UNIT ID"
    })

    Tabs.Legend:AddParagraph({
        Title = "LEGEND STAGE",
        Content = "MUST USE EVO GETO LVL 50"
    })

    Tabs.Optimize:AddParagraph({
        Title = "OPTIMIZER",
        Content = "MARIS RACAL EFFECT IN GAME"
    })

    local disableTextureState = settings["DisableTexture"] or false
    local ToggleDisableTexture = Tabs.Optimize:AddToggle("MyToggleDisableTexture", {
        Title = "Disable Texture",
        Default = disableTextureState
    })

    -- Toggle Disable Textures
    ToggleDisableTexture:OnChanged(function()
        settings["DisableTexture"] = Options.MyToggleDisableTexture.Value
        saveSettings(settings)
        print("Disable Texture Toggle changed:", Options.MyToggleDisableTexture.Value)
        
        if Options.MyToggleDisableTexture.Value then
            removeLaggyObjects()
        end
    end)

    -- Toggle for delete map
    local deleteMapState = settings["DeleteMap"] or false
    local ToggleDeleteMap = Tabs.Optimize:AddToggle("MyToggleDeleteMap", {
        Title = "Clean Map",
        Default = deleteMapState
    })

    -- Toggle Delete Map
    ToggleDeleteMap:OnChanged(function()
        settings["DeleteMap"] = Options.MyToggleDeleteMap.Value
        saveSettings(settings)
        print("Delete Map Toggle changed:", Options.MyToggleDeleteMap.Value)

        -- Trigger deleteMapObjects() if toggle is enabled
        if Options.MyToggleDeleteMap.Value then
            deleteMap()
        end
    end)

    local unitIdState = settings["UnitID"] or ""
	local Input = Tabs.Main:AddInput("Input", {
		Title = "Unit ID",
		Default = unitIdState, -- Load saved value
		Placeholder = "Enter Unit ID",
		Numeric = false, -- Allows alphanumeric input
		Finished = false,
		Callback = function(Value)
			unitIdState = Value -- Update the state
			settings["UnitID"] = Value -- Save the new value to settings
			saveSettings(settings) -- Persist the updated settings
			print("Unit ID updated to:", unitIdState) -- Debug
		end
	})

		-- Function to place Itadori
	local function placeItadori()
		if not workspace:FindFirstChild("_map") then
			print("Map not detected")
			return
		end

		print("Using Unit ID:", unitIdState) -- Debug

		if not unitIdState or unitIdState == "Default" or unitIdState == "" then
			print("Unit ID is not set or invalid.")
			return
		end

		local args = {
			[1] = unitIdState,
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
			print("Map not detected")
			return
		end

		if not unitIdState or unitIdState == "Default" or unitIdState == "" then
			print("Unit ID is not set or invalid.")
			return
		end

		-- Append "1" to the Unit ID for upgrades
		local upgradedUnitId = tostring(unitIdState) .. "1"

		local args = {
			[1] = upgradedUnitId
		}

		game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(unpack(args))
	end
	

    
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

			-- Run placeItadori in the main thread
			for i = 1, 15 do
				placeItadori()
				wait(2)
			end

			-- Run upgradeItadori in a separate thread
			spawn(function()
				for i = 1, 3000 do
					upgradeItadori()
					wait(2)
				end
			end)
		end
	end)

    local legendStageState = settings["AutoLegendStage"] or false
    local ToggleLegendStage = Tabs.Legend:AddToggle("MyToggleLegendStage", {
        Title = "Auto Legend Stage",
        Default = legendStageState
    })

    ToggleLegendStage:OnChanged(function(isEnabled)
		legendStageState = isEnabled
		settings["AutoLegendStage"] = isEnabled
		saveSettings(settings)

		if legendStageState then
			joinLobby()
			wait(1)
			joinLegendStage()
			wait(1)
			startLobby()
			voteStart()
			hideHolder()

			for i = 1, 24 do
				placeUnit()
				wait(2)
			end

			for i = 1, 300 do
                upgradeGetu()
                wait(2)
            end
		end
	end)
end
