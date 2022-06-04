print("^0======================================================================^7")
print("AntiCheat by sAsPeCt | https://discord.gg/2rJnz6XE72")
print("^0======================================================================^7")


local function ResourceList()
    local resourceList = {}
    for i=0,GetNumResources()-1 do
        resourceList[i+1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("saspect-anticheat:clientresources", resourceList)
end

Citizen.CreateThread(function()
    local BlackWeapons = Config.BlacklistedWeapons
    if Config.BlacklistWeapons then
	    while true do
            Citizen.Wait(1500)
            local ped = GetPlayerPed(PlayerId())
            for k, weaponName in ipairs(BlackWeapons) do
                local weaponHash = GetHashKey(weaponName)
                local HasWeapon = HasPedGotWeapon(ped, weaponHash, false)
                if HasWeapon then
                    RemoveAllPedWeapons(ped, true)
                    local id = PlayerId()
                    local PlayerID = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
                    TriggerServerEvent('saspect-anticheat:blackweapon', weaponName, PlayerID, weaponHash, id)
                end
            end        

        end
    end
end)



Citizen.CreateThread(function()
    BlackVehs = Config.BlacklistedVehicles
    if Config.BlacklistVehicles then
	    while true do
            Citizen.Wait(1500)
            local ped = GetPlayerPed(PlayerId())
            for k, vehName in ipairs(BlackVehs) do
                local veh = GetVehiclePedIsUsing(ped)
                if IsVehicleModel(veh, GetHashKey(vehName)) then
                    local displaytext = vehName
                    local PlayerID = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
                    TriggerServerEvent('saspect-anticheat:blackveh', displaytext, PlayerID, veh)
                end
            end        
        end
    end
end)

RegisterNetEvent("saspect-anticheat:delveh")
AddEventHandler("saspect-anticheat:delveh", function(veh)
    if (DoesEntityExist(veh)) then
        local ped = GetPlayerPed(PlayerId())
        SetEntityAsMissionEntity(GetVehiclePedIsIn(ped, true), 1, 1)
		DeleteEntity(GetVehiclePedIsIn(ped, true))
		SetEntityAsMissionEntity(ped, 1, 1)
		DeleteEntity(ped)
    end
end)

Citizen.CreateThread(function()
    if Config.DetectGodmode then
	    while true do
            Citizen.Wait(1500)
            local HasGodmode = GetPlayerInvincible(PlayerId())
            if HasGodmode then
                local PlayerID = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
                TriggerServerEvent('saspect-anticheat:godmode', PlayerID)
            end
              
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        ResourceList()
        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if Config.ExplosionProtection then
            SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)
        end
        if Config.AntiExplosiveWeapons then
            local PlayerPed = GetPlayerPed(PlayerId())
			local PedWeapon = GetSelectedPedWeapon(PlayerPed)
            local WeaponGroup = GetWeapontypeGroup(PedWeapon)
            local DamageType = GetWeaponDamageType(PedWeapon)
            if WeaponGroup == -1609580060 or WeaponGroup == -728555052 or PedWeapon == -1569615261 then
                if DamageType ~= 2 then
                    local PlayerID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPed))
                    TriggerServerEvent('saspect-anticheat:expoweapon', PlayerID, PedWeapon, true)
                end
            elseif WeaponGroup == 416676503 or WeaponGroup == -957766203 or WeaponGroup == 860033945 or WeaponGroup == 970310034 or WeaponGroup == -1212426201 then
                if DamageType ~= 3 then
                    local PlayerID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPed))
                    TriggerServerEvent('saspect-anticheat:expoweapon', PlayerID, PedWeapon, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local registeredCommands = GetRegisteredCommands()
		TriggerServerEvent("saspect-anticheat:commandlist", registeredCommands)
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        if NetworkIsInSpectatorMode() then
            TriggerServerEvent("saspect-anticheat:spectate")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(1000)
	    SetPedInfiniteAmmoClip(PlayerPedId(), false)
	    SetEntityInvincible(PlayerPedId(), false)
	    SetEntityCanBeDamaged(PlayerPedId(), true)
	    ResetEntityAlpha(PlayerPedId())
	    local isFalling = IsPedFalling(PlayerPedId())
	    local isRadoll = IsPedRagdoll(PlayerPedId())
	    local parachuteState = GetPedParachuteState(PlayerPedId())
	    if parachuteState >= 0 or isRadoll or isFalling then
		    SetEntityMaxSpeed(PlayerPedId(), 80.0)
	    else
		    SetEntityMaxSpeed(PlayerPedId(), 7.1)
	    end
    end
end)
