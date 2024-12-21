ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

TriggerEvent('chat:addSuggestion', '/' .. Config.Transfer, 'Transfer a car to player', {
	{ name="id", help="The ID of the player" },
    { name="plate", help="Vehicle plate" }
})

--TriggerEvent('chat:addSuggestion', '/' .. Config.Transfer, 'Verschieben eines Fahrzeuges', {
--	{ name="id", help="Spieler ID" },
--    { name="plate", help="Kennzeichen" }
--})