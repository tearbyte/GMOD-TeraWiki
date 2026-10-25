
local PAGE_PADDING = 8
local LINE_GAP_MULTIPLIER = 1.2
local TITLE_FONT_SIZE = 30
local HEADING_FONT_SIZE = 24
local CODE_FONT_SIZE = 18
local CODE_FONT_WEIGHT = 700
-- Linux fontconfig maps it to a metric-compatible monospaced font
local CODE_FONT_NAME = 'Courier New'
local CODE_HEADER_HEIGHT = 22
local CODE_LANGUAGE = 'Lua'
local COPY_BUTTON_WIDTH = 110
local NOTE_STRIPE_WIDTH = 4
local NOTE_TEXT_INSET = 3 -- In stripe widths
local COMMENT_ALPHA = 140
local SELECTION_ALPHA = 120
local EXAMPLE_BORDER = 2
local INDENT_WIDTH = 4 -- Spaces a tab is shown with, see highlight.lua
local UTF8_CHAR = '[^\128-\191][\128-\191]*'
local UTF8_LEAD_BYTE = '[^\128-\191]'
local MIN_ROW_COLUMNS = 20
local TABLE_LINE_HEIGHT = 20
local TABLE_HEADER_HEIGHT = 22
local EXAMPLE_HEIGHT = 60
local RESET_BUTTON_WIDTH = 110
local ALIGNMENT_LEFT = 4
local EXAMPLE_SOURCE = 'TeraLibWiki example'
-- The example is a vararg chunk, its first argument is the panel to fill
local EXAMPLE_PREFIX = 'local parent = ...\n'

TeraLibWiki.FONT_CODE = 'TeraLibWiki.Code'

TeraLibWiki.blockTypes = {}

function TeraLibWiki.CreateFonts()

	TeraLibWiki.FONT_TITLE = TeraLib.vgui.GetFont( TITLE_FONT_SIZE )
	TeraLibWiki.FONT_HEADING = TeraLib.vgui.GetFont( HEADING_FONT_SIZE )

	surface.CreateFont( TeraLibWiki.FONT_CODE, { font = CODE_FONT_NAME, size = TeraLib.vgui.GetFontSize( CODE_FONT_SIZE ), weight = CODE_FONT_WEIGHT, extended = true } )

end

function TeraLibWiki.AddBlockType( name, build )
	TeraLibWiki.blockTypes[ name ] = build
end

function TeraLibWiki.InvalidateParents( panel )

	local parent = panel:GetParent()
	parent:InvalidateLayout()
	if IsValid( parent:GetParent() ) then parent:GetParent():InvalidateLayout() end

end

