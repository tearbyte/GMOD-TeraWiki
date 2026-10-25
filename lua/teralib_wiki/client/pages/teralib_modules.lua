
-- TeraLib pages for developers: localization, notifications, database, network, logger

local SECTION = 'teralib'
local DEVELOPERS = TeraLibWiki.AUDIENCE_DEVELOPERS

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'lang',
	order = 30,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Lang.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Lang.Text1' },
		{ type = 'code', code = [[
TeraLib.lang.Add( 'en', 'MyAddon.Killed', '{killer} killed {1}' )
TeraLib.lang.Add( 'ru', 'MyAddon.Killed', '{killer} убил {1}' )

TeraLib.lang.GetPhrase( 'MyAddon.Killed' ) -- the current language
TeraLib.lang.GetPhrase( 'MyAddon.Killed', ply ) -- server: the language of the player]] },
		{ type = 'text', text = 'TeraLibWiki.Page.Lang.Text2' },
		{ type = 'example', height = 40, code = [[
TeraLib.vgui.Label( {
	parent = parent,
	dock = FILL,
	text = TeraLib.lang.Format( { 'TeraLibWiki.Demo.Killed', { 'TeraLibWiki.Demo.Charlie' }, { 'TeraLibWiki.Demo.Crowbar' }, killer = { 'TeraLibWiki.Demo.Bob' } } ),
} )]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'notify',
	order = 31,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Notify.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Notify.Text1' },
		{ type = 'example', height = 110, code = [[
local rowHeight = TeraLib.util.ScrH( 24 )
local margin = { 0, 0, 0, TeraLib.util.ScrH( 5 ) }

local function button( text, onClick )
	TeraLib.vgui.ColorableButton( { parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, dockMargin = margin, text = text, DoClick = onClick } )
end

button( TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.StockStyle' ), function() TeraLib.Notify( 'TeraLibWiki.Demo.StockNotify' ) end )

button( TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.TeraLibStyle' ), function()
	TeraLib.Notify( 'TeraLibWiki.Demo.TeraLibNotify', { style = TeraLib.notify.STYLE_TERALIB, type = TeraLib.notify.TYPE_HINT } )
end )

button( TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Progress' ), function()
	local id = 'TeraLibWiki.Progress'
	for step = 0, 10 do
		timer.Simple( step * 0.3, function()
			TeraLib.Notify( { 'TeraLibWiki.Demo.Loading', step * 10 }, { style = TeraLib.notify.STYLE_TERALIB, progress = id, fraction = step / 10 } )
		end )
	end
	timer.Simple( 4, function() TeraLib.notify.Kill( id ) end )
end )]] },
		{ type = 'code', code = [[
-- server: only admins, in their own languages
TeraLib.Notify( function( ply ) return ply:IsAdmin() end, { 'MyAddon.Report', reporter:Nick() }, { type = TeraLib.notify.TYPE_HINT } )]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'db',
	order = 32,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Db.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Db.Text1' },
		{ type = 'code', code = [[
hook.Add( 'InitPostEntity', 'MyAddon.LoadData', function()

	local db = TeraLib.db:GetDefaultDB()
	db:MakeTable( 'my_addon_players', {
		{ name = 'steamid', type = 'VARCHAR', len = 32, primarykey = true },
		{ name = 'money', type = 'BIGINT', default = 0 },
	}, true )

	db:Query( 'SELECT steamid, money FROM my_addon_players', nil, function( results, err )
		if err then return end
		for _, row in ipairs( results ) do
			MyAddon.money[ row.steamid ] = tonumber( row.money )
		end
	end )

end )]] },
		{ type = 'heading', text = 'TeraLibWiki.Page.Db.Heading1' },
		{ type = 'text', text = 'TeraLibWiki.Page.Db.Text2' },
		{ type = 'note', text = 'TeraLibWiki.Page.Db.Note1' },
		{ type = 'code', code = [[
-- lua/autorun/server/my_server_db.lua
TeraLib.OnReady( 'db', 'MyServer.DefaultDB', function()

	local db = TeraLib.db:New( { host = '127.0.0.1', user = 'gmod', pass = 'secret', database = 'gmod', port = 3306 } )
	db:Connect()
	TeraLib.db:RegisterDefaultDB( db )

end )]] },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Db.Column1', 'TeraLibWiki.Page.Db.Column2' },
			rows = {
				{ 'TeraLibWiki.Page.Db.Cell1', 'TeraLibWiki.Page.Db.Cell2' },
				{ 'TeraLibWiki.Page.Db.Cell3', 'TeraLibWiki.Page.Db.Cell4' },
				{ 'TeraLibWiki.Page.Db.Cell5', 'TeraLibWiki.Page.Db.Cell6' },
				{ 'TeraLibWiki.Page.Db.Cell7', 'TeraLibWiki.Page.Db.Cell8' },
			},
		},
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'net',
	order = 33,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Net.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Net.Text1' },
		{ type = 'code', code = [[
hook.Add( 'TeraLib.PlayerFullyInitialized', 'MyAddon.SendData', function( ply )
	net.Start( 'MyAddon.Data' )
	net.WriteUInt( MyAddon.kills, 16 )
	TeraLib.net.SendTo( ply )
end )

net.Start( 'MyAddon.Report' )
net.WriteString( text )
TeraLib.net.SendTo( function( ply ) return ply:IsAdmin() end )]] },
		{ type = 'note', text = 'TeraLibWiki.Page.Net.Note1' },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'logger',
	order = 34,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Logger.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Logger.Text1' },
		{ type = 'example', height = 40, code = [[
TeraLib.vgui.ColorableButton( {
	parent = parent,
	dock = TOP,
	size = { x = 0, y = TeraLib.util.ScrH( 24 ) },
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.LogConsole' ),
	DoClick = function()
		-- The message is a string.format string, so a phrase with %d works too
		TeraLib.logger:Info( 'MyAddon', TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.LoadedItems' ), 42 )
		TeraLib.logger:Warn( 'MyAddon', TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.LooksOdd' ) )
	end,
} )]] },
		{ type = 'table',
			columns = { 'TeraLibWiki.Page.Logger.Column1', 'TeraLibWiki.Page.Logger.Column2' },
			rows = {
				{ 'Debug', 'TeraLibWiki.Page.Logger.Cell1' },
				{ 'Info', 'TeraLibWiki.Page.Logger.Cell2' },
				{ 'Warn', 'TeraLibWiki.Page.Logger.Cell3' },
				{ 'Error', 'TeraLibWiki.Page.Logger.Cell4' },
				{ 'Fatal', 'TeraLibWiki.Page.Logger.Cell5' },
			},
		},
	},
} )
