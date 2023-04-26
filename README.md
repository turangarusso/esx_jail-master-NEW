
<h1 align="center">
esx_jail-master-NEW
  <br>
</h1>

<h4 align="center">A New update version of Jail Master
.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#credits">Credits</a> •
  <a href="#license">License</a>
</p>


## Key Features

* Jail and unjail player for a custom time
  - /jail1 and /unjail only for admin
* New /prigione TIME command for jail closer player for a custom time
* Esx getSharedObject Update
* Check if the player has the job "police"
* Esx Notification system


## How To Use

Copy the folder in the resource file of your server

You can change in the client the notification and also the police job name

```lua
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
```
You can also implement the target and open ox_lib nui (Credit BostonG)

```lua

Jail_Player = function()
    local job = ESX.PlayerData.job.name
    if job ~= "police" then return end
    local cTarget = exports.ox_inventory:PlayerSearch()
    CreateThread(function()
        while true do
            if exports.ox_inventory:SelectedPlayer() == nil then
                Wait(500)
            else
                cTarget = exports.ox_inventory:SelectedPlayer()
                if cTarget == 'nil' or cTarget == 0 then
                    break
                end
                cTarget = GetPlayerPed(GetPlayerFromServerId(cTarget))
                local playerPed = PlayerPedId()
                if cTarget and IsPedAPlayer(cTarget) and #(GetEntityCoords(playerPed, true) - GetEntityCoords(cTarget, true)) <= 2.0 then
                    cTarget = GetPlayerServerId(NetworkGetPlayerIndexFromPed(cTarget))
                    local input = lib.inputDialog('Jail Menu', {
                        {type = 'number', label = 'Inserisci Minuti', description = 'Minuti da scontare in prigione', icon = 'hashtag'}
                    })
                        if not input[1] then return end
                        if input[1] <= 20 then
                            TriggerServerEvent('esx_jail:sendToJail', cTarget, input[1] * 60)
                        elseif input[1] > 20 then
                            ESX.ShowNotification("Non puoi impostare un valore superiore a 20")
                        else
                            ESX.ShowNotification("inserisci il tempo espresso in minuti")
                        end
                    break
                end
                Wait(2000)
            end
            Wait(5)
        end
    end)
end
exports("Jail_Player", Jail_Player)

RegisterNetEvent("police:client:JailPlayer", function()
    Jail_Player()
end)

```
> **Note**
> You need also to edit config files, test it with your script and edit the config file if you have any issue.


## Credits

Russo Giovanni M.

The System RP

## License

MIT

---

