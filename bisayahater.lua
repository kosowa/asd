-- V7.9.0
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
    Title = "ANIME REALMS | V7.9.0",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 300),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Macro = Window:AddTab({ Title = "|  Macro", Icon = "circle" }),
    Main = Window:AddTab({ Title = "|  Auto Play", Icon = "play" }),
    Legend = Window:AddTab({ Title = "|  Legend Stage", Icon = "shield" }),
    Game = Window:AddTab({ Title = "|  Game", Icon = "gamepad" }),
    Summon = Window:AddTab({ Title = "|  Remnants", Icon = "coins" }),
    Optimize = Window:AddTab({ Title = "|  Optimizer", Icon = "boxes" }),
    Webhook = Window:AddTab({ Title = "|  Webhook", Icon = "globe" }),
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
button.Image = "rbxassetid://129162302366411"  -- Set your image asset ID here
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

-- Macro System
local jsonFilePath = "MACROTEST.json"
local recordedRemotes = {}
local isRecording = false
local isReplaying = false

-- Function to save/load macros
local function saveToFile(data)
    local success, result = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if success then
        writefile(jsonFilePath, result)
    else
        warn("Failed to encode data to JSON:", result)
    end
end

local function loadFromFile()
    if isfile(jsonFilePath) then
        return HttpService:JSONDecode(readfile(jsonFilePath))
    end
    return {}
end

recordedRemotes = loadFromFile()

-- Sanitize arguments for recording
local function sanitizeArgs(args)
    local sanitized = {}
    for i, arg in ipairs(args) do
        if typeof(arg) == "Vector3" then
            sanitized[i] = {X = arg.X, Y = arg.Y, Z = arg.Z}
        elseif typeof(arg) == "table" then
            sanitized[i] = table.clone(arg)
            if arg.Origin and typeof(arg.Origin) == "Vector3" then
                sanitized[i].Origin = {X = arg.Origin.X, Y = arg.Origin.Y, Z = arg.Origin.Z}
            end
            if arg.Direction and typeof(arg.Direction) == "Vector3" then
                sanitized[i].Direction = {X = arg.Direction.X, Y = arg.Direction.Y, Z = arg.Direction.Z}
            end
        else
            sanitized[i] = arg
        end
    end
    return sanitized
end

-- Get player money
local Players = game:GetService("Players")
local function getPlayerMoney()
    local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local moneyLabel = playerGui:FindFirstChild("spawn_units", true)
        if moneyLabel and moneyLabel:FindFirstChild("Lives") then
            local moneyText = moneyLabel.Lives.Frame.Resource.Money.text.ContentText
            return tonumber(moneyText) or 0
        end
    end
    return 0
end

-- Hook __namecall for delayed recording
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    local remoteName = tostring(self.Name)

    -- Preserve default behavior and add delayed recording
    if isRecording and method == "InvokeServer" and (remoteName == "spawn_unit" or remoteName == "upgrade_unit_ingame") then
        local originalArgs = table.clone(args)

        -- Add a delay before capturing money requirement
        task.delay(1, function()
            local currentMoney = getPlayerMoney()

            -- Add another delay before saving to JSON
            task.delay(1, function()
                local sanitizedArgs = sanitizeArgs(originalArgs)
                table.insert(recordedRemotes, {
                    type = self.ClassName,
                    name = remoteName,
                    args = sanitizedArgs,
                    moneyreq = tostring(currentMoney),
                })
                saveToFile(recordedRemotes)
                print("Recorded after delay:", remoteName, "Args:", sanitizedArgs, "MoneyReq:", currentMoney)
            end)
        end)
    end

    -- Always call the original method
    return oldNamecall(self, ...)
end)

-- Replay Recorded Remotes with Delay
local function deserializeArgs(args)
    for i, arg in ipairs(args) do
        if typeof(arg) == "table" then
            if arg.X and arg.Y and arg.Z then
                args[i] = Vector3.new(arg.X, arg.Y, arg.Z)
            elseif arg.Origin and arg.Origin.X then
                arg.Origin = Vector3.new(arg.Origin.X, arg.Origin.Y, arg.Origin.Z)
            end
            if arg.Direction and arg.Direction.X then
                arg.Direction = Vector3.new(arg.Direction.X, arg.Direction.Y, arg.Direction.Z)
            end
        end
    end
    return args
end

