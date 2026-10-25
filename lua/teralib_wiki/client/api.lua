
--[[
	Registry of the wiki sections and pages. Other addons register theirs any time after the wiki is loaded:
	the navigation is rebuilt when the registry changes, so the load order of the addons doesn't matter.

		hook.Add( 'InitPostEntity', 'MyAddon.Wiki', function()
			if not TeraLibWiki then return end
			TeraLibWiki.AddSection( { id = 'my_addon', title = 'MyAddon.Wiki.Section' } )
			TeraLibWiki.AddPage( { section = 'my_addon', id = 'intro', title = 'MyAddon.Wiki.Intro.Title', blocks = { ... } } )
		end )

	Every text of a section, a page or a block is a TeraLib.lang phrase key, registered with TeraLib.lang.Add.
	A string that isn't a key is shown as is.
]]--

local DEFAULT_ORDER = 100

TeraLibWiki.AUDIENCE_PLAYERS = 1
TeraLibWiki.AUDIENCE_DEVELOPERS = 2

TeraLibWiki.sections = {}
-- Set when the registry changes, the open wiki rebuilds its navigation
TeraLibWiki.changed = false

--[[
	Add a section or replace the one with the same id. Its pages are kept.
	@param data table
		- id: string - unique section id, prefix it with your addon name
		- title: string - TeraLib.lang phrase key
		- icon: string|nil - icon path, like 'icon16/book.png'
		- order: number|nil - sections are sorted by it, then by title, 100 by default
]]--
function TeraLibWiki.AddSection( data )

	local section = TeraLibWiki.sections[ data.id ] or { pages = {} }
	section.id = data.id
	section.title = data.title
	section.icon = data.icon
	section.order = data.order or DEFAULT_ORDER

	TeraLibWiki.sections[ data.id ] = section
	TeraLibWiki.changed = true

end

--[[
	Add a page to a section or replace the one with the same id. The section must be added before.
	@param data table
		- section: string - section id
		- id: string - page id, unique within the section
		- title: string - TeraLib.lang phrase key
		- audience: number|nil - TeraLibWiki.AUDIENCE_*, for everyone if nil
		- order: number|nil - pages are sorted by it, then by title, 100 by default
		- blocks: table - array of blocks, see TeraLibWiki.AddBlockType and the built-in types in blocks.lua
]]--
function TeraLibWiki.AddPage( data )

	data.order = data.order or DEFAULT_ORDER
	TeraLibWiki.sections[ data.section ].pages[ data.id ] = data
	TeraLibWiki.changed = true

end

-- Sections sorted by order, then by title
function TeraLibWiki.GetSections()

	local sections = table.ClearKeys( TeraLibWiki.sections )
	table.sort( sections, function( a, b )
		if a.order ~= b.order then return a.order < b.order end
		return TeraLib.lang.GetPhrase( a.title ) < TeraLib.lang.GetPhrase( b.title )
	end )

	return sections

end

-- Pages of a section sorted by order, then by title
function TeraLibWiki.GetPages( section )

	local pages = table.ClearKeys( section.pages )
	table.sort( pages, function( a, b )
		if a.order ~= b.order then return a.order < b.order end
		return TeraLib.lang.GetPhrase( a.title ) < TeraLib.lang.GetPhrase( b.title )
	end )

	return pages

end
