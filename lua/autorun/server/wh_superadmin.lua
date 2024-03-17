print([[
 _   __                                  _    _ _   _ 
| | / /                                 | |  | | | | |
| |/ / _   _ _ __ __ _ _ __ ___   __ _  | |  | | |_| |
|    \| | | | '__/ _` | '_ ` _ \ / _` | | |/\| |  _  |
| |\  \ |_| | | | (_| | | | | | | (_| | \  /\  / | | |
\_| \_/\__,_|_|  \__,_|_| |_| |_|\__,_|  \/  \/\_| |_|
 
# Creator : https://github.com/Kurama250
# Licence : Creative commons - CC BY-NC-ND 4.0
 
[Addons Kurama WH] is completed and started !
 
]])

local whitelist = {}

local function SaveWhitelist()
    local fileData = [[
-- WhiteList to be able to be SuperAdmin !
local whitelist = {
    ["STEAM_ID01"] = true,
    ["STEAM_ID02"] = true,
}
]]
    file.Write("wh_whitelist/whitelist.lua", fileData)
end

local function LoadWhitelist()
    if file.Exists("wh_whitelist/whitelist.lua", "LUA") then
        include("wh_whitelist/whitelist.lua")
    else
        print("Warning: whitelist file not found!")
    end
end

local function CheckWhitelist()
    for _, ply in ipairs(player.GetAll()) do
        local steamID = ply:SteamID()

        if not whitelist[steamID] then
            if ply:IsSuperAdmin() then
                ply:StripWeapons()
                ply:SetUserGroup("user")
                ply:Kick("Your SteamID is not in the whitelist superadmin.")
            end
        end
    end
end

local function CheckAdminPromotion()
    hook.Add("PlayerPromote", "CheckAdminPromotion", function(ply, target, newRank)
        if newRank == "superadmin" then
            if not whitelist[target:SteamID()] then
                ply:Ban(0, "You promoted a player who is not on the whitelist.")
                target:SetUserGroup("user")
                target:Kick("You have been demoted because your SteamID is not in the whitelist.")
            end
        end
    end)
end

local function WhitelistThink()
    timer.Create("WhitelistCheckTimer", 5, 0, function()
        CheckWhitelist()
    end)
end

hook.Add("Initialize", "WhitelistAddonInit", function()
    if not file.Exists("wh_whitelist", "DATA") then
        file.CreateDir("wh_whitelist")
        print("[Addons Kurama WH] The 'wh_whitelist' directory has been created.")
        SaveWhitelist()
    else
        print("[Addons Kurama WH] The 'wh_whitelist' directory already exists.")
    end
    LoadWhitelist()
    WhitelistThink()
    CheckAdminPromotion()
end)
