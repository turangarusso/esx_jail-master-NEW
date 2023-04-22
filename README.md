
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

You can change in the client the norification and also the police job name

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



> **Note**
> You need also to edit config files, test it with your script and edit the config file if you have any issue.


## Credits

Russo Giovanni M.

The System RP

## License

MIT

---

