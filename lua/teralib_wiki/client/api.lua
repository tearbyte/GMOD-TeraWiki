
local DEFAULT_ORDER = 100

TeraLibWiki.AUDIENCE_PLAYERS = 1
TeraLibWiki.AUDIENCE_DEVELOPERS = 2

TeraLibWiki.sections = {}
TeraLibWiki.changed = false

function TeraLibWiki.AddSection( data )

	local section = TeraLibWiki.sections[ data.id ] or { pages = {} }
	section.id = data.id
	section.title = data.title
	section.icon = data.icon
	section.order = data.order or DEFAULT_ORDER

	TeraLibWiki.sections[ data.id ] = section
	TeraLibWiki.changed = true

end

function TeraLibWiki.AddPage( data )

	data.order = data.order or DEFAULT_ORDER
	TeraLibWiki.sections[ data.section ].pages[ data.id ] = data
	TeraLibWiki.changed = true

end

function TeraLibWiki.GetSections()

	local sections = table.ClearKeys( TeraLibWiki.sections )
	table.sort( sections, function( a, b )
		if a.order ~= b.order then return a.order < b.order end
		return TeraLib.lang.GetPhrase( a.title ) < TeraLib.lang.GetPhrase( b.title )
	end )

	return sections

end

function TeraLibWiki.GetPages( section )

	local pages = table.ClearKeys( section.pages )
	table.sort( pages, function( a, b )
		if a.order ~= b.order then return a.order < b.order end
		return TeraLib.lang.GetPhrase( a.title ) < TeraLib.lang.GetPhrase( b.title )
	end )

	return pages

end
