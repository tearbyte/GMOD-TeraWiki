
-- TeraLib pages for players: the settings window and the appearance

local SECTION = 'teralib'

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'settings',
	order = 10,
	audience = TeraLibWiki.AUDIENCE_PLAYERS,
	title = 'TeraLibWiki.Page.Settings.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Settings.Text1' },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Settings.Column1', 'TeraLibWiki.Page.Settings.Column2' },
			rows = {
				{ 'teralib_settings', 'TeraLibWiki.Page.Settings.Cell1' },
				{ 'teralib_wiki', 'TeraLibWiki.Page.Settings.Cell2' },
				{ 'teralib_reload_gui', 'TeraLibWiki.Page.Settings.Cell3' },
			},
		},
		{ type = 'note', text = 'TeraLibWiki.Page.Settings.Note1' },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'appearance',
	order = 11,
	audience = TeraLibWiki.AUDIENCE_PLAYERS,
	title = 'TeraLibWiki.Page.Appearance.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Appearance.Text1' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Appearance.Heading1' },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Appearance.Column1', 'TeraLibWiki.Page.Appearance.Column2' },
			rows = {
				{ 'TeraLibWiki.Page.Appearance.Cell1', 'TeraLibWiki.Page.Appearance.Cell2' },
				{ 'TeraLibWiki.Page.Appearance.Cell3', 'TeraLibWiki.Page.Appearance.Cell4' },
				{ 'TeraLibWiki.Page.Appearance.Cell5', 'TeraLibWiki.Page.Appearance.Cell6' },
				{ 'TeraLibWiki.Page.Appearance.Cell7', 'TeraLibWiki.Page.Appearance.Cell8' },
				{ 'TeraLibWiki.Page.Appearance.Cell9', 'TeraLibWiki.Page.Appearance.Cell10' },
			},
		},
		{ type = 'note', text = 'TeraLibWiki.Page.Appearance.Note1' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Appearance.Heading2' },
		{ type = 'text', text = 'TeraLibWiki.Page.Appearance.Text2' },
		{ type = 'example', height = 40, code = [[
TeraLib.vgui.ColorableButton( {
	parent = parent,
	dock = TOP,
	size = { x = 0, y = TeraLib.util.ScrH( 24 ) },
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.ShowNotification' ),
	DoClick = function()
		TeraLib.Notify( 'TeraLibWiki.Demo.Greeting', { style = TeraLib.notify.STYLE_TERALIB, type = TeraLib.notify.TYPE_HINT } )
	end,
} )]] },
	},
} )
