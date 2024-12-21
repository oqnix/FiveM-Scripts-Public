fx_version 'adamant'
game 'gta5'
lua54 'yes'

escrow_ignore {
    'config.lua',
    'client.lua',
    'local/de.lua',
    'local/en.lua',
}

name "oqnix"
description "Admin Transfer"

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

client_scripts {
    'client.lua'
}

shared_scripts { 
    'config.lua', 
}       

