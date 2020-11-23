resource_type 'gametype' { name = '🔥 • Solaria RolePlay' }

client_scripts {
    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",
    
    "synchronized/inventory/itemsCat.lua",
    "synchronized/inventory/itemsList.lua",
    "synchronized/inventory/itemsInfos.lua",

    "client/main/*.lua",
    "client/ui/*.lua",
    "client/utils/*.lua",
    "client/inventory/*.lua"
}

server_scripts {
    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",
    
    "synchronized/inventory/itemsCat.lua",
    "synchronized/inventory/itemsList.lua",
    "synchronized/inventory/itemsInfos.lua",

    "server/data/*.lua",
    "server/main/*.lua"
}

fx_version 'adamant'
games { 'gta5' };