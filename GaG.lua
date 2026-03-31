if getgenv().MercenariesLoaded then
    return
end
getgenv().MercenariesLoaded = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(math.random())

local loaders = {
    [35789249] = "https://raw.githubusercontent.com/kosowa02/v2/refs/heads/main/gago", -- GaG
    [36015593] = "https://api.luarmor.net/files/v3/loaders/3dd0d7e4978bbd5e49aa2662068ab413.lua", -- Hunty Zombies
    [34088633] = "https://api.luarmor.net/files/v3/loaders/a2b73ff8c5bf48a0dce49b0bbf496cad.lua", -- AFS
    [34869880] = "https://api.luarmor.net/files/v3/loaders/d9d8c4ca6f8dec16819206c7d03bec60.lua", --PlantsVsBrainrot
}

local url = loaders[game.CreatorId]
if url then
    loadstring(game:HttpGet(url))()
end
