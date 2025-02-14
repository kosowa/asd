local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local UNITS_FOLDER = Workspace:FindFirstChild("_UNITS")
local LOBBY_ASSETS_FOLDER = ReplicatedStorage:FindFirstChild("LOBBY_ASSETS")

-- Ensure folders exist
if not UNITS_FOLDER then
    warn("❌ _UNITS folder not found in Workspace!")
    return
end

if not LOBBY_ASSETS_FOLDER then
    warn("❌ LOBBY_ASSETS folder not found in ReplicatedStorage!")
    return
end

-- Function to safely move a unit
local function moveUnit(unit)
    if unit and unit.Parent == UNITS_FOLDER then
        task.defer(function()
            -- Double-check parent before moving
            if unit.Parent == UNITS_FOLDER then
                unit.Parent = LOBBY_ASSETS_FOLDER
                print("✅ Moved unit:", unit.Name, "➡️ LOBBY_ASSETS")
            end
        end)
    end
end

-- Move all existing units at script start
for _, unit in ipairs(UNITS_FOLDER:GetChildren()) do
    moveUnit(unit)
end

-- Detect new units dynamically and move them
UNITS_FOLDER.ChildAdded:Connect(moveUnit)
