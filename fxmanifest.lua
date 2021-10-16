fx_version 'cerulean'
game 'gta5'

description 'QB-Skillbar'
version '1.1.0'

ui_page "html/index.html"

shared_script '@qb-core/import.lua'
client_script 'client/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
}

exports {
    'StartSkillbar'
}

dependencies {
    'qb-core'
}
