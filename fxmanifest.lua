fx_version 'adamant'
games { 'gta5' };

client_scripts {
    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",

    "client/main/*.lua",
    "client/ui/*.lua",
    "client/utils/*.lua"
}

server_scripts {
    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",

    "server/data/*.lua",
    "server/main/*.lua"
}