function TeraLibWiki.CreateTextPanel( parent, text, font, color )

	local panel = vgui.Create( 'DPanel', parent )
	panel:Dock( TOP )
	panel:DockMargin( 0, 0, 0, TeraLib.util.ScrH( PAGE_PADDING ) )
	panel:SetPaintBackground( false )
	panel.lineGap = draw.GetFontHeight( font ) * LINE_GAP_MULTIPLIER
	panel.lines = {}

	function panel:PerformLayout( w )

		local left, _, right = self:GetDockPadding()
		if self.wrappedWidth == w then return end

		self.wrappedWidth = w
		self.lines = TeraLib.util.WrapText( text, w - left - right, font )
		self:SetTall( math.ceil( #self.lines * self.lineGap ) )
		TeraLibWiki.InvalidateParents( self )

	end

	function panel:Paint()
		draw.DrawCalculatedMultilineText( self.lines, font, self:GetDockPadding(), 0, color, self.lineGap )
	end

	return panel

end

TeraLibWiki.AddBlockType( 'heading', function( parent, block )
	TeraLibWiki.CreateTextPanel( parent, TeraLib.lang.GetPhrase( block.text ), TeraLibWiki.FONT_HEADING )
end )

TeraLibWiki.AddBlockType( 'text', function( parent, block )
	TeraLibWiki.CreateTextPanel( parent, TeraLib.lang.GetPhrase( block.text ), TeraLib.vgui.DEFAULT_FONT )
end )

TeraLibWiki.AddBlockType( 'note', function( parent, block )

	local note = TeraLibWiki.CreateTextPanel( parent, TeraLib.lang.GetPhrase( block.text ), TeraLib.vgui.DEFAULT_FONT )
	local stripe = TeraLib.util.ScrW( NOTE_STRIPE_WIDTH )
	note:DockPadding( stripe * NOTE_TEXT_INSET, 0, 0, 0 )

	local paintText = note.Paint
	function note:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, stripe, h, TeraLib.vgui.appearance.accent )
		paintText( self, w, h )
	end

end )

local TOKEN_COLORS = {
	[ TeraLibWiki.TOKEN_KEYWORD ] = 'accent',
	[ TeraLibWiki.TOKEN_STRING ] = 'switchOn',
	[ TeraLibWiki.TOKEN_NUMBER ] = 'active',
}

local function restoreTabs( text )

	return ( string.gsub( text, '^ +', function( spaces )
		return string.rep( '\t', math.floor( #spaces / INDENT_WIDTH ) ) .. string.rep( ' ', #spaces % INDENT_WIDTH )
	end ) )

end

-- GMod's utf8 library counts positions differently from Lua 5.3
local function countChars( text )
	return select( 2, string.gsub( text, UTF8_LEAD_BYTE, '' ) )
end

local function byteOfColumn( text, column )

	local count = 0
	for start in string.gmatch( text, '()' .. UTF8_CHAR ) do
		if count == column then return start end
		count = count + 1
	end

	return #text + 1

end

local function subColumns( text, first, last )
	return text:sub( byteOfColumn( text, first ), last and byteOfColumn( text, last ) - 1 or #text )
end

local CODE = {}

function CODE:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	self:SetCursor( 'beam' )
	self.padding = TeraLib.util.ScrH( PAGE_PADDING )
	self.rows = {}

end

function CODE:SetCode( code )

	self.code = code
	self.lines = TeraLibWiki.Highlight( code )
	self.texts = {}
	self.lineHeight = draw.GetFontHeight( TeraLibWiki.FONT_CODE )

	surface.SetFont( TeraLibWiki.FONT_CODE )
	self.columnWidth = surface.GetTextSize( ' ' )

	for i, line in ipairs( self.lines ) do
		local parts = {}
		local column = 0
		for j, token in ipairs( line ) do
			token.column = column
			token.length = countChars( token.text )
			column = column + token.length
			parts[ j ] = token.text
		end
		self.texts[ i ] = table.concat( parts )
	end

	self.wrappedWidth = nil
	self:InvalidateLayout()

end

local function findRowEnd( chars, from, size )

	local limit = from + size
	if limit >= #chars then return #chars end

	for column = limit, from + 1, -1 do
		if chars[ column ] == ' ' then return column end
	end

	return limit

end

local function slicePieces( line, from, to, indent )

	local pieces = {}
	for _, token in ipairs( line ) do
		local first = math.max( from, token.column )
		local last = math.min( to, token.column + token.length )
		if first >= last then continue end

		pieces[ #pieces + 1 ] = {
			text = subColumns( token.text, first - token.column, last - token.column ),
			kind = token.kind,
			column = indent + first - from,
		}
	end

	return pieces

end

function CODE:wrapRows( columns )

	local rows = {}
	for i, line in ipairs( self.lines ) do
		local chars = {}
		for char in string.gmatch( self.texts[ i ], UTF8_CHAR ) do
			chars[ #chars + 1 ] = char
		end

		local indent = #string.match( self.texts[ i ], '^ *' ) + INDENT_WIDTH
		if columns - indent < MIN_ROW_COLUMNS then indent = 0 end

		local from, rowIndent = 0, 0
		repeat
			local to = findRowEnd( chars, from, columns - rowIndent )
			rows[ #rows + 1 ] = { line = i, from = from, to = to, indent = rowIndent, pieces = slicePieces( line, from, to, rowIndent ) }
			from, rowIndent = to, indent
		until from >= #chars
	end

	self.rows = rows

end

function CODE:PerformLayout( w )

	if self.wrappedWidth == w then return end
	self.wrappedWidth = w

	self:wrapRows( math.max( MIN_ROW_COLUMNS, math.floor( ( w - self.padding * 2 ) / self.columnWidth ) ) )
	self:SetTall( #self.rows * self.lineHeight + self.padding * 2 )

	local panel = self:GetParent()
	panel:SetTall( self:GetY() + self:GetTall() )
	TeraLibWiki.InvalidateParents( panel )

end

function CODE:getPosition( x, y )

	local row = self.rows[ math.Clamp( math.floor( ( y - self.padding ) / self.lineHeight ) + 1, 1, #self.rows ) ]
	local column = math.Round( ( x - self.padding ) / self.columnWidth ) - row.indent + row.from

	return { line = row.line, column = math.Clamp( column, row.from, row.to ) }

end

function CODE:getSelection()

	local first, last = self.anchor, self.caret
	if not first or ( first.line == last.line and first.column == last.column ) then return end
	if first.line > last.line or ( first.line == last.line and first.column > last.column ) then first, last = last, first end

	return first, last

end

function CODE:GetSelectedText()

	local first, last = self:getSelection()
	if not first then return end

	local parts = {}
	for line = first.line, last.line do
		local from = line == first.line and first.column or 0
		local to = line == last.line and last.column or nil
		parts[ #parts + 1 ] = restoreTabs( subColumns( self.texts[ line ], from, to ) )
	end

	return table.concat( parts, '\n' )

end

function CODE:Copy()

	SetClipboardText( self:GetSelectedText() or self.code )
	TeraLib.Notify( 'TeraLibWiki.Copied', { style = TeraLib.notify.STYLE_TERALIB } )

end

function CODE:OnMousePressed( keyCode )

	if keyCode ~= MOUSE_LEFT then return end

	self.anchor = self:getPosition( self:CursorPos() )
	self.caret = self.anchor
	self.selecting = true
	self:MouseCapture( true )
	self:RequestFocus()

end

function CODE:OnCursorMoved( x, y )

	if not self.selecting then return end
	self.caret = self:getPosition( x, y )

end

function CODE:OnMouseReleased()

	self.selecting = false
	self:MouseCapture( false )

end

function CODE:OnKeyCodePressed( keyCode )

	if keyCode ~= KEY_C or not input.IsControlDown() then return end
	self:Copy()

end

function CODE:paintSelection()

	local first, last = self:getSelection()
	if not first then return end

	surface.SetDrawColor( ColorAlpha( TeraLib.vgui.appearance.active, SELECTION_ALPHA ) )
	for i, row in ipairs( self.rows ) do
		if row.line < first.line or row.line > last.line then continue end

		local from = math.max( row.line == first.line and first.column or 0, row.from )
		local to = math.min( row.line == last.line and last.column or row.to, row.to )
		if from >= to then continue end

		local x = self.padding + ( row.indent + from - row.from ) * self.columnWidth
		surface.DrawRect( x, self.padding + ( i - 1 ) * self.lineHeight, ( to - from ) * self.columnWidth, self.lineHeight )
	end

end

function CODE:Paint( w, h )

	local app = TeraLib.vgui.appearance
	draw.RoundedBox( 0, 0, 0, w, h, app.surfaceAlt )
	self:paintSelection()

	local commentColor = ColorAlpha( app.text, COMMENT_ALPHA )
	surface.SetFont( TeraLibWiki.FONT_CODE )

	for i, row in ipairs( self.rows ) do
		local y = self.padding + ( i - 1 ) * self.lineHeight

		for _, piece in ipairs( row.pieces ) do
			local key = TOKEN_COLORS[ piece.kind ]
			surface.SetTextColor( piece.kind == TeraLibWiki.TOKEN_COMMENT and commentColor or key and app[ key ] or app.text )
			surface.SetTextPos( self.padding + piece.column * self.columnWidth, y )
			surface.DrawText( piece.text )
		end
	end

end

vgui.Register( 'TeraLibWikiCode', CODE, 'DPanel' )

function TeraLibWiki.CreateCodePanel( parent, code )

	local panel = vgui.Create( 'DPanel', parent )
	panel:Dock( TOP )
	panel:DockMargin( 0, 0, 0, TeraLib.util.ScrH( PAGE_PADDING ) )
	panel:SetPaintBackground( false )

	local header = vgui.Create( 'DPanel', panel )
	header:Dock( TOP )
	header:SetTall( TeraLib.util.ScrH( CODE_HEADER_HEIGHT ) )
	header:SetPaintBackground( false )

	local body = vgui.Create( 'TeraLibWikiCode', panel )
	body:Dock( TOP )
	body:SetCode( code )

	TeraLib.vgui.ColorableButton( {
		parent = header,
		dock = RIGHT,
		size = { x = TeraLib.util.ScrW( COPY_BUTTON_WIDTH ), y = 0 },
		text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Copy' ),
		DoClick = function() body:Copy() end,
	} )

	TeraLib.vgui.Label( { parent = header, dock = FILL, text = CODE_LANGUAGE, alignment = ALIGNMENT_LEFT } )

	return panel

end

TeraLibWiki.AddBlockType( 'code', function( parent, block )
	TeraLibWiki.CreateCodePanel( parent, block.code )
end )

TeraLibWiki.AddBlockType( 'table', function( parent, block )

	local columns = {}
	for i, column in ipairs( block.columns ) do
		columns[ i ] = TeraLib.lang.GetPhrase( column )
	end

	local lines = {}
	for i, row in ipairs( block.rows ) do
		lines[ i ] = {}
		for j, cell in ipairs( row ) do
			lines[ i ][ j ] = TeraLib.lang.GetPhrase( cell )
		end
	end

	local headerHeight = TeraLib.util.ScrH( TABLE_HEADER_HEIGHT )
	local lineHeight = TeraLib.util.ScrH( TABLE_LINE_HEIGHT )

	local listView = TeraLib.vgui.ListView( {
		parent = parent,
		dock = TOP,
		dockMargin = { 0, 0, 0, TeraLib.util.ScrH( PAGE_PADDING ) },
		headerHeight = headerHeight,
		lineHeight = lineHeight,
		columns = columns,
		lines = lines,
	} )
	listView:SetTall( headerHeight + #lines * lineHeight )

end )

local function runExample( body, code )

	body:Clear()

	local fn = CompileString( EXAMPLE_PREFIX .. code, EXAMPLE_SOURCE, false )
	local ok, err = isfunction( fn ), fn
	if ok then ok, err = pcall( fn, body ) end
	if ok then return end

	TeraLibWiki.CreateTextPanel( body, tostring( err ), TeraLib.vgui.DEFAULT_FONT, TeraLib.vgui.appearance.notifyError )

end

TeraLibWiki.AddBlockType( 'example', function( parent, block )

	local pad = TeraLib.util.ScrH( PAGE_PADDING )
	local exampleBorder = math.max( 1, math.Round( TeraLib.util.ScrH( EXAMPLE_BORDER ) ) )

	local header = vgui.Create( 'DPanel', parent )
	header:Dock( TOP )
	header:SetTall( TeraLib.util.ScrH( CODE_HEADER_HEIGHT ) )
	header:SetPaintBackground( false )

	local body = vgui.Create( 'DPanel', parent )
	body:Dock( TOP )
	body:DockMargin( 0, 0, 0, pad )
	body:DockPadding( pad, pad, pad, pad )
	body:SetTall( TeraLib.util.ScrH( block.height or EXAMPLE_HEIGHT ) )

	-- The components are drawn with surface and would merge with it
	function body:Paint( w, h )

		local app = TeraLib.vgui.appearance
		draw.RoundedBox( 0, 0, 0, w, h, app.background )
		surface.SetDrawColor( app.surface )
		surface.DrawOutlinedRect( 0, 0, w, h, exampleBorder )

	end

	TeraLib.vgui.ColorableButton( {
		parent = header,
		dock = RIGHT,
		size = { x = TeraLib.util.ScrW( RESET_BUTTON_WIDTH ), y = 0 },
		text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Reset' ),
		DoClick = function() runExample( body, block.code ) end,
	} )

	TeraLib.vgui.Label( { parent = header, dock = FILL, text = TeraLib.lang.GetPhrase( 'TeraLibWiki.Example' ), alignment = ALIGNMENT_LEFT } )

	runExample( body, block.code )
	TeraLibWiki.CreateCodePanel( parent, block.code )

end )
