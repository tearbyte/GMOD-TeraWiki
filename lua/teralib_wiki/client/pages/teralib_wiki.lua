
-- TeraLib page for developers: adding pages of your addon to this wiki

TeraLibWiki.AddPage( {
	section = 'teralib',
	id = 'wiki',
	order = 90,
	audience = TeraLibWiki.AUDIENCE_DEVELOPERS,
	title = 'TeraLibWiki.Page.Wiki.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Wiki.Text1' },
		{ type = 'code', code = [[
-- client/wiki_en.lua, the same for every language
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Section', 'My addon' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Title', 'How to use' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Text1', 'Open the menu with !menu.' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Hello', 'Hello' )

-- client/wiki.lua
hook.Add( 'InitPostEntity', 'MyAddon.Wiki', function()

	if not TeraLibWiki then return end

	TeraLibWiki.AddSection( { id = 'my_addon', title = 'MyAddon.Wiki.Section', icon = 'icon16/plugin.png' } )

	TeraLibWiki.AddPage( {
		section = 'my_addon',
		id = 'usage',
		audience = TeraLibWiki.AUDIENCE_PLAYERS,
		title = 'MyAddon.Wiki.Usage.Title',
		blocks = {
			{ type = 'text', text = 'MyAddon.Wiki.Usage.Text1' },
			{ type = 'example', height = 40, code = 'TeraLib.vgui.Label( { parent = parent, dock = FILL, text = TeraLib.lang.GetPhrase( "MyAddon.Wiki.Usage.Hello" ) } )' },
		},
	} )

end )]] },
		{ type = 'heading', text = 'TeraLibWiki.Page.Wiki.Heading1' },
		{ type = 'text', text = 'TeraLibWiki.Page.Wiki.Text2' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Wiki.Heading2' },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Wiki.Column1', 'TeraLibWiki.Page.Wiki.Column2', 'TeraLibWiki.Page.Wiki.Column3' },
			rows = {
				{ 'heading', 'text', 'TeraLibWiki.Page.Wiki.Cell1' },
				{ 'text', 'text', 'TeraLibWiki.Page.Wiki.Cell2' },
				{ 'note', 'text', 'TeraLibWiki.Page.Wiki.Cell3' },
				{ 'code', 'code', 'TeraLibWiki.Page.Wiki.Cell4' },
				{ 'table', 'columns, rows', 'TeraLibWiki.Page.Wiki.Cell5' },
				{ 'example', 'code, height', 'TeraLibWiki.Page.Wiki.Cell6' },
			},
		},
		{ type = 'note', text = 'TeraLibWiki.Page.Wiki.Note1' },
		{ type = 'heading', text = 'TeraLibWiki.Page.Wiki.Heading3' },
		{ type = 'text', text = 'TeraLibWiki.Page.Wiki.Text3' },
	},
} )
