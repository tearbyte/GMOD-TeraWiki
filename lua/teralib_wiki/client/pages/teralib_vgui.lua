
local SECTION = 'teralib'
local DEVELOPERS = TeraLibWiki.AUDIENCE_DEVELOPERS

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'vgui',
	order = 20,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Vgui.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Vgui.Text1' },
		{ type = 'note', text = 'TeraLibWiki.Page.Vgui.Note1' },
		{ type = 'text', text = 'TeraLibWiki.Page.Vgui.Text2' },
		{ type = 'example', height = 50, code = [[
-- Hover any color like the components do
for _, key in ipairs( { 'button', 'active', 'switchOff', 'accent' } ) do
	local box = vgui.Create( 'DPanel', parent )
	box:Dock( LEFT )
	box:SetWide( TeraLib.util.ScrW( 90 ) )
	box:DockMargin( 0, 0, TeraLib.util.ScrW( 5 ), 0 )

	function box:Paint( w, h )
		local color = TeraLib.vgui.appearance[ key ]
		if self:IsHovered() then color = TeraLib.util.HoverColor( color ) end
		draw.RoundedBox( 0, 0, 0, w, h, color )
	end
end]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'buttons',
	order = 21,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Buttons.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Buttons.Text1' },
		{ type = 'example', height = 110, code = [[
local rowHeight = TeraLib.util.ScrH( 24 )
local margin = { 0, 0, 0, TeraLib.util.ScrH( 5 ) }

TeraLib.vgui.ColorableButton( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, dockMargin = margin,
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.PlainButton' ),
	DoClick = function() TeraLib.Notify( 'TeraLibWiki.Demo.Clicked' ) end,
} )

local selected = TeraLib.vgui.ColorableButton( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, dockMargin = margin,
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.SelectMe' ), icon = 'icon16/star.png',
} )
selected.DoClick = function( self ) self.select = not self.select end

TeraLib.vgui.ColorableButton( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight },
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Animated' ), fractionOnHover = true,
} )]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'switches',
	order = 22,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Switches.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Switches.Text1' },
		{ type = 'example', height = 70, code = [[
local label = TeraLib.vgui.Label( { parent = parent, dock = TOP, size = { x = 0, y = TeraLib.util.ScrH( 24 ) }, text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Off' ) } )

-- A row of a fixed height: a switch docked to LEFT takes the height of its parent
local row = vgui.Create( 'DPanel', parent )
row:Dock( TOP )
row:SetTall( TeraLib.util.ScrH( 22 ) )
row:SetPaintBackground( false )

for switchType = 1, 6 do
	TeraLib.vgui.Switch( {
		parent = row,
		dock = LEFT,
		dockMargin = { 0, 0, TeraLib.util.ScrW( 16 ), 0 },
		type = switchType,
		height = TeraLib.util.ScrH( 22 ),
		OnToggle = function( _, active ) label:SetText( TeraLib.lang.Format( { 'TeraLibWiki.Demo.SwitchType', switchType, { active and 'TeraLibWiki.Demo.On' or 'TeraLibWiki.Demo.Off' } } ) ) end,
	} )
end]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'sliders',
	order = 23,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Sliders.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Sliders.Text1' },
		{ type = 'example', height = 120, code = [[
local rowHeight = TeraLib.util.ScrH( 24 )

local exact = TeraLib.vgui.Label( { parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, text = TeraLib.lang.Format( { 'TeraLibWiki.Demo.Skin', 1 } ) } )
TeraLib.vgui.Slider( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight },
	values = { 0, 1, 3 },
	value = 1,
	OnChange = function( _, value ) exact:SetText( TeraLib.lang.Format( { 'TeraLibWiki.Demo.Skin', value } ) ) end,
} )

local smooth = TeraLib.vgui.Label( { parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, text = TeraLib.lang.Format( { 'TeraLibWiki.Demo.Volume', 0.5 } ) } )
TeraLib.vgui.Slider( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight },
	min = 0, max = 1, decimals = 2,
	value = 0.5,
	OnChange = function( _, value ) smooth:SetText( TeraLib.lang.Format( { 'TeraLibWiki.Demo.Volume', value } ) ) end,
} )]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'inputs',
	order = 24,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Inputs.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Inputs.Text1' },
		{ type = 'example', height = 100, code = [[
local rowHeight = TeraLib.util.ScrH( 24 )
local margin = { 0, 0, 0, TeraLib.util.ScrH( 5 ) }

local label = TeraLib.vgui.Label( { parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.TypeAndChoose' ) } )

TeraLib.vgui.TextEntry( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight }, dockMargin = margin,
	placeholder = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.YourName' ),
	OnUpdate = function( _, value ) label:SetText( TeraLib.lang.Format( { 'TeraLibWiki.Demo.Hello', value } ) ) end,
} )

TeraLib.vgui.ComboBox( {
	parent = parent, dock = TOP, size = { x = 0, y = rowHeight },
	options = {
		{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Red' ), data = 1 },
		{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Green' ), data = 2 },
		{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Blue' ), data = 3 },
	},
	OnSelect = function( _, _, name ) label:SetText( TeraLib.lang.Format( { 'TeraLibWiki.Demo.Chosen', name } ) ) end,
} )]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'lists',
	order = 25,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Lists.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Lists.Text1' },
		{ type = 'example', height = 130, code = [[
TeraLib.vgui.ListView( {
	parent = parent,
	dock = FILL,
	columns = { TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Name' ), TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Score' ) },
	lines = {
		{ TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Alice' ), 12 },
		{ TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Bob' ), 7 },
		{ TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.Charlie' ), 3 },
	},
	OnRowSelected = function( _, _, line ) TeraLib.Notify( line:GetColumnText( 1 ) ) end,
} )]] },
		{ type = 'text', text = 'TeraLibWiki.Page.Lists.Text2' },
		{ type = 'example', height = 180, code = [[
local scroll = TeraLib.vgui.ScrollPanel( { parent = parent, dock = FILL } )

for i = 1, 3 do
	local category = TeraLib.vgui.Category( { parent = scroll, dock = TOP, text = TeraLib.lang.Format( { 'TeraLibWiki.Demo.Category', i } ), expanded = i == 1 } )
	scroll:AddItem( category )

	for j = 1, 3 do
		TeraLib.vgui.ColorableButton( {
			parent = category:GetContents(),
			dock = TOP,
			size = { x = 0, y = TeraLib.util.ScrH( 22 ) },
			dockMargin = { 0, 0, 0, TeraLib.util.ScrH( 2 ) },
			text = TeraLib.lang.Format( { 'TeraLibWiki.Demo.Item', j } ),
		} )
	end
end]] },
	},
} )

TeraLibWiki.AddPage( {
	section = SECTION,
	id = 'windows',
	order = 26,
	audience = DEVELOPERS,
	title = 'TeraLibWiki.Page.Windows.Title',
	blocks = {
		{ type = 'text', text = 'TeraLibWiki.Page.Windows.Text1' },
		{ type = 'example', height = 40, code = [[
TeraLib.vgui.ColorableButton( {
	parent = parent,
	dock = TOP,
	size = { x = 0, y = TeraLib.util.ScrH( 24 ) },
	text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.OpenWindow' ),
	DoClick = function()
		local workspace = TeraLib.vgui.Window( {
			text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.ExampleWindow' ),
			size = { x = TeraLib.util.ScrW( 400 ), y = TeraLib.util.ScrH( 200 ) },
			center = true,
		} )
		TeraLib.vgui.Label( { parent = workspace, dock = FILL, text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Demo.OneOff' ), alignment = 5 } )

		-- A one-off window: closing removes it instead of hiding
		workspace.Hide = function()
			table.RemoveByValue( TeraLib.vgui.windows, workspace:GetParent() )
			workspace:Remove()
		end

		workspace:Show()
	end,
} )]] },
		{ type = 'heading', text = 'TeraLibWiki.Page.Windows.Heading1' },
		{ type = 'text', text = 'TeraLibWiki.Page.Windows.Text2' },
		{ type = 'code', code = [[
local menuSettings

TeraLib.OnReady( 'vgui', 'MyAddon.Menu', function()

	if menuSettings == TeraLib.vgui.settings then return end

	menuSettings = TeraLib.vgui.settings
	TeraLib.vgui.settings:AddCategory( 'My addon', MyAddon.BuildMenu(), 'icon16/cog.png' )

end )]] },
	},
} )
