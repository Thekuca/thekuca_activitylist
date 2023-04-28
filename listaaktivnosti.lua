local ESX = exports['es_extended']:getSharedObject()

function konvertujSat(decimala)
  local sat = math.floor(decimala)
  local minut = math.floor((decimala - sat) * 60)
  return string.format("%d:%02d", sat, minut)
end

RegisterNetEvent('thekuca_vrijeme:otvoriListu')
AddEventHandler('thekuca_vrijeme:otvoriListu', function()
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
			id = 'jebemtisve',
			menu = 'staMislis',
			title = 'Asterix | Lista Aktivnosti',
			options = kontekst,
		})
		lib.showContext('jebemtisve')
	end)
end)