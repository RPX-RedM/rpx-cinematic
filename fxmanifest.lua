fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RPX Cinematic System'
author 'Sinatra#0101'
version '0.0.1'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

ui_page {
    'html/ui.html'
}

files {
    'html/ui.html',
    'html/bg.png',
    'html/*',
}

lua54 'yes'