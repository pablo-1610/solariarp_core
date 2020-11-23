resource_type 'gametype' { name = '🔥 • Solaria RolePlay' }

server_script 'server/mysql/mysql-async.js'
client_script 'client/mysql/mysql-async-client.js'

files {
  'client/ui/index.html',
  'client/ui/app.js',
  'client/ui/app.css',
  'client/ui/fonts/fira-sans-v9-latin-700.woff',
  'client/ui/fonts/fira-sans-v9-latin-700.woff2',
  'client/ui/fonts/fira-sans-v9-latin-italic.woff',
  'client/ui/fonts/fira-sans-v9-latin-italic.woff2',
  'client/ui/fonts/fira-sans-v9-latin-regular.woff',
  'client/ui/fonts/fira-sans-v9-latin-regular.woff2',
  'client/ui/fonts/MaterialIcons-Regular.eot',
  'client/ui/fonts/MaterialIcons-Regular.ttf',
  'client/ui/fonts/MaterialIcons-Regular.woff',
  'client/ui/fonts/MaterialIcons-Regular.woff2',
}

ui_page 'client/ui/index.html'

client_scripts {
    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",
    "client/foxy/*.lua",
    "client/rage/RMenu.lua",
    "client/rage/menu/RageUI.lua",
    "client/rage/menu/Menu.lua",
    "client/rage/menu/MenuController.lua",

    "client/rage/components/*.lua",

    "client/rage/menu/elements/*.lua",

    "client/rage/menu/items/*.lua",

    "client/rage/menu/panels/*.lua",

    "client/rage/menu/windows/*.lua",

    
    
    "synchronized/inventory/itemsCat.lua",
    "synchronized/inventory/itemsList.lua",
    "synchronized/inventory/itemsInfos.lua",

    "client/main/*.lua",
    "client/ui/*.lua",
    "client/utils/*.lua",
    "client/inventory/*.lua"


}

server_scripts {
    "server/mysql/MySQL.lua",

    "synchronized/main/*.lua",
    "synchronized/utils/*.lua",
    
    "synchronized/inventory/itemsCat.lua",
    "synchronized/inventory/itemsList.lua",
    "synchronized/inventory/itemsInfos.lua",

    "server/data/*.lua",
    "server/main/*.lua",
    "server/utils/*.lua",

    "server/foxy/*.lua"
}



fx_version 'adamant'
games { 'gta5' };