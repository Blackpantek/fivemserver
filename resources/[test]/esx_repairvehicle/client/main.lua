local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for i=1, #Config.Locations, 1 do
		carRepairLocations = Config.Locations[i]

		local blip = AddBlipForCoord(carRepairLocations)
		SetBlipSprite(blip, 354)
		SetBlipScale(blip, 0.1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('blip_repair'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		if CanRepairVehicle() then

			for i=1, #Config.Locations, 1 do
				local carRepairLocations = Config.Locations[i]
				local distance = GetDistanceBetweenCoords(coords, carRepairLocations, true)

				if distance < 50 then
					DrawMarker(1, carRepairLocations, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.8, 0, 1, 0, 50, false, false, 2, false, false, false, false)
					canSleep = false
				end

				if distance < 5 then
					canSleep = false

					if Config.EnablePrice then
						ESX.ShowHelpNotification(_U('prompt_repair_paid', ESX.Math.GroupDigits(Config.Price)))
					else
						ESX.ShowHelpNotification(_U('prompt_repair'))
					end

					if IsControlJustReleased(0, Keys['E']) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

						if GetVehicleEngineHealth(vehicle) > 2 then
							RepairVehicle()
						else
							ESX.ShowNotification(_U('repair_failed_isfine'))
						end
					end
				end
			end

			if canSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

function CanRepairVehicle()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

function RepairVehicle()
	ESX.TriggerServerCallback('esx_repair:canAfford', function(canAfford)
		if canAfford then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			if Config.FixCarDamage then
                SetVehicleFixed(vehicle)
			else
				if Config.RealisticVehicleFailure then

			        SetVehicleEngineHealth(vehicle, 700.0)
			        SetVehiclePetrolTankHealth(vehicle, 700.0)
			    else
				    SetVehicleEngineHealth(vehicle, 1000.0) 
			        SetVehiclePetrolTankHealth(vehicle, 1000.0)
			    end
            end

			if Config.EnablePrice then
				ESX.ShowNotification(_U('repair_successful_paid', ESX.Math.GroupDigits(Config.Price)))
			else
				ESX.ShowNotification(_U('repair_successful'))
			end
			Citizen.Wait(5000)
		else
			ESX.ShowNotification(_U('repair_failed'))
			Citizen.Wait(5000)
		end
	end)
end
