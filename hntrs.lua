local TeleportService = game:GetService("TeleportService")

if _G.SafeExecute then
    return
end
_G.SafeExecute = true

local scriptToExecute = [[
    game.Loaded:Wait()
    if _G.SafeExecute then return end
    _G.SafeExecute = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kosowa/asd/refs/heads/main/hntrsmain.lua"))()
    print("✅ Auto-executed!")
]]

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kosowa/asd/refs/heads/main/hntrsmain.lua"))()
    print("✅ Executed Immediately!")
end)

game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    if _G.SafeExecuteQueued then
        return
    end
    _G.SafeExecuteQueued = true

    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport(scriptToExecute)
    elseif queue_on_teleport then
        queue_on_teleport(scriptToExecute)
    else
        warn("❌ Your executor does not support queue_on_teleport!")
    end
end)
