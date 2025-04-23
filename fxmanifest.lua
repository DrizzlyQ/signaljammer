fx_version 'cerulean'
game 'gta5'

description 'QBCore Signal Jammer Script'

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

shared_scripts {
    '@ox_lib/init.lua',
}
