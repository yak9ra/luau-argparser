--!strict

-- [ LOGIC ]
local Utils = require("../Utils")

-- [ TYPES ]
type Array<T> = {[number]:T}

-- [ FUNCTIONS ]

-- Function used to parse string into array of strings (arguments)
-- @tparam data string - String to split / parse
-- @treturn Array<string> - Array of splitted / parsed strings
-- @usage ShellSplit("Hello world") --> { "Hello", "world" }
local function ShellSplit(data: string): Array<string>
	-- Array<string>
	local Tokens = {} :: Array<string>
	local Current = {} :: Array<string>

	-- String
	local quote_char = ' '

	-- Number
	local last_quote_idx = 0

	-- Boolean
	local escaping = false
	local quoting = false

	for idx = 1, #data do
		local char = string.sub(data, idx, idx)

		if escaping then
			table.insert(Current, char)
			escaping = false

		elseif char == Utils.Constants.Strings.ESCAPE_CHARACTER and (not quoting or Utils.Functions.CharIsQuote(quote_char)) then
			escaping = true

		elseif quoting and char == quote_char then
			quoting = false
			last_quote_idx = idx

		elseif not quoting and Utils.Functions.CharIsQuote(char) then
			quoting = true
			quote_char = char

		elseif not quoting and Utils.Functions.IsWhitespace(char) then
			if #Current > 0 or last_quote_idx == (idx - 1) then
				table.insert(Tokens, table.concat(Current))

				Current = {}
			end

		else
			table.insert(Current, char)
		end
	end

	if #Current	> 0 or last_quote_idx == #data then
		table.insert(Tokens, table.concat(Current))
	end

	return Tokens
end

return {
	ShellSplit = ShellSplit,
	GetArgumentInfo = Utils.Functions.GetArgumentInfo,
	Constants = Utils.Constants
}
