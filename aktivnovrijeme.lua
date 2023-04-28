local ESX = exports['es_extended']:getSharedObject()
local lista = {}

local function povuciVremena()
    local svi = MySQL.query.await('SELECT name, vrijeme FROM users WHERE vrijeme > 60')
    if not svi then
        print('pronadeno 0 karaktera za povuci vrijeme')
        lista = {}
        return
    end
    lista = svi
    print('[^2thekuca_sistem^0] ^3Refreshovano^0 online vrijeme ^5igraca^0')
end

SetInterval('aktivnostigraca', 1800000, povuciVremena)

local function updateVrijeme(id, vrijeme, ime)
    local result = MySQL.query.await("SELECT vrijeme FROM users WHERE identifier = ?", {id})
    local ubaci = result == 0 and result[1].vrijeme or vrijeme + result[1].vrijeme
    local query = MySQL.update.await("UPDATE users SET vrijeme = ? WHERE identifier = ?", {ubaci, id})
    if not query then return print('greska tokom ubacivanja vremena') end
    for i = 1, #lista, 1 do
        if lista[i].name == ime then
            lista[i].vrijeme = ubaci
            break
        end
    end
end

AddEventHandler('esx:playerLoaded', function(source)
    Player(source).state.ulazak = os.time()
end)

AddEventHandler('playerDropped', function()
    local igrac = Player(source).state
    igrac.izlazak = os.time()
    updateVrijeme(ESX.GetPlayerFromId(source).identifier, math.floor(os.difftime(igrac.izlazak, igrac.ulazak)/60), GetPlayerName(source))
end)

RegisterCommand("resetujvrijeme", function(source, args, rawCommand)
    local state = Player(source).state
    if state.group ~= 'vlasnik' and state.group ~= 'developer' then
        return
    end
    if not state.duznost then
        return
    end
    local querySvi = 'SELECT * FROM users WHERE vrijeme != 0'
    local queryUpdejtuj = 'UPDATE users SET vrijeme = ? WHERE identifier = ?'
    MySQL.query(querySvi, function(povraceno)
        if not povraceno then return end
        for i = 1, #povraceno, 1 do
            local val = povraceno[i]
            local mozes = MySQL.update.await(queryUpdejtuj, {0, val.identifier})
            if not mozes then print('greska tokom reseta vremena') end
        end
    end)
    print('USPJESNO RESETIRANO VRIJEME SVIM IGRACIMA')
end, false)

RegisterCommand('refreshujlistu', function(source, args, rawCommand)
    local state = Player(source).state
    if state.group ~= 'vlasnik' and state.group ~= 'developer' then return end
    if not state.duznost then return end
    povuciVremena()
end, false)

ESX.RegisterServerCallback('thekuca_vrijeme:povuciListu', function(a, fnc)
    fnc(lista)
end)