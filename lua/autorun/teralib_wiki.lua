
local ROOT = 'teralib_wiki/client/'
local WARNING_FILE = ROOT .. 'teralib_warning.lua'
local ERROR_COLOR = Color( 255, 80, 80 )

-- Load order matters: the API and the highlighting are used by the blocks, the blocks by the interface
local CLIENT_FILES = { 'lang/en.lua', 'lang/ru.lua', 'lang/uk.lua', 'api.lua', 'highlight.lua', 'blocks.lua', 'ui.lua' }
-- The TeraLib pages, other addons add theirs through TeraLibWiki.AddPage
local PAGE_FILES = { 'teralib_start.lua', 'teralib_players.lua', 'teralib_vgui.lua', 'teralib_modules.lua', 'teralib_wiki.lua' }

if SERVER then

	AddCSLuaFile( WARNING_FILE )

	for _, name in ipairs( CLIENT_FILES ) do
		AddCSLuaFile( ROOT .. name )
	end

	for _, name in ipairs( PAGE_FILES ) do
		AddCSLuaFile( ROOT .. 'pages/' .. name )
	end

	if not TeraLib then MsgC( ERROR_COLOR, '[TeraWiki] TeraLib is not installed, the addon is disabled\n' ) end
	return

end

-- TeraLib loads before every other autorun file, so if it's missing now, it's not installed
if not TeraLib then

	include( WARNING_FILE )
	return

end

TeraLib.OnReady( 'loaded', 'TeraLibWiki.Init', function()

	TeraLibWiki = TeraLibWiki or {}

	for _, name in ipairs( CLIENT_FILES ) do
		include( ROOT .. name )
	end

	for _, name in ipairs( PAGE_FILES ) do
		include( ROOT .. 'pages/' .. name )
	end

end )
