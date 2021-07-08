ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local przeszukane = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HaveFoundAnyZone = false
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k,v in ipairs(Config.Props) do
            local props = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, v.prophash, false, false, false)
            local propspos = GetEntityCoords(props)
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, propspos.x, propspos.y, propspos.z, true)
                if dist < 1.8 then
                    HaveFoundAnyZone = true
                    text3d(vector3(propspos.x, propspos.y, propspos.z + 0.7), '~c~Kliknij ~r~[H]~c~ aby przeszukać')
                    if IsControlJustReleased(0, 74) then
                            if checkissearched(props) == nil then
                                startSearching()
                                table.insert(przeszukane, {id = props})
                            else
                                ESX.ShowNotification('Nic tu nie ma')
                            end
                        end
                    end
                end
if not HaveFoundAnyZone then
    Citizen.Wait(1000)
        end
    end
end)

function checkissearched(hash)
    for k,v in ipairs(przeszukane) do
        if v.id == hash then
            return k
        end
    end
    return nil
end



function startSearching()
    local ped = GetPlayerPed(-1)
    local animDict = 'amb@prop_human_bum_bin@base'
    local animation = 'base'

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    exports['progressBars']:startUI(Config.TimeOfSearching, "Przeszukiwanie")
    TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, Config.TimeOfSearching, 1, 1, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    Citizen.Wait(Config.TimeOfSearching)
        FreezeEntityPosition(ped, false)
        ClearPedTasks(ped)
        TriggerServerEvent("adek:giveitem")
end

text3d = function(coords, text, size)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords      = GetGameplayCamCoords()
    local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
    local size           = size

    if size == nil then
        size = 1
    end

    local scale = (size / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)

        AddTextComponentString(text)
        DrawText(x, y)
    end
end