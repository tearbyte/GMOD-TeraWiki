
local SECTION = 'teralib'

TeraLibWiki.AddSection( {
	id = SECTION,
	title = 'TeraLib',
	icon = 'icon16/plugin.png',
	order = 1,
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'start',
	order = 1,
	audience = TeraLibWiki.AUDIENCE_DEVELOPERS,
	title = 'TeraLibWiki.Page.Start.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Start.Text1' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Start.Heading1' },
		{ type = 'text', text = 'TeraLibWiki.Page.Start.Text2' },
		{ type = 'code', code = [[
local ROOT = 'my_addon/'
local CLIENT_FILES = { 'client/menu.lua' }
local SERVER_FILES = { 'server/data.lua' }

if SERVER then

	for _, name in ipairs( CLIENT_FILES ) do
		AddCSLuaFile( ROOT .. name )
	end

end

-- TeraLib loads before every other autorun file
if not TeraLib then return end

TeraLib.OnReady( 'loaded', 'MyAddon.Init', function()

	for _, name in ipairs( SERVER and SERVER_FILES or CLIENT_FILES ) do
		include( ROOT .. name )
	end

end )]] },
		{ type = 'heading', text = 'TeraLibWiki.Page.Start.Heading2' },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Start.Column1', 'TeraLibWiki.Page.Start.Column2' },
			rows = {
				{ 'loaded', 'TeraLibWiki.Page.Start.Cell1' },
				{ 'lang', 'TeraLibWiki.Page.Start.Cell2' },
				{ 'db', 'TeraLibWiki.Page.Start.Cell3' },
				{ 'util', 'TeraLibWiki.Page.Start.Cell4' },
				{ 'vgui', 'TeraLibWiki.Page.Start.Cell5' },
			},
		},
		{ type = 'note', text = 'TeraLibWiki.Page.Start.Note1' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Start.Heading3' },
		{ type = 'text', text = 'TeraLibWiki.Page.Start.Text3' },
	},
} )