local function replayRemotes()
    if isReplaying then return end
    isReplaying = true
    for _, remote in ipairs(recordedRemotes) do
        local targetRemote = ReplicatedStorage:FindFirstChild(remote.name, true)
        if targetRemote then
            while getPlayerMoney() < tonumber(remote.moneyreq) do
                print("Waiting for enough money... Required:", remote.moneyreq)
                task.wait(1) -- Wait until the player has enough money
            end

            task.wait(1) -- Add delay between each replay
            local deserializedArgs = deserializeArgs(remote.args)
            if remote.type == "RemoteFunction" then
                targetRemote:InvokeServer(unpack(deserializedArgs))
                print("Replayed:", remote.name, "Args:", deserializedArgs, "MoneyReq:", remote.moneyreq)
            else
                warn("Unsupported remote type:", remote.type)
            end
        else
            warn("Remote not found:", remote.name)
        end
    end
    isReplaying = false
end

-------------------------------------------------------------------------

local function AntiLag()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    -- Apply settings to parts, meshes, decals, etc.
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end

    -- Remove new objects like forcefields, sparkles, etc.
    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA('ForceField') then
                child:Destroy()
            elseif child:IsA('Sparkles') then
                child:Destroy()
            elseif child:IsA('Smoke') or child:IsA('Fire') then
                child:Destroy()
            end
        end)
    end)
    local Lighting = game:GetService("Lighting") -- Ensure Lighting is properly referenced
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    
    -- Terrain settings
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    
    -- Lighting settings
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
	Lighting.Brightness = 1
    print("ANTILAG ON")
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
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function resultUI()
    local player = game:GetService("Players").LocalPlayer
    local nextButton = player.PlayerGui.ResultsUI.Holder.Buttons.Next

    if nextButton then
        GuiService.AutoSelectGuiEnabled = true
        GuiService.SelectedObject = nextButton
        wait(0.1)
        pressEnter()
    end
end

local VirtualInputManager = game:GetService("VirtualInputManager")

