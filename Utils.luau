--!strict

-- [ TYPES ]
export type Argument = {
	Name: string, -- Name of argument
	Type: string, -- Type of argument (long, short, normal)
	Value: string?, -- Value of argument
}

-- [ VARIABLES ]
local Constants = {
	ArgumentType = {
		ARGUMENT_TYPE_LONG = "--",
		ARGUMENT_TYPE_SHORT = "-",
		ARGUMENT_TYPE_NORMAL = "",
	},
	-- Strings used for parsing arguments
	Strings = {
		ESCAPE_CHARACTER = "\\",
		FLAG_VALUE_SEPARATOR = "=",
		OPTION_VALUE_SEPARATOR = " ",
		SINGLE_QUOTE_OPEN = "'",
		DOUBLE_QUOTE_OPEN = '"',
	},
	-- Strings used for validating type of characters
	Patterns = {
		WHITESPACE_PATTERN = "[%s]+",
		OPTION_VALUED_PATTERN = "(%S+)=(%S+)",
	}
	-- Patterns are used for validating strings
}
local Functions = {}

-- [ Functions ] 

-- Function used to check if a character is a whitespace
-- @tparam char string - Character to check
-- @treturn boolean - Boolean value indicating if the character is a whitespace
function Functions.IsWhitespace(char: string): boolean
	return string.match(char, Constants.Patterns.WHITESPACE_PATTERN) ~= nil
end

-- Function used to check if character is either single or double quote
-- @tparam char string - Character to check
-- @treturn boolean - Boolean value indicating if the character is a quote
function Functions.CharIsQuote(char: string): boolean
	return (char == Constants.Strings.SINGLE_QUOTE_OPEN) or (char == Constants.Strings.DOUBLE_QUOTE_OPEN)
end

-- Function used to get information about an argument (table)
-- @tparam argument string - Argument to get information about
-- @treturn Argument - Table containing information about argument
-- @usage GetArgumentInfo("--foo=bar") --> { Name = "foo", Type = "--", Value = "bar" }
function Functions.GetArgumentInfo(argument: string): Argument	
	local ArgumentInfo = {
		Name = "",
		Type = "",
		Value = nil,	
	} :: Argument
	
	-- Check if argument type is long
	if string.sub(argument, 1, 2) == Constants.ArgumentType.ARGUMENT_TYPE_LONG then
		ArgumentInfo.Type = Constants.ArgumentType.ARGUMENT_TYPE_LONG
		
		local key, value = string.match(argument, Constants.Patterns.OPTION_VALUED_PATTERN)
		
		if key then
			ArgumentInfo.Name = string.sub(key, 3)
			ArgumentInfo.Value = value
		else
			ArgumentInfo.Name = string.sub(argument, 3) -- If no value is provided, value will be nil
		end
	
	-- Check if argument type is short
	elseif string.sub(argument, 1, 1) == Constants.ArgumentType.ARGUMENT_TYPE_SHORT then
		ArgumentInfo.Type = Constants.ArgumentType.ARGUMENT_TYPE_SHORT
		
		local key, value = string.match(argument, Constants.Patterns.OPTION_VALUED_PATTERN)
		
		if key then
			ArgumentInfo.Name = string.sub(key, 2)	
			ArgumentInfo.Value = value
		else
			ArgumentInfo.Name = string.sub(argument, 2) -- If no value is provided, value will be nil
		end
	else
		ArgumentInfo.Name = argument -- If argument type is normal 
	end
	
	return ArgumentInfo
end

-- EOF --
return {
	Constants = Constants,
	Functions = Functions
}
