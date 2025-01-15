--#6
getgenv().FocusWave = 5
getgenv().PriorityCards = {
    "+ Random Curses III",
    "+ Random Curses II",
    "+ Random Curses I",
    "+ Explosive Deaths III",
    "+ Explosive Deaths II",
    "+ Explosive Deaths I",
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
    "+ Enemy Shield I",
    "+ Enemy Health I",
    "+ Enemy Speed I",
    "+ Enemy Regen I",
    "+ Enemy Shield II",
    "+ Enemy Speed II",
    "+ Enemy Regen II",
    "+ Enemy Shield III",
    "+ Enemy Speed III",
    "+ Enemy Regen III"
}
getgenv().Cards = {
    "+ Random Curses III",
    "+ Random Curses II",
    "+ Random Curses I",
    "+ Explosive Deaths II",
    "+ Explosive Deaths III",
    "+ Enemy Speed II",
    "+ Enemy Speed III",
    "- Active Cooldown I",
    "- Active Cooldown II",
    "- Active Cooldown III",
    "+ Enemy Shield II",
    "+ Enemy Health III",
    "+ Yen I",
    "+ Yen II",
    "+ Yen III",
    "- Cooldown I",
    "+ Attack I",
    "+ Range I",
    "- Cooldown II",
    "+ Attack II",
    "- Cooldown III",
    "+ Range II",
    "+ Boss Damage I",
    "+ Boss Damage II",
    "+ Boss Damage III",
    "+ Random Blessings I",
    "+ Random Blessings II",
    "+ Random Blessings III",
    "+ Double Range",
    "+ Double Attack",
    "+ Enemy Shield I",
    "+ Explosive Deaths I",
    "+ Enemy Health I",
    "+ Enemy Speed I",
    "+ Enemy Regen I",
    "+ Enemy Health II",
    "+ Enemy Regen II",
    "+ Enemy Shield III",
    "+ Range III",
    "+ Attack III",
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
