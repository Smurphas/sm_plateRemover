local LastVehicle = nil
local LicencePlate = {}
LicencePlate.Index = false
LicencePlate.Number = false

RegisterNetEvent('sm_plateRemover:remove')
AddEventHandler('sm_plateRemover:remove', function()
    if not LicencePlate.Index and not LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then
			LastVehicle = Vehicle
            -- Progress Bar'as
            exports['progressBars']:startUI(12000, "Nuimami Numeriai")
            Animation()
            SetVehicleDoorOpen(Vehicle,5)
            Citizen.Wait(4000)
            Citizen.Wait(4000)
            SetVehicleDoorShut(Vehicle, 5)
            Citizen.Wait(4000)
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
                TriggerEvent("pNotify:SendNotification", {
                              	  text = '<strong class="blue-text">Nuėmei numerius</strong>',
                              	  type = "info",
                              	  timeout = 1000,
                               	  layout = "bottomCenter",
                                  queue = "global"
				})
            LicencePlate.Index = GetVehicleNumberPlateTextIndex(Vehicle)
            LicencePlate.Number = GetVehicleNumberPlateText(Vehicle)
            -- Tr.Priemones numeriai = "        ", aka nieka.
            SetVehicleNumberPlateText(Vehicle, " ")
        else
	TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text">Arti nėra transporto priemonės!</strong>',
                                type = "error",
                                timeout = 2000,
                                layout = "centerLeft",
                                queue = "global"
                            })
        end
    else
	TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text">Jūs jau uždėjote numerius</strong>',
                                type = "error",
                                timeout = 2000,
                                layout = "centerLeft",
                                queue = "global"
                            })

    end
end)

--RegisterCommand("nuimtinumerius", 'admin' function()
--    TriggerEvent("sm_plateRemover:remove")
--end)

-- Komanda uzdeti numerius
RegisterClientEvent('sm_plateRemover:puton', function(source)
    if LicencePlate.Index and LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if ( (Distance < 3.5) and not IsPedInAnyVehicle(PlayerPed, false) ) then
		if (Vehicle == LastVehicle) then
				LastVehicle = nil
				-- Progress bar'as
                exports['progressBars']:startUI(12000, "Uzdedami Numeriai")
                Animation()
                SetVehicleDoorOpen(Vehicle,5)
                Citizen.Wait(4000)
                Citizen.Wait(4000)
                SetVehicleDoorShut(Vehicle, 5)
			Citizen.Wait(4000)
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text">Uzdeti numeriai</strong>',
                                type = "info",
                                timeout = 6000,
                                 layout = "bottomCenter",
                              queue = "global"
            })
			SetVehicleNumberPlateTextIndex(Vehicle, LicencePlate.Index)
			SetVehicleNumberPlateText(Vehicle, LicencePlate.Number)
			-- Grazina buvusius numerius
			LicencePlate.Index = false
			LicencePlate.Number = false
		else
	TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text">Šie numeriai čia nepriklauso</strong>',
                                type = "error",
                                timeout = 2000,
                                layout = "centerLeft",
                                queue = "global"
                            })

		end
        else
	TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text"><Arti nėra transporto priemonės/strong>',
                                type = "error",
                                timeout = 2000,
                                layout = "centerLeft",
                                queue = "global"
                            })

        end
    else
	TriggerEvent("pNotify:SendNotification", {
                                text = '<strong class="blue-text">Jūs neturite ženklelio</strong>',
                                type = "error",
                                timeout = 2000,
                                layout = "centerLeft",
                                queue = "global"
                            })

    end
end)

-- Animacija
function Animation()
    local pid = PlayerPedId()
    RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do 
		Citizen.Wait(10) 
	end
    TaskPlayAnim(pid,"mini@repair","fixing_a_player",1.0,-1.0, 11000, 0, 1, true, true, true)
end
