files {
    'index.html',
    'style.css',
    '*.jpg',
    '*.png',
    'music.mp3',
}

loadscreen 'index.html'

resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

loadscreen_manual_shutdown "yes"
-- Client Script
client_scripts {
    '@rFramework/client/cortana/check.lua',
    "client.lua"
}
