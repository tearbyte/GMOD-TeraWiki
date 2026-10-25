
-- The wiki page of the TeraLib settings: navigation by sections on the left, the open page on the right

local PAGE_PADDING = 8
local ROW_HEIGHT = 24
local NAV_WIDTH = 280
local ALIGNMENT_LEFT = 4
local AUDIENCE_ALL = 0
local CATEGORY_ICON = 'icon16/book.png'
local OPEN_COMMAND = 'teralib_wiki'

local AUDIENCE_ICONS = {
	[ TeraLibWiki.AUDIENCE_PLAYERS ] = 'icon16/user.png',
	[ TeraLibWiki.AUDIENCE_DEVELOPERS ] = 'icon16/script.png',
}

local menuSettings, navScroll, pageScroll
-- Scaled sizes, recalculated on every build: the GUI is rebuilt on resolution change
local pad, rowHeight
local audienceFilter = AUDIENCE_ALL
local searchFilter = ''
local currentPage
-- Collapsed sections by id, remembered while the game runs
local collapsed = {}
local pageButtons = {}

local function isPageVisible( page )

	-- Pages without an audience are for everyone
	if audienceFilter ~= AUDIENCE_ALL and page.audience and page.audience ~= audienceFilter then return false end
	return searchFilter == '' or string.find( string.lower( TeraLib.lang.GetPhrase( page.title ) ), searchFilter, 1, true ) ~= nil

end

local function openPage( page )

	if IsValid( pageButtons[ currentPage ] ) then pageButtons[ currentPage ].select = false end
	currentPage = page
	if IsValid( pageButtons[ page ] ) then pageButtons[ page ].select = true end

	pageScroll:Clear()
	TeraLibWiki.CreateTextPanel( pageScroll, TeraLib.lang.GetPhrase( page.title ), TeraLibWiki.FONT_TITLE )

	for _, block in ipairs( page.blocks ) do
		-- A block type of a newer wiki version is skipped
		local build = TeraLibWiki.blockTypes[ block.type ]
		if build then build( pageScroll, block ) end
	end

	pageScroll:GetVBar():SetScroll( 0 )

end

local function fillNav()

	navScroll:Clear()
	pageButtons = {}

	for _, section in ipairs( TeraLibWiki.GetSections() ) do
		local pages = {}
		for _, page in ipairs( TeraLibWiki.GetPages( section ) ) do
			if not isPageVisible( page ) then continue end
			pages[ #pages + 1 ] = page
		end

		if #pages == 0 then continue end

		local category = TeraLib.vgui.Category( {
			parent = navScroll,
			dock = TOP,
			dockMargin = { 0, 0, 0, pad },
			headerHeight = rowHeight,
			text = TeraLib.lang.GetPhrase( section.title ),
			icon = section.icon,
			-- A search shows every found page
			expanded = searchFilter ~= '' or not collapsed[ section.id ],
			OnToggle = function( _, expanded ) collapsed[ section.id ] = not expanded or nil end,
		} )
		navScroll:AddItem( category )

		for _, page in ipairs( pages ) do
			local button = TeraLib.vgui.ColorableButton( {
				parent = category:GetContents(),
				dock = TOP,
				size = { x = 0, y = rowHeight },
				dockMargin = { pad, pad, 0, 0 },
				text = TeraLib.lang.GetPhrase( page.title ),
				alignment = ALIGNMENT_LEFT,
				icon = AUDIENCE_ICONS[ page.audience ],
				DoClick = function() openPage( page ) end,
			} )
			button.select = page == currentPage
			pageButtons[ page ] = button
		end
	end

end

-- The first page of the first section, for the first open
local function getFirstPage()

	for _, section in ipairs( TeraLibWiki.GetSections() ) do
		local page = TeraLibWiki.GetPages( section )[ 1 ]
		if page then return page end
	end

end

local function buildWiki()

	pad = TeraLib.util.ScrH( PAGE_PADDING )
	rowHeight = TeraLib.util.ScrH( ROW_HEIGHT )
	TeraLibWiki.CreateFonts()

	local panel = vgui.Create( 'DPanel' )
	panel:SetPaintBackground( false )
	panel:DockPadding( pad, pad, pad, pad )

	local nav = vgui.Create( 'DPanel', panel )
	nav:Dock( LEFT )
	nav:SetWide( TeraLib.util.ScrW( NAV_WIDTH ) )
	nav:SetPaintBackground( false )

	local audience = TeraLib.vgui.ComboBox( {
		parent = nav,
		dock = TOP,
		size = { x = 0, y = rowHeight },
		dockMargin = { 0, 0, 0, pad },
		sort = false,
		options = {
			{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.AudienceAll' ), data = AUDIENCE_ALL },
			{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.AudiencePlayers' ), data = TeraLibWiki.AUDIENCE_PLAYERS },
			{ name = TeraLib.lang.GetPhrase( 'TeraLibWiki.AudienceDevelopers' ), data = TeraLibWiki.AUDIENCE_DEVELOPERS },
		},
	} )
	-- Option ids follow the audience values
	audience:ChooseOptionID( audienceFilter + 1 )

	TeraLib.vgui.TextEntry( {
		parent = nav,
		dock = TOP,
		size = { x = 0, y = rowHeight },
		dockMargin = { 0, 0, 0, pad },
		text = searchFilter,
		placeholder = TeraLib.lang.GetPhrase( 'TeraLibWiki.Search' ),
		OnUpdate = function( _, value )
			searchFilter = string.lower( value )
			fillNav()
		end,
	} )

	navScroll = TeraLib.vgui.ScrollPanel( { parent = nav, dock = FILL } )

	pageScroll = TeraLib.vgui.ScrollPanel( { parent = panel, dock = FILL } )
	-- Not through data: dockMargin of TeraLibScrollPanel reserves a right margin for the scrollbar, which is inside it anyway
	pageScroll:DockMargin( pad, 0, 0, 0 )

	-- Set after choosing the current filter and creating the navigation
	audience.OnSelect = function( _, _, _, value )
		audienceFilter = value
		fillNav()
	end

	fillNav()
	local page = currentPage or getFirstPage()
	if page then openPage( page ) end

	-- Other addons register pages any time
	function panel:Think()

		if not TeraLibWiki.changed then return end

		TeraLibWiki.changed = false
		fillNav()
		if not currentPage then
			local first = getFirstPage()
			if first then openPage( first ) end
		end

	end

	return panel

end

local function addCategory()

	if menuSettings == TeraLib.vgui.settings then return end

	menuSettings = TeraLib.vgui.settings
	TeraLib.vgui.settings:AddCategory( TeraLib.lang.GetPhrase( 'TeraLibWiki.Title' ), buildWiki(), CATEGORY_ICON )

end

TeraLib.OnReady( 'vgui', 'TeraLibWiki.Category', addCategory )

--[[
	Open the wiki in the TeraLib settings, on a page if given.
	@param sectionId string|nil
	@param pageId string|nil
]]--
function TeraLibWiki.Open( sectionId, pageId )

	local section = sectionId and TeraLibWiki.sections[ sectionId ]
	local page = section and section.pages[ pageId ]
	if page and IsValid( pageScroll ) then openPage( page ) end

	TeraLib.vgui.ShowSettings( TeraLib.lang.GetPhrase( 'TeraLibWiki.Title' ) )

end

concommand.Add( OPEN_COMMAND, function() TeraLibWiki.Open() end )