local function clickRewards()
    for i = 1, 5 do
        VirtualInputManager:SendMouseButtonEvent(500, 150, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(500, 150, 0, false, game, 1)
        wait(0.5)
    end
end

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder")

local function hideHolder()
    holder.Visible = false
end

hideHolder()
print("holder has been set to hidden")

local function replay()
    local args = {
        [1] = "replay"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote:InvokeServer(unpack(args))
end

local function returntoLobby()
    game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer()
end

local function VoteStart()
    game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
end
-- Function to check if VoteStart GUI is enabled and trigger VoteStart
local function CheckVoteStart()
    local voteStartGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
    if voteStartGui and voteStartGui.Enabled then
        VoteStart()
    end
end

local function summonBanner()
    local args = {
        [1] = "EventClover",
        [2] = "gems"
    }

    game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_from_banner:InvokeServer(unpack(args))
end

local function clickSummonUnits()
    VirtualInputManager:SendMouseButtonEvent(500, 150, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(500, 150, 0, false, game, 1)
end

local deleteConnection

local function DeleteEnemies()
    local unitsFolder = workspace:FindFirstChild("_UNITS")
    if not unitsFolder then
        warn("_UNITS folder not found in workspace.")
        return
    end

    for _, child in ipairs(unitsFolder:GetChildren()) do
        if child:IsA("Model") and (string.match(child.Name, "^pve%d+$") or string.match(child.Name, "^player%d+$")) then
            child:Destroy()
        end
    end

    deleteConnection = unitsFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") and (string.match(child.Name, "^pve%d+$") or string.match(child.Name, "^player%d+$")) then
            child:Destroy()
        end
    end)
end

local function stopDeleteEnemies()
    if deleteConnection then
        deleteConnection:Disconnect()
        deleteConnection = nil
    end
end

--------------------------------------------------------------------------

do
    Tabs.Macro:AddParagraph({
        Title = "MACRO RECORDER",
        Content = "THIS IS JUST TESTING, MY TINY AZZ BRAIN HURTING"
    })

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

    Tabs.Summon:AddParagraph({
        Title = "SUMMON BANNER",
        Content = "EZ REMNANTS & SECRET FARM"
    })

    Tabs.Optimize:AddParagraph({
        Title = "OPTIMIZER",
        Content = "MARIS RACAL EFFECT IN GAME"
    })

    Tabs.Webhook:AddParagraph({
        Title = "WEBHOOK",
        Content = "GET NOTIFIED"
    })

    local ToggleRecordMacro = Tabs.Macro:AddToggle("RecordMacro", {
        Title = "Record Macro",
        Default = RecordMacroState,
    })

    local PlayMacroState = settings["PlayMacro"] or false
    local TogglePlayMacro = Tabs.Macro:AddToggle("PlayMacro", {
        Title = "Play Macro",
        Default = PlayMacroState,
    })

    -- delete enemies
    local DeleteEnemiesState = settings["DeleteEnemies"] or false
    local ToggleDeleteEnemies = Tabs.Optimize:AddToggle("Delete Enemies", {
        Title = "Delete Enemies",
        Default = DeleteEnemiesState,
    })

	-- Disable Textures
	local AntiLagState = settings["Antilag"] or false
    local ToggleAntiLag = Tabs.Optimize:AddToggle("Antilag", {
        Title = "Anti Lag",
        Default = AntiLagState
    })

	-- Toggle for delete map
    local deleteMapState = settings["DeleteMap"] or false
    local ToggleDeleteMap = Tabs.Optimize:AddToggle("MyToggleDeleteMap", {
        Title = "Clean Map",
        Default = deleteMapState
    })

    local replayState = settings["Replay"] or false
	local ToggleReplay = Tabs.Game:AddToggle("Replay", {
        Title = "Auto Replay",
        Default = replayState,
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
    local function sendToWebhook(playerName, gemAmount, goldAmount, gemRewardTotal, gameResult)
        local httpRequest = (syn and syn.request) or (http and http.request) or (request)
        
        if not httpRequest then
            warn("HTTP request method not available in this executor.")
            return
        end
    
        -- Prepare the embed data
        local embed = {
            ["title"] = "Anime Realms | MCNRS",
            ["color"] = 16711680,
            ["fields"] = {
                {
					["name"] = "User",
					["value"] = "||" .. playerName .. "||",
					["inline"] = false
				},
                {
                    ["name"] = "Player Stats",
                    ["value"] = "Gems: `" .. tostring(gemAmount) .. "`\nGold: `" .. tostring(goldAmount) .. "`",
                    ["inline"] = false
                },
                {
                    ["name"] = "Rewards",
                    ["value"] = "`" .. tostring(gemRewardTotal) .. " GEMS`",
                    ["inline"] = false
                },
                {
                    ["name"] = "Match Result",
                    ["value"] = "`" .. tostring(gameResult) .. "`",
                    ["inline"] = false
                }
            },
            ["thumbnail"] = {
                ["url"] = "https://media.discordapp.net/attachments/942805757936672821/1307254555796307998/xmaslogo.png?ex=6759472d&is=6757f5ad&hm=1534b40e2b6d584e325a18068bd9e376ff5df30d3d18f6e8bd636f79f7ba873f&=&format=webp&quality=lossless&width=595&height=595"
            },
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
    local gemAmount = stats:WaitForChild("gem_amount").Value
    local goldAmount = stats:WaitForChild("gold_amount").Value

    holder:GetPropertyChangedSignal("Visible"):Connect(function()
        if holder.Visible then
            local gameResult
            local success2 = pcall(function()
                gameResult = LocalPlayer:WaitForChild("PlayerGui")
                    :WaitForChild("ResultsUI")
                    :WaitForChild("Holder")
                    :WaitForChild("Middle")
                    :WaitForChild("Timer").ContentText
            end)
            local gemRewardTotal
            local success1 = pcall(function()
                gemRewardTotal = LocalPlayer:WaitForChild("PlayerGui")
                    :WaitForChild("Waves")
                    :WaitForChild("HealthBar")
                    :WaitForChild("IngameRewards")
                    :WaitForChild("GemRewardTotal")
                    :WaitForChild("Holder")
                    :WaitForChild("Main")
                    :WaitForChild("Amount").ContentText
            end)
            sendToWebhook(LocalPlayer.Name, gemAmount, goldAmount, gemRewardTotal, gameResult)
            resultUI()
            clickRewards()
    
            if replayState then
                replay()
            end
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

    -- auto start toggle
    local AutoStartState = settings["AutoStart"] or false
    local ToggleAutoStart = Tabs.Game:AddToggle("AutoStart", {
        Title = "Auto Start",
        Default = AutoStartState,
    })
    local voteStartListener

    -- fastwave toggle
    local fastWaveState = settings["FastWave"] or false
    local ToggleFastWave = Tabs.Game:AddToggle("Fast Wave", {
        Title = "Fast Wave",
        Default = fastWaveState,
    })
    
    local waveChangeConnection

    local function skipWave()
        game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
        print("wave skipped")
    end

    -- summon
	local SummonState = settings["Summon"] or false
    local ToggleSummon = Tabs.Summon:AddToggle("Summon Toggle", {
        Title = "remnants farm",
        Default = SummonState
    })

	---------------------------------------------------------------------------------

    ToggleRecordMacro:OnChanged(function(enabled)
        isRecording = enabled
        settings["RecordMacro"] = enabled
        saveSettings(settings)
    
        if isRecording then
            -- Clear previous recordings to start fresh
            recordedRemotes = {}
            saveToFile(recordedRemotes) -- Overwrite the JSON file with an empty table
            print("Recording Started. Previous recordings cleared.")
        else
            print("Recording Stopped")
        end
    end)

    ToggleSummon:OnChanged(function(isEnabled)
        SummonState = isEnabled
        settings["Summon"] = isEnabled
        saveSettings(settings)

        if SummonState then
	    Window:Minimize()
            while SummonState do
                summonBanner()
                clickSummonUnits()
                wait()
        
                if not SummonState then
                    break
                end
            end
        end
    end)

    	-- Disable Textures
	ToggleAntiLag:OnChanged(function(isEnabled)
        AntiLagState = isEnabled
        settings["Antilag"] = isEnabled
        saveSettings(settings)

        if AntiLagState then
            AntiLag()
        end
    end)


    -- Auto Start
    ToggleAutoStart:OnChanged(function(isEnabled)
        AutoStartState = isEnabled
        settings["AutoStart"] = isEnabled
        saveSettings(settings)
        
        if AutoStartState then
            local voteStartGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
            if voteStartGui then
                -- Avoid adding multiple listeners by disconnecting the previous one
                if voteStartListener then
                    voteStartListener:Disconnect()
                end
    
                -- Listen for changes in the 'Enabled' property of the VoteStart GUI
                voteStartListener = voteStartGui:GetPropertyChangedSignal("Enabled"):Connect(function()
                    CheckVoteStart()  -- Call CheckVoteStart when the Enabled property changes
                end)
    
                -- Immediately check the state of VoteStart GUI and trigger VoteStart if it's enabled
                CheckVoteStart()
            end
        else
            -- Optionally disconnect the listener when AutoStart is turned off
            if voteStartListener then
                voteStartListener:Disconnect()
            end
        end
    end)

    ToggleFastWave:OnChanged(function(isEnabled)
        fastWaveState = isEnabled
        settings["FastWave"] = isEnabled
        saveSettings(settings)
        
        -- Disconnect previous connection if it exists
        if waveChangeConnection then
            waveChangeConnection:Disconnect()
            waveChangeConnection = nil
        end
    
        if fastWaveState then
            if not workspace:FindFirstChild("_map") then
                print("_map not found, aborting.")
                return
            end
    
            local waveNum = workspace:FindFirstChild("_wave_num")
    
            if waveNum and waveNum:IsA("NumberValue") then
                waveChangeConnection = waveNum:GetPropertyChangedSignal("Value"):Connect(function()
                    wait(0.5)
                    skipWave()
                end)
            else
                print("_wave_num not found or is not a NumberValue!")
            end
        else
            print("Fast Wave disabled.")
        end
    end)

    -- delete enemies
	ToggleDeleteEnemies:OnChanged(function(isEnabled)
        DeleteEnemiesState = isEnabled
        settings["DeleteEnemies"] = isEnabled
        saveSettings(settings)

        if DeleteEnemiesState then
            DeleteEnemies()
        else
            stopDeleteEnemies()
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

    ToggleReplay:OnChanged(function(isEnabled)
        replayState = isEnabled
        settings["Replay"] = isEnabled
        saveSettings(settings)
    end)

    TogglePlayMacro:OnChanged(function(enabled)
        PlayMacroState = enabled
        settings["PlayMacro"] = enabled
        saveSettings(settings)
        if enabled then
            print("Replaying Macro...")
            replayRemotes()
            print("Replay Finished!")
        end
    end)
end
