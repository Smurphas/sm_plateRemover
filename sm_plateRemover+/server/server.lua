ESX = nil 
local plateoff = false  

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('screwdriver', function(source)
    if plateoff == false then 
        TriggerClientEvent('sm_plateRemover:remove', source)
        plateoff = true
    else 
        TriggerClientEvent('sm_plateRemover:puton', source)
        plateoff = false
    end
end)