local isInJail, unjail = false, false
local jailTime, fastTimer = 0, 0

ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('esx_jail:jailPlayer')
AddEventHandler('esx_jail:jailPlayer', function(_jailTime)
	jailTime = _jailTime

	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.prison_wear.male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.prison_wear.female)
		end
	end)

	SetPedArmour(playerPed, 0)
	ESX.Game.Teleport(playerPed, Config.JailLocation)
	isInJail, unjail = true, false

	while not unjail do
		playerPed = PlayerPedId()

		RemoveAllPedWeapons(playerPed, true)
		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end

		Citizen.Wait(20000)

		-- Is the player trying to escape?
		if #(GetEntityCoords(playerPed) - Config.JailLocation) > 10 then
			ESX.Game.Teleport(playerPed, Config.JailLocation)
			TriggerEvent('chat:addMessage', {args = {_U('judge'), _U('escape_attempt')}, color = {147, 196, 109}})
		end
	end

	ESX.Game.Teleport(playerPed, Config.JailBlip)
	isInJail = false

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterCommand("prigione",function(_src, arg1)
	local xPlayer = GetPlayerFromServerId(_src) 
	local d, e = ESX.Game.GetClosestPlayer()
    local xId = GetPlayerServerId(d)
	local timeZ = tonumber(table.concat(arg1))

	if ESX.GetPlayerData().job.name == "police" then 

		TriggerServerEvent('esx_jail:sendToJail', xId, timeZ * 60)

		TriggerEvent('esx:showNotification', "Arresto Completato")

	else
		TriggerEvent('esx:showNotification', "Non hai il job police")

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if jailTime > 0 and isInJail then
			if fastTimer < 0 then
				fastTimer = jailTime
			end

			draw2dText(_U('remaining_msg', ESX.Math.Round(fastTimer)), 0.175, 0.955)
			fastTimer = fastTimer - 0.01
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_jail:unjailPlayer')
AddEventHandler('esx_jail:unjailPlayer', function()
	unjail, jailTime, fastTimer = true, 0, 0
end)

AddEventHandler('playerSpawned', function(spawn)
	if isInJail then
		ESX.Game.Teleport(PlayerPedId(), Config.JailLocation)
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.JailBlip)

	SetBlipSprite(blip, 188)
	SetBlipScale (blip, 1.9)
	SetBlipColour(blip, 6)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function draw2dText(text, x, y)
	SetTextFont(4)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end