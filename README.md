# DeliveryRun

Dependencies

ESX : https://github.com/esx-framework/esx_core
oxMysql : https://github.com/overextended/oxmysql
ox_lib : https://github.com/overextended/ox_lib
ox_inventory : https://github.com/overextended/ox_inventory

eng

copy and past this in ox_inventory/data/items.lua

['alcool'] = {
    label = 'Whiskey di contrabbando',
    weight = 100,
    stack = true,
    close = true,
},

copy and past the png in ox_inventory/web/images

in config.lua change the police dispatch event based on the dispatch script you use

----------------------------------------------------------------

ita

copia e incolla questo in ox_inventory/data/items.lua

['alcool'] = {
    label = 'Whiskey di contrabbando',
    weight = 100,
    stack = true,
    close = true,
},

copia e incolla la png in ox_inventory/web/images

in config.lua modifica l'evento del dispatch polizia in base allo script dispatch che utilizzi
