--#9
repeat task.wait(5) until game:IsLoaded()
getgenv().FocusWave = 5
getgenv().PriorityCards = {
    "+ Random Curses III",
    "+ Random Curses II",
    "+ Random Curses I",
    "+ Enemy Speed III",
    "+ Enemy Speed I",
    "+ Yen I",
    "+ Yen II",
    "+ Yen III",
    "- Cooldown I",
    "+ Attack I",
    "+ Range I",
    "- Cooldown II",
    "+ Attack II",
    "+ Range II",
    "- Cooldown III",
    "+ Range III",
    "+ Attack III",
    "+ Enemy Health I",
    "+ Explosive Deaths I",
    "+ Enemy Shield I",
    "+ Enemy Regen I",
    "+ Enemy Speed II",
    "+ Explosive Deaths II",
    "+ Enemy Shield II",
    "+ Enemy Regen II",
    "+ Explosive Deaths III",
    "+ Enemy Shield III",
    "+ Enemy Regen III"
}
getgenv().Cards = {
    "+ Random Curses III",
    "+ Random Curses II",
    "+ Random Curses I",
    "+ Enemy Speed I",
    "+ Enemy Speed II",
    "+ Enemy Speed III",
    "- Active Cooldown I",
    "- Active Cooldown II",
    "- Active Cooldown III",
    "+ Explosive Deaths II",
    "+ Yen I",
    "+ Yen II",
    "+ Yen III",
    "- Cooldown I",
    "+ Range I",
    "- Cooldown II",
    "- Cooldown III",
    "+ Range II",
    "+ Boss Damage I",
    "+ Boss Damage II",
    "+ Boss Damage III",
    "+ Random Blessings I",
    "+ Random Blessings II",
    "+ Random Blessings III",
    "+ Enemy Health III",
    "+ Explosive Deaths I",
    "+ Enemy Health I",
    "+ Enemy Shield I",
    "+ Attack I",
    "+ Enemy Health II",
    "+ Enemy Shield II",
    "+ Explosive Deaths III",
    "+ Range III",
    "+ Enemy Shield III",
    "+ Attack II",
    "+ Attack III",
    "+ Double Range",
    "+ Double Attack",
    "+ Enemy Regen I",
    "+ Enemy Regen II",
    "+ Enemy Regen III",    
    "+ New Path"
}
local success1, errorMsg1 = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bocchi-World/Bocchi-Main/refs/heads/main/pickcard.lua"))()
end)
if success1 then
    print("done")
else
    warn("false1")
end
local success2, errorMsg2 = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Ngducok/doing-some-shit/refs/heads/main/hey.lua"))()
end)
if success2 then
    print("done")
else
    warn("false2")
end
