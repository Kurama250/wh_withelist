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

-- WhiteList to be able to be SuperAdmin !
local whitelist = {
    ["STEAM_ID01"] = true,
    ["STEAM_ID02"] = true,
}

local function CheckWhitelist()
    for _, ply in ipairs(player.GetAll()) do
        local steamID = ply:SteamID()

        if not whitelist[steamID] then
            if ply:IsSuperAdmin() then
                ply:StripWeapons()
                ply:SetUserGroup("user")
                ply:Kick("Your SteamID is not in the whitelist.")
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
    WhitelistThink()
    CheckAdminPromotion()
end)