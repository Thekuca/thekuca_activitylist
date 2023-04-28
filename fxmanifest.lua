fx_version 'cerulean'
games { 'gta5' }

author "github.com/Thekuca"
description "Activity list"

version '1.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
  'cl.lua',
}

server_scripts { 
  '@oxmysql/lib/MySQL.lua',
  'sv.lua',
}
