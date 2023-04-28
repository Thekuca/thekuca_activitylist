local ESX = exports['es_extended']:getSharedObject()

local function konvertujSat(decimala)
  local sat = math.floor(decimala)
  local minut = math.floor((decimala - sat) * 60)
  return string.format("%d:%02d", sat, minut)
end

local function otvoriListu()
	ESX.TriggerServerCallback('thekuca_vrijeme:povuciListu', function(lista)
		local kontekst = {}
		for i = 1, #lista, 1 do
			table.sort(lista, function(a, b) return tonumber(a.vrijeme) > tonumber(b.vrijeme) end)
			local vrijemeSati = 0
			local tempBroj = lista[i].vrijeme / 60
			vrijemeSati = math.floor(tempBroj * 10) / 10
			local zapraviSat = konvertujSat(vrijemeSati)
			kontekst[i] = {
				title = '🙍‍♂🙍 | Igrac: ' .. lista[i].name,
				description = '🔢 | Pozicija: ' .. i,
				metadata = {
					'⭐ | Sati: ' .. zapraviSat,
					'⭐ | Minute: ' .. lista[i].vrijeme,
				}
			}
		end

		lib.registerContext({
			id = 'smirise',
			menu = 'staMislis',
			title = 'Thekuca | Lista Aktivnosti',
			options = kontekst,
		})
		lib.showContext('smirise')
	end)
end)

ESX.RegisterInput('thekuca_activitylist:open', 'Open activity list', 'KEYBOARD', 'F9', false, otvoriListu)
