ThekucaAktivnost = {
    ListaAktivnosti = {},
    PrviPut = function(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local meta = xPlayer.getMeta('Aktivnost', 'Ukupno')

        if not meta then
            xPlayer.setMeta('Aktivnost', 'Ukupno', 0)
            return 0
        end

        return meta
    end
}

setmetatable(ThekucaAktivnost.ListaAktivnosti, {
    __call = function()
        for i = 1, #ThekucaAktivnost.ListaAktivnosti do
            table.sort(ThekucaAktivnost.ListaAktivnosti, function(a, b)
                return tonumber(a.vrijeme) > tonumber(b.vrijeme)
            end)
        end

        TriggerClientEvent('thekuca_activitylist/UpdateList', -1, ThekucaAktivnost.ListaAktivnosti)
        collectgarbage('collect')
    end,

    __newindex = function(self, k, v)
        rawset(self, k, v)
        if not v.ignore then
            self()
        end
    end
})

CreateThread(function()
    for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        ThekucaAktivnost.ListaAktivnosti[#ThekucaAktivnost.ListaAktivnosti+1] = {
            ime = GetPlayerName(xPlayer.source),
            vrijeme = ThekucaAktivnost.PrviPut(xPlayer.source),
            ignore = true
        }
    end
    ThekucaAktivnost.ListaAktivnosti()
end)

CreateThread(function()
    while true do
        Wait(300*1000) -- 5 minutes update time
        ThekucaAktivnost.ListaAktivnosti()
    end
end)

AddEventHandler('esx:playerLoaded', function(_, obj)
    obj.setMeta('Aktivnost', 'Ulazak', os.time())
    obj.triggerEvent('thekuca_activitylist/UpdateList', ThekucaAktivnost.ListaAktivnosti)
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local vrijemeUlaska, vrijemeUkupno = xPlayer.getMeta('Aktivnost', 'Ulazak'), ThekucaAktivnost.PrviPut(source)
    local diff = math.floor(os.difftime(os.time(), vrijemeUlaska)/60)

    xPlayer.clearMeta('Aktivnost', 'Ulazak')
    xPlayer.setMeta('Aktivnost', 'Ukupno', vrijemeUkupno + diff)

    ThekucaAktivnost.ListaAktivnosti[#ThekucaAktivnost.ListaAktivnosti+1] = {ime = GetPlayerName(source), vrijeme = vrijemeUkupno + diff, ignore = false}
end)
