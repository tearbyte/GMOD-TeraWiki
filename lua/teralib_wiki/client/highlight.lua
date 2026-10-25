
local TAB_SPACES = '    '
local LONG_OPEN = '[['
local LONG_CLOSE = ']]'
local LONG_OPEN_LENGTH = #LONG_OPEN
local LONG_CLOSE_LENGTH = #LONG_CLOSE
local COMMENT_START = '--'
local COMMENT_START_LENGTH = #COMMENT_START

TeraLibWiki.TOKEN_TEXT = 1
TeraLibWiki.TOKEN_KEYWORD = 2
TeraLibWiki.TOKEN_STRING = 3
TeraLibWiki.TOKEN_NUMBER = 4
TeraLibWiki.TOKEN_COMMENT = 5

local KEYWORDS = {}
for _, word in ipairs( {
	'and', 'break', 'continue', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'goto', 'if', 'in',
	'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while',
} ) do
	KEYWORDS[ word ] = true
end

local function readToken( line, pos )

	if line:sub( pos, pos + COMMENT_START_LENGTH - 1 ) == COMMENT_START then
		if line:sub( pos + COMMENT_START_LENGTH, pos + COMMENT_START_LENGTH + LONG_OPEN_LENGTH - 1 ) == LONG_OPEN then
			local close = line:find( LONG_CLOSE, pos, true )
			if not close then return line:sub( pos ), TeraLibWiki.TOKEN_COMMENT, true end
			return line:sub( pos, close + LONG_CLOSE_LENGTH - 1 ), TeraLibWiki.TOKEN_COMMENT, false
		end

		return line:sub( pos ), TeraLibWiki.TOKEN_COMMENT, false
	end

	if line:sub( pos, pos + LONG_OPEN_LENGTH - 1 ) == LONG_OPEN then
		local close = line:find( LONG_CLOSE, pos + LONG_OPEN_LENGTH, true )
		if not close then return line:sub( pos ), TeraLibWiki.TOKEN_STRING, true end
		return line:sub( pos, close + LONG_CLOSE_LENGTH - 1 ), TeraLibWiki.TOKEN_STRING, false
	end

	local char = line:sub( pos, pos )
	if char == '\'' or char == '"' then
		local close = pos
		repeat
			close = line:find( char, close + 1, true )
		until not close or line:sub( close - 1, close - 1 ) ~= '\\'
		return line:sub( pos, close or #line ), TeraLibWiki.TOKEN_STRING, false
	end

	local number = line:match( '^%d+%.?%d*', pos )
	if number then return number, TeraLibWiki.TOKEN_NUMBER, false end

	local word = line:match( '^[%a_][%w_]*', pos )
	if word then return word, KEYWORDS[ word ] and TeraLibWiki.TOKEN_KEYWORD or TeraLibWiki.TOKEN_TEXT, false end

	return line:match( '^[^%w_\'"%-%[]+', pos ) or char, TeraLibWiki.TOKEN_TEXT, false

end

function TeraLibWiki.Highlight( code )

	local lines = {}
	local openKind

	for _, line in ipairs( string.Explode( '\n', string.Replace( code, '\t', TAB_SPACES ) ) ) do
		local tokens = {}
		local pos = 1

		if openKind then
			local close = line:find( LONG_CLOSE, 1, true )
			local text = close and line:sub( 1, close + LONG_CLOSE_LENGTH - 1 ) or line
			tokens[ 1 ] = { text = text, kind = openKind }
			pos = #text + 1
			if close then openKind = nil end
		end

		while pos <= #line do
			local text, kind, isOpen = readToken( line, pos )
			local last = tokens[ #tokens ]

			if last and last.kind == kind then
				last.text = last.text .. text
			else
				tokens[ #tokens + 1 ] = { text = text, kind = kind }
			end

			if isOpen then openKind = kind end
			pos = pos + #text
		end

		lines[ #lines + 1 ] = tokens
	end

	return lines

end
