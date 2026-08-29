local loaders = {
    [35789249] = "https://raw.githubusercontent.com/kosowa02/v2/refs/heads/main/gago", -- GaG
    [36015593] = "https://api.luarmor.net/files/v3/loaders/3dd0d7e4978bbd5e49aa2662068ab413.lua", -- Hunty Zombies
    [34088633] = "https://api.jnkie.com/api/v1/luascripts/public/65bb0d97381344345af0f2318461a681eaff15dbee637eb8dcab033a02ffa590/download", -- AFS
    [34869880] = "https://api.luarmor.net/files/v3/loaders/d9d8c4ca6f8dec16819206c7d03bec60.lua", --PlantsVsBrainrot
}

local url = loaders[game.CreatorId]
if url then
    loadstring(game:HttpGet(url))()
end
