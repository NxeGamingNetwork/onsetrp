local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local teleportPlace = {
    gas_station = { 125773, 80246, 1645 },
    town = { -182821, -41675, 1160 },
    prison = { -167958, 78089, 1569 },
    diner = { 212405, 94489, 1340 }
}

local weaponList = {
    weapon_2 = 2,
    weapon_3 = 3,
    weapon_4 = 4,
    weapon_5 = 5,
    weapon_6 = 6,
    weapon_7 = 7,
    weapon_8 = 8,
    weapon_9 = 9,
    weapon_10 = 10,
    weapon_11 = 11,
    weapon_12 = 12,
    weapon_13 = 13,
    weapon_14 = 14,
    weapon_15 = 15,
    weapon_16 = 16,
    weapon_17 = 17,
    weapon_18 = 18,
    weapon_19 = 19,
    weapon_20 = 20,
}

local vehicleList = {
    vehicle_1 = 1,
    vehicle_2 = 2,
    vehicle_3 = 3,
    vehicle_4 = 4,
    vehicle_5 = 5,
    vehicle_6 = 6,
    vehicle_7 = 7,
    vehicle_8 = 8,
    vehicle_9 = 9,
    vehicle_10 = 10,
    vehicle_11 = 11,
    vehicle_12 = 12,
    vehicle_13 = 13,
    vehicle_14 = 14,
    vehicle_15 = 15,
    vehicle_16 = 16,
    vehicle_17 = 17,
    vehicle_18 = 18,
    vehicle_19 = 19,
    vehicle_20 = 20,
    vehicle_21 = 21,
    vehicle_22 = 22,
    vehicle_23 = 23,
    vehicle_24 = 24,
    vehicle_25 = 25
}

AddRemoteEvent("ServerAdminMenu", function(player)
    local playersIds = GetAllPlayers()

    if tonumber(PlayerData[player].admin) == 1 then
        CallRemoteEvent(player, "OpenAdminMenu", teleportPlace, playersIds, weaponList, vehicleList)
    end
end)


AddRemoteEvent("AdminTeleportToPlace", function(player, place)
    for k,v in pairs(teleportPlace) do
        if k == place then
            SetPlayerLocation(player, v[1], v[2], v[3])
        end
    end
end)

AddRemoteEvent("AdminTeleportToPlayer", function(player, toPlayer)
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z)
end)

AddRemoteEvent("AdminTeleportPlayer", function(toPlayer, player)
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z)
end)

AddRemoteEvent("AdminGiveWeapon", function(player, weaponName)
    weapon = weaponName:gsub("weapon_", "")
    SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1, true)
end)

AddRemoteEvent("AdminSpawnVehicle", function(player, vehicleName)
    vehicle = vehicleName:gsub("vehicle_", "")

    local x, y, z = GetPlayerLocation(player)
    local h = GetPlayerHeading(player)

    spawnedVehicle = CreateVehicle(tonumber(vehicle), x, y, z, h)

    SetVehicleRespawnParams(spawnedVehicle, false)
    SetPlayerInVehicle(player, spawnedVehicle)
end)

AddRemoteEvent("AdminGiveMoney", function(player, toPlayer, account, amount)
    if account == "Cash" then
        PlayerData[player].cash = PlayerData[player].cash + tonumber(amount)
    end
    if account == "Bank" then
        PlayerData[player].bank_balance = PlayerData[player].bank_balance + tonumber(amount)
    end
end)

AddRemoteEvent("AdminKickBan", function(player, toPlayer, type, reason)
    if type == "Ban" then
        mariadb_query(sql, "INSERT INTO `bans` (`id`, `ban_time`, `reason`) VALUES ('"..PlayerData[tonumber(toPlayer)].accountid.."', '"..os.time(os.date('*t')).."', '"..reason.."');")
        
        KickPlayer(player, _("banned_for", reason, os.date('%Y-%m-%d %H:%M:%S', os.time())))
    end
    if type == "Kick" then
        KickPlayer(tonumber(toPlayer), _("kicked_for", reason))
    end
end)