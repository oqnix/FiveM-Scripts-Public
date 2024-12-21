ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Befehl für die Fahrzeugübertragung
RegisterCommand(Config.Transfer, function(source, args, rawCommand)
    -- Überprüfen, ob der Befehl von einem Admin ausgeführt wird
    local xPlayer = ESX.GetPlayerFromId(source)
    local allowed = false

    -- Überprüfen, ob der Spieler in einer der erlaubten Gruppen ist
    for _, group in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == group then
            allowed = true
            break
        end
    end

    -- Zielspieler-ID prüfen
    local targetPlayerId = tonumber(args[1])
    if not targetPlayerId or not GetPlayerName(targetPlayerId) then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'error',
            text = 'Ungültige Spieler-ID!',
            length = 4500,
            style = {
                ['background-color'] = '#DD4B3A',
                ['color'] = '#FFFFFF'
            }
        })
        return
    end

    -- Kennzeichen des Fahrzeugs prüfen
    local plate1 = args[2]
    local plate2 = args[3]
    local plate3 = args[4]
    local plate4 = args[5]

    local plate = (plate1 or "") .. " " .. (plate2 or "") .. " " .. (plate3 or "") .. " " .. (plate4 or "")

    -- Fahrzeug-Daten abfragen
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            -- Wenn das Fahrzeug existiert, übertragen
            local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
            local targetName = targetPlayer.getName()

            -- Fahrzeug dem Zielspieler zuweisen
            MySQL.Sync.execute("UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate", {
                ['@owner'] = targetPlayer.identifier,
                ['@plate'] = plate
            })

            -- Benachrichtigung an beide Spieler
            TriggerClientEvent('mythic_notify:client:SendAlert', targetPlayerId, {
                type = 'inform',
                text = 'Fahrzeug mit dem Kennzeichen ' .. plate .. ' wurde dir von ' .. xPlayer.getName() .. ' übertragen.',
                length = 4500,
                style = {
                    ['background-color'] = '#DD8C1A',
                    ['color'] = '#FFFFFF'
                }
            })

            TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                type = 'inform',
                text = 'Du hast das Fahrzeug mit dem Kennzeichen ' .. plate .. ' an ' .. targetName .. ' übertragen.',
                length = 4500,
                style = {
                    ['background-color'] = '#DD8C1A',
                    ['color'] = '#FFFFFF'
                }
            })
        else
            -- Fehler: Fahrzeug nicht gefunden
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                type = 'error',
                text = 'Fehler! Das Fahrzeug mit dem Kennzeichen ' .. plate .. ' existiert nicht oder wurde falsch eingegeben!',
                length = 4500,
                style = {
                    ['background-color'] = '#DD4B3A',
                    ['color'] = '#FFFFFF'
                }
            })
        end
    end)
end)