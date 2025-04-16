local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local backpack = player:WaitForChild("Backpack")
local maxDistance = 50

local sellPosition = Vector3.new(61.585472106933594, 2.999999761581421, -0.5732157230377197)
local sellRemote = game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory

local function teleportTo(position)
    rootPart.CFrame = CFrame.new(position)
end

local function interactWithPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return false end
    if prompt.ActionText ~= "Collect" then return false end

    local parent = prompt.Parent
    if not parent or not parent:IsA("BasePart") then return false end

    local distance = (rootPart.Position - parent.Position).Magnitude
    if distance > maxDistance then return false end

    local originalDistance = prompt.MaxActivationDistance
    prompt.MaxActivationDistance = math.huge

    fireproximityprompt(prompt, prompt.HoldDuration + 0.01)

    prompt.MaxActivationDistance = originalDistance
    return true
end

while true do
    if #backpack:GetChildren() >= 200 then
        local originalPosition = rootPart.Position

        -- Teleport to sell zone
        teleportTo(sellPosition)
        task.wait(0.5)

        -- Fire sell remote
        sellRemote:FireServer()

        task.wait(0.5)

        -- Return to original position
        teleportTo(originalPosition)
    end

    for _, obj in ipairs(workspace:GetPartBoundsInRadius(rootPart.Position, maxDistance)) do
        for _, descendant in ipairs(obj:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                interactWithPrompt(descendant)
            end
        end
    end
    task.wait(0.07)
end
