resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'essentialmode'

ui_page 'gui/ui.html'

files {
	"gui/ambulancier.png",
	"gui/avocat.png",
	"gui/brasseur.png",
	"gui/bucheron.png",
	"gui/chomeur.png",
	"gui/fermier.png",
	"gui/foodtruck.png",
	'gui/job-icon.png',
	'gui/pricedown.ttf',
	"gui/gang.png",
	"gui/mecano.png",
	"gui/mineur.png",
	"gui/pecheur.png",
	"gui/policier.png",
	"gui/taxi.png",
	'gui/ui.html',
	"gui/vigneron.png",
}

client_script {
	'avocat/avocat_client.lua',
	'avocat/avocat_config.lua',
	'brasseur/brasseur_client.lua',
	'brasseur/brasseur_config.lua',
	'bucheron/bucheron_client.lua',
	'bucheron/bucheron_config.lua',
	'chomeur/chomeur_client.lua',
	'chomeur/chomeur_config.lua',
	'fermier/fermier_client.lua',
	'fermier/fermier_config.lua',
	'gui/gui.lua',
	'mecano/mecano_client.lua',
	'mecano/mecano_Menu.lua',
	'mineur/mineur_client.lua',
	'mineur/mineur_config.lua',
	'pecheur/pecheur_client.lua',
	'pecheur/pecheur_config.lua',
	'poleemploi/metiers_client.lua',
	'poleemploi/metiers_config.lua',
	'police/police_client.lua',
	'police/police_client_vehicle.lua',
	'police/police_client_veset.lua',
	'police/police_client_notif.lua',
	'police/police_Menu.lua',
	'vigneron/vigneron_client.lua',
	'vigneron/vigneron_config.lua',
}

server_script {
	'../essentialmode/config.lua',
	'avocat/avocat_server.lua',
	'brasseur/brasseur_server.lua',
	'bucheron/bucheron_server.lua',
	'chomeur/chomeur_server.lua',
	'fermier/fermier_server.lua',
	'mecano/mecano_server.lua',
	'mineur/mineur_server.lua',
	'poleemploi/metiers_server.lua',
	'pecheur/pecheur_server.lua',
	'police/police_server.lua',
    'police/police_server_notif.lua',
	'vigneron/vigneron_config.lua',
	'vigneron/vigneron_server.lua',
	-- 'brasseur/brasseur_config.lua',
}

export 'getIsInService'
