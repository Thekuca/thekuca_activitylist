ThekucaAktivnost = setmetatable({
	KonvertujSat = function(d)
		return string.format("%d:%02d", math.floor(d), math.floor((d - math.floor(d)) * 60))
	end,
	TrenutnaLista = {},
	NoveOpcije = false
}, {
	__call = function()
		if ThekucaAktivnost.NoveOpcije then
			lib.registerContext({id = 'lista', menu = 'aktivnost', title = 'Thekuca | Lista Aktivnosti', options = ThekucaAktivnost.NoveOpcije})
			ThekucaAktivnost.NoveOpcije = false
		end

		lib.showContext('lista')
	end,
	__newindex = function(self, k, v)
		if k == 'TrenutnaLista' then
			local opcije = {}
			for k2, v2 in pairs(v) do
				opcije[k2]= {
					title = ('🙍‍♂🙍 | Igrac: %s'):format(v2.ime),
					description = ('🔢 | Pozicija: %s'):format(k2),
					metadata = {
						('⭐ | Sati: %s'):format(self.KonvertujSat(math.floor((v2.vrijeme/60) * 10) / 10)),
						('⭐ | Minute: %s'):format(v2.vrijeme),
					}
				}
			end
			self.NoveOpcije = opcije
		end
	end
})

AddEventHandler('thekuca_activitylist/UpdateList', function(lista)
	ThekucaAktivnost.TrenutnaLista = lista
end)

RegisterCommand('activitylist', ThekucaAktivnost, false)
RegisterKeyMapping('activitylist', 'Activity List', 'KEYBOARD', 'F9')
