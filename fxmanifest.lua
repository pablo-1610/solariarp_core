resource_type 'gametype' { name = '🔥 • Solaria RolePlay' }

server_script 'server/mysql/mysql-async.js'
client_script 'client/mysql/mysql-async-client.js'

files {
  'client/ui/index.html',
  'client/ui/app.js',
  'client/ui/js/script.js',
  'client/ui/css/style.css',
  'client/ui/app.css',
  'client/ui/fonts/pricedown.ttf',
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

  'client/ui/icons/money.png',
  'client/ui/icons/bank.png',
  'client/ui/icons/dirtymoney.png',
  'client/ui/icons/logo.png',

  'client/loading/index.html',
  'client/loading/style.css',
  'client/loading/music.mp3',

  "client/ui/scripts/listener.js",
  "client/ui/scripts/SoundPlayer.js",
  "client/ui/scripts/functions.js"
}



ui_page 'client/ui/index.html'

loadscreen 'client/loading/index.html'

loadscreen_manual_shutdown "yes"

client_scripts {
	"client/loading/client.lua",

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
	"client/menus/*.lua",
	"client/data/*.lua"

    , "client/ipls/lib/common.lua"
	, "client/ipls/lib/observers/interiorIdObserver.lua"
	, "client/ipls/lib/observers/officeSafeDoorHandler.lua"
	, "client/ipls/client.lua"

	-- GTA V
	, "client/ipls/gtav/base.lua"   -- Base IPLs to fix holes
	, "client/ipls/gtav/ammunations.lua"
	, "client/ipls/gtav/bahama.lua"
	, "client/ipls/gtav/floyd.lua"
	, "client/ipls/gtav/franklin.lua"
	, "client/ipls/gtav/franklin_aunt.lua"
	, "client/ipls/gtav/graffitis.lua"
	, "client/ipls/gtav/pillbox_hospital.lua"
	, "client/ipls/gtav/lester_factory.lua"
	, "client/ipls/gtav/michael.lua"
	, "client/ipls/gtav/north_yankton.lua"
	, "client/ipls/gtav/red_carpet.lua"
	, "client/ipls/gtav/simeon.lua"
	, "client/ipls/gtav/stripclub.lua"
	, "client/ipls/gtav/trevors_trailer.lua"
	, "client/ipls/gtav/ufo.lua"
	, "client/ipls/gtav/zancudo_gates.lua"

	-- GTA Online
	, "client/ipls/gta_online/apartment_hi_1.lua"
	, "client/ipls/gta_online/apartment_hi_2.lua"
	, "client/ipls/gta_online/house_hi_1.lua"
	, "client/ipls/gta_online/house_hi_2.lua"
	, "client/ipls/gta_online/house_hi_3.lua"
	, "client/ipls/gta_online/house_hi_4.lua"
	, "client/ipls/gta_online/house_hi_5.lua"
	, "client/ipls/gta_online/house_hi_6.lua"
	, "client/ipls/gta_online/house_hi_7.lua"
	, "client/ipls/gta_online/house_hi_8.lua"
	, "client/ipls/gta_online/house_mid_1.lua"
	, "client/ipls/gta_online/house_low_1.lua"

	-- DLC High Life
	, "client/ipls/dlc_high_life/apartment1.lua"
	, "client/ipls/dlc_high_life/apartment2.lua"
	, "client/ipls/dlc_high_life/apartment3.lua"
	, "client/ipls/dlc_high_life/apartment4.lua"
	, "client/ipls/dlc_high_life/apartment5.lua"
	, "client/ipls/dlc_high_life/apartment6.lua"

	-- DLC Heists
	, "client/ipls/dlc_heists/carrier.lua"
	, "client/ipls/dlc_heists/yacht.lua"

	-- DLC Executives & Other Criminals
	, "client/ipls/dlc_executive/apartment1.lua"
	, "client/ipls/dlc_executive/apartment2.lua"
	, "client/ipls/dlc_executive/apartment3.lua"

	-- DLC Finance & Felony
	, "client/ipls/dlc_finance/office1.lua"
	, "client/ipls/dlc_finance/office2.lua"
	, "client/ipls/dlc_finance/office3.lua"
	, "client/ipls/dlc_finance/office4.lua"
	, "client/ipls/dlc_finance/organization.lua"

	-- DLC Bikers
	, "client/ipls/dlc_bikers/cocaine.lua"
	, "client/ipls/dlc_bikers/counterfeit_cash.lua"
	, "client/ipls/dlc_bikers/document_forgery.lua"
	, "client/ipls/dlc_bikers/meth.lua"
	, "client/ipls/dlc_bikers/weed.lua"
	, "client/ipls/dlc_bikers/clubhouse1.lua"
	, "client/ipls/dlc_bikers/clubhouse2.lua"
	, "client/ipls/dlc_bikers/gang.lua"

	-- DLC Import/Export
	, "client/ipls/dlc_import/garage1.lua"
	, "client/ipls/dlc_import/garage2.lua"
	, "client/ipls/dlc_import/garage3.lua"
	, "client/ipls/dlc_import/garage4.lua"
	, "client/ipls/dlc_import/vehicle_warehouse.lua"

	-- DLC Gunrunning
	, "client/ipls/dlc_gunrunning/bunkers.lua"
	, "client/ipls/dlc_gunrunning/yacht.lua"

	-- DLC Smuggler's Run
	, "client/ipls/dlc_smuggler/hangar.lua"

	-- DLC Doomsday Heist
	, "client/ipls/dlc_doomsday/facility.lua"

	-- DLC After Hours
    , "client/ipls/dlc_afterhours/nightclubs.lua",
    
	"client/modules/ingameSync/sync.lua",
	"client/modules/creator/creator.lua",
	"client/modules/npcs/*.lua",
	"client/modules/zones/*.lua",

	"client/ui/api/*.lua"


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

    "server/foxy/*.lua",

    "server/modules/ingameSync/sync.lua"
}



fx_version 'adamant'
games { 'gta5' };