fx_version 'cerulean'
game 'gta5'

description 'QBX Signal Jammer Script with ox_lib Zones'

author 'Drizzly'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'config.lua'
}

shared_script '@qb-core/import.lua'

dependency 'ox_lib'
dependency 'bl_ui'

lua54 'yes'
