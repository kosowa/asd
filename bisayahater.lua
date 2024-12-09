-- V3
local VirtualUser = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

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
    Title = " ✅ANIME REALMS | BY MARIS RACAL",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 280),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl,
	Transparency = false
})

local Tabs = {
    Main = Window:AddTab({ Title = "|  Auto Play", Icon = "play" }),
    Legend = Window:AddTab({ Title = "|  Legend Stage", Icon = "shield" }),
    Game = Window:AddTab({ Title = "|  Game", Icon = "gamepad" }),
    Optimize = Window:AddTab({ Title = "|  Optimizer", Icon = "boxes" }),
    Webhook = Window:AddTab({ Title = "|  Webhook", Icon = "globe" }),
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

-------------------------------------------------------------------------

-- Function to remove laggy objects and textures
local function removeLaggyObjects()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.Brightness = 1
    lighting.FogEnd = 9e9
    lighting.EnvironmentDiffuseScale = 0
    lighting.EnvironmentSpecularScale = 0

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

--------------------------------------------------------------

local function deleteMap()
    wait(1)
	if not workspace:FindFirstChild("_map") then
        print("no map detected")
        return
    end
    local map = workspace:FindFirstChild("_map")

    if map then
        for _, child in ipairs(map:GetChildren()) do
            child:Destroy()
        end
        print("All children under _map have been deleted.")
    end
end

-------------------------------------------------------------------------

local function joinLobby()
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

local function selectStage(selectedMap, selectedAct)
	if not workspace:FindFirstChild("DefaultLobby") then
		print("MLobby does not exist. NOT JOINING")
		return
	end

	local args = {
			[1] = "P10",
			[2] = selectedMap .. selectedAct,
			[3] = true,
			[4] = "Normal"
		}
	
	game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(unpack(args))
end

local function selectLegendStage(selectedMapLegend, selectedActLegend)
	if not workspace:FindFirstChild("DefaultLobby") then
		print("MLobby does not exist. NOT JOINING")
		return
	end

	local args = {
			[1] = "P10",
			[2] = selectedMapLegend .. selectedActLegend,
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

-------------------------------------------------------------------------

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

local function hideHolder()
    holder.Visible = false
end

hideHolder()

-------------------------------------------------------------------------

do
    Tabs.Main:AddParagraph({
        Title = "AUTOPLAY",
        Content = "AUTO JOIN GAME NORMAL MODE"
    })

    Tabs.Legend:AddParagraph({
        Title = "LEGEND STAGE",
        Content = "AUTO JOIN LEGEND STAGES NORMAL MODE"
    })

    Tabs.Game:AddParagraph({
        Title = "GAME FUNCTION",
        Content = "WOMP WOMP"
    })

    Tabs.Optimize:AddParagraph({
        Title = "OPTIMIZER",
        Content = "MARIS RACAL EFFECT IN GAME"
    })

    Tabs.Webhook:AddParagraph({
        Title = "WEBHOOK",
        Content = "GET NOTIFIED"
    })

	-- Disable Textures
	local disableTextureState = settings["DisableTexture"] or false
    local ToggleDisableTexture = Tabs.Optimize:AddToggle("MyToggleDisableTexture", {
        Title = "Disable Texture",
        Default = disableTextureState
    })

	-- Toggle for delete map
    local deleteMapState = settings["DeleteMap"] or false
    local ToggleDeleteMap = Tabs.Optimize:AddToggle("MyToggleDeleteMap", {
        Title = "Clean Map",
        Default = deleteMapState
    })

	-- Webhook
	local webhookInputState = settings["Webhook"] or ""
	local Input = Tabs.Webhook:AddInput("Input", {
		Title = "Webhook",
		Default = webhookInputState,
		Placeholder = "Enter Webhook Url",
		Numeric = false,
		Finished = false,
		Callback = function(Value)
			webhookInputState = Value
			settings["Webhook"] = Value
			saveSettings(settings)
			print("Webhook updated to:", webhookInputState)
		end
	})

	local webhookURL = webhookInputState
	local function sendToWebhook(playerName, gemAmount, goldAmount)
		local httpRequest = (syn and syn.request) or (http and http.request) or (request)
		
		if not httpRequest then
			warn("HTTP request method not available in this executor.")
			return
		end
	
		-- Prepare the embed data
		local embed = {
			["title"] = "Anime Realms | MCNRS",
			["color"] = 16776960, -- Yellow color in decimal
			["fields"] = {
				{
					["name"] = "USER",
					["value"] = playerName,
					["inline"] = false
				},
				{
					["name"] = "GEMS",
					["value"] = tostring(gemAmount),
					["inline"] = true
				},
				{
					["name"] = "GOLD",
					["value"] = tostring(goldAmount),
					["inline"] = true
				}
			},
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/1246859825019748425/1301168477259956234/20241030_205841.png?ex=67544693&is=6752f513&hm=6fd708979b056c25eb5335cfe02734d9cdd02147f64deb2425fa3b94ab694fcf&"
			}
            ["footer"] = {
                ["text"] = "discord.gg/FQTCAVF6rF"
            }
		}
	
		local data = {
			["embeds"] = {embed}
		}
	
		local headers = {
			["Content-Type"] = "application/json"
		}
	
		-- Make the HTTP POST request
		httpRequest({
			Url = webhookURL,
			Method = "POST",
			Headers = headers,
			Body = game:GetService("HttpService"):JSONEncode(data)
		})
	end
	
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	
	LocalPlayer:WaitForChild("_stats")
	local stats = LocalPlayer._stats
	local gemAmount = stats:WaitForChild("gem_amount")
	local goldAmount = stats:WaitForChild("gold_amount")

	holder:GetPropertyChangedSignal("Visible"):Connect(function()
		if holder.Visible then
			resultUI()
			sendToWebhook(LocalPlayer.Name, gemAmount.Value, goldAmount.Value)
			wait(0.5)
			clickRewards()
		end
	end)

	---------------------------------------

	-- Toggle AutoJoin Lobby
	local autoJoinEnabled = settings["AutoJoin"] or false
	local ToggleAutoJoin = Tabs.Main:AddToggle("Auto Join", {
        Title = "Auto Join Map",
        Default = autoJoinEnabled,
    })

	-- Map Select Dropdown
	local selectedMap = settings["SelectedMap"] or "namek_"
    local DropdownMap = Tabs.Main:AddDropdown("Map Select", {
        Title = "Maps",
        Values = {"namek_", "marineford_", "karakura_", "shibuya_"},
        Multi = false,
        Default = selectedMap,
    })

	-- Act Select Dropdown
	local selectedAct = settings["SelectedAct"] or "infinite"
    local DropdownAct = Tabs.Main:AddDropdown("Act Select", {
        Title = "Act",
        Values = {"infinite", "level_1", "level_2", "level_3", "level_4", "level_5", "level_6"},
        Multi = false,
        Default = selectedAct,
    })

    -- Toggle AutoJoin Legend Stages
	local autoJoinLegendEnabled = settings["AutoJoinLegend"] or false
	local ToggleAutoJoinLegend = Tabs.Legend:AddToggle("Auto Join Legend", {
        Title = "Auto Join Legend Stage",
        Default = autoJoinLegendEnabled,
    })

    -- Map Legend Select Dropdown
	local selectedMapLegend = settings["SelectedMapLegend"] or "shibuya_"
    local DropdownMapLegend = Tabs.Legend:AddDropdown("Map Legend Select", {
        Title = "Maps",
        Values = {"shibuya_"},
        Multi = false,
        Default = selectedMapLegend,
    })

    -- Act Legend Select Dropdown
	local selectedActLegend = settings["SelectedActLegend"] or "legend_1"
    local DropdownActLegend = Tabs.Legend:AddDropdown("Act Select", {
        Title = "Act",
        Values = {"legend_1", "legend_2", "legend_3"},
        Multi = false,
        Default = selectedActLegend,
    })

    local fastWaveState = settings["FastWave"] or false
	local ToggleFastWave = Tabs.Game:AddToggle("Fast Wave", {
        Title = "Fast Wave",
        Default = fastWaveState,
    })

    local function skipWave()
        game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
        print("wave skipped")
    end

	---------------------------------------------------------------------------------

	-- Disable Textures
	ToggleDisableTexture:OnChanged(function()
        settings["DisableTexture"] = Options.MyToggleDisableTexture.Value
        saveSettings(settings)
        print("Disable Texture Toggle changed:", Options.MyToggleDisableTexture.Value)
        
        if Options.MyToggleDisableTexture.Value then
            removeLaggyObjects()
        end
    end)

	-- Toggle Delete Map
    ToggleDeleteMap:OnChanged(function()
        settings["DeleteMap"] = Options.MyToggleDeleteMap.Value
        saveSettings(settings)
        print("Delete Map Toggle changed:", Options.MyToggleDeleteMap.Value)

        if Options.MyToggleDeleteMap.Value then
            deleteMap()
        end
    end)

	-- Map Select Dropdown
    DropdownMap:OnChanged(function(Value)
        selectedMap = Value
        settings["SelectedMap"] = Value
        saveSettings(settings)
        --
    end)

	-- Act Select Dropdown
    DropdownAct:OnChanged(function(Value)
        selectedAct = Value
        settings["SelectedAct"] = Value
        saveSettings(settings)
        --
    end)

	-- Auto Join Toggle
    ToggleAutoJoin:OnChanged(function(isEnabled)
        autoJoinEnabled = isEnabled
        settings["AutoJoin"] = isEnabled
        saveSettings(settings)
		if autoJoinEnabled then
			joinLobby()
			wait(1)
			selectStage(selectedMap, selectedAct)
			wait(1)
			startLobby()
		end
    end)

    -- Map Legend Select Dropdown
    DropdownMapLegend:OnChanged(function(Value)
        selectedMapLegend = Value
        settings["SelectedMapLegend"] = Value
        saveSettings(settings)
        --
    end)

    -- Act Legend Select Dropdown
    DropdownActLegend:OnChanged(function(Value)
        selectedActLegend = Value
        settings["SelectedActLegend"] = Value
        saveSettings(settings)
        --
    end)

    -- Auto Join Legend Toggle
    ToggleAutoJoinLegend:OnChanged(function(isEnabled)
        autoJoinLegendEnabled = isEnabled
        settings["AutoJoinLegend"] = isEnabled
        saveSettings(settings)
		if autoJoinLegendEnabled then
			joinLobby()
			wait(1)
			selectLegendStage(selectedMapLegend, selectedActLegend)
			wait(1)
			startLobby()
		end
    end)

    ToggleFastWave:OnChanged(function(isEnabled)
        fastWaveState = isEnabled
        settings["FastWave"] = isEnabled
        saveSettings(settings)
        
        if fastWaveState then
            if not workspace:FindFirstChild("_map") then
                return
            end

            task.spawn(function()
                while fastWaveState do
                    local voteStartGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
                    if voteStartGui and not voteStartGui.Enabled then
                        skipWave()
                    else
                        print("VoteStart is enabled, skipping not performed")
                    end
                    wait(1.1)
                end
            end)
        end
    end)
end

Fluent:Notify({
    Title = "FUCK YOU NIGGER",
    Content = "suck my dick",
    Duration = 8
})
