local prohibitedVars = {
    "FM",
    "fESX",
    "Plane",
    "TiagoMenu",
    "Outcasts666",
    "dexMenu",
    "Cience",
    "LynxEvo",
    "zzzt",
    "AKTeam",
    "gaybuild",
    "ariesMenu",
    "WarMenu",
    "SwagMenu",
    "Dopamine",
    "Gatekeeper",
    "MIOddhwuie",
    "brutan",
    "redstonia",
    "genesis",
    "niggerVehicle",
    "desudomenu",
    "desudo",
    "esxdestroy",
    "vrpdestroy",
    "niggers",
    "blowall",
    "asstarget",
    "Lynx8",
    "dexmenu",
    "esp",
    "AimBot",
    "RainbowVeh",
    "LRPoi8PgQ3H",
    "iBmKMJ4D7K",
    "YVJRPnqZyw",
    "dopamine",
    "O3OQdn3KlMr4K",
    "sGTE",
    "zOChUa04Cn",
    "ig2SBhTNJBxrhTVOI9P",
    "fixvaiculoKeyblind",
    "ojtgh",
    "AimbotBone",
    "ExplodingAll",
    "MIOddhwuie",
    "YKyAw",
    "_Jvt13x6Un9RPE",
    "nPIyrvZsPssLdH2IN",
    "rE.Bypasses.global",
    "FM.Base64.CharList",
    "FM.Config",
    "aimbot_keys",
    "rccar_keys",
    "freecam_keys",
    "FM.FreeCam.On",
    "was_fakedead",
    "fakedead_timer",
    "was_fastrun",
    "was_noragdoll",
    "magic_carpet_obj",
    "preview_magic_carpet",
    "was_invis",
    "was_showing",
    "TriggerBot",
    "AimbotKey",
    "TPAimbotThreshold",
    "OneTap",
    "RageBot",
    "AimbotReleaseKey"
}
local Enabled = true -- Change this to enable client mod menu checks!
function CheckVariables()
    for i, v in pairs(prohibitedVars) do
        if _G[v] ~= nil then
            TriggerServerEvent("saspect-anticheat:luainjection", v)
        end
    end
end

if Enabled then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(30000)
            CheckVariables()
        end
    end)
else
    return "Nil"
end
