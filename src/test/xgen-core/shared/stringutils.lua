local sim = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(sim)
local resource = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-core")
RESOURCE_START(resource)

local environment = ENVIRONMENT_GET(server, resource)
local StringUtils = ENVIRONMENT_GET_VAR(environment, "StringUtils")

Test.new("StringUtils should exist", function (self)
    return Test.assert(StringUtils ~= nil, "StringUtils should not be nil")
end)

Test.new("StringUtils.format should replace placeholders", function (self)
    local result = StringUtils.format("Hello, {name}!", { name = "World" })
    return Test.assertEqual(result, "Hello, World!", "StringUtils.format should replace placeholders correctly")
end)

Test.new("StringUtils.format should handle missing placeholders", function (self)
    local result = StringUtils.format("Hello, {name}!", { age = 30 })
    return Test.assertEqual(result, "Hello, nil!", "StringUtils.format should handle missing placeholders")
end)

Test.new("StringUtils.dumpTable should return string representation of table", function (self)
    local tbl = { a = 1, b = { c = 2, d = 3 } }
    local result = StringUtils.dumpTable(tbl)
    return Test.assertEqual(result, "{ a = 1, b = { c = 2, d = 3 } }", "StringUtils.dumpTable should return correct string representation")
end)

Test.new("StringUtils.dumpTable should handle circular references", function (self)
    local tbl = { a = 1 }
    tbl.b = tbl -- Circular reference
    local result = StringUtils.dumpTable(tbl)
    return Test.assertEqual(result, "{ a = 1, b = <circular reference (" .. tostring(tbl) .. ")> }", "StringUtils.dumpTable should handle circular references")
end)

Test.new("StringUtils.dumpTable should handle non-table values", function (self)
    local result = StringUtils.dumpTable("Hello")
    return Test.assertEqual(result, "Hello", "StringUtils.dumpTable should return string representation of non-table values")
end)

Test.new("StringUtils.dumpTable should handle empty tables", function (self)
    local result = StringUtils.dumpTable({})
    return Test.assertEqual(result, "{ }", "StringUtils.dumpTable should return empty table representation")
end)

Test.new("StringUtils.generate should generate random strings", function (self)
    local result = StringUtils.generate("A0a.")
    return  Test.assertEqual(#result, 4, "StringUtils.generate should generate strings of the correct length") and
            Test.assert(result:match("^[A-Z][0-9][a-z][A-Z0-9]$") ~= nil, "StringUtils.generate should generate strings matching the format")
end)

Test.new("StringUtils.generate should handle empty format", function (self)
    local result = StringUtils.generate("")
    return Test.assertEqual(result, "", "StringUtils.generate should return an empty string for empty format")
end)

Test.new("StringUtils.generate should handle invalid format", function (self)
    local result = StringUtils.generate("norep")
    return Test.assertEqual(result, "norep", "StringUtils.generate should return the input string for invalid format")
end)

Test.new("StringUtils.generate should handle special characters", function (self)
    local result = StringUtils.generate("A0a!@#")
    return Test.assertEqual(#result, 6, "StringUtils.generate should generate strings of the correct length with special characters") and
           Test.assert(result:match("^[A-Z][0-9][a-z]!@#$") ~= nil, "StringUtils.generate should generate strings matching the format with special characters")
end)

Test.new("StringUtils.split should split strings correctly", function (self)
    local result = StringUtils.split("a,b,c", ",")
    return Test.assertEqual(result, { "a", "b", "c" }, "StringUtils.split should split strings by the given delimiter")
end)

Test.new("StringUtils.split should handle empty strings", function (self)
    local result = StringUtils.split("", ",")
    return Test.assertEqual(result, { "" }, "StringUtils.split should return a table with an empty string for empty input")
end)

Test.new("StringUtils.split should handle no delimiter", function (self)
    local result = StringUtils.split("abc", ",")
    return Test.assertEqual(result, { "abc" }, "StringUtils.split should return the original string in a table if no delimiter is found")
end)

Test.new("StringUtils.split should handle multiple delimiters", function (self)
    local result = StringUtils.split("a,,b,c", ",")
    return Test.assertEqual(result, { "a", "", "b", "c" }, "StringUtils.split should handle multiple consecutive delimiters")
end)

Test.new("StringUtils.split should handle leading and trailing delimiters", function (self)
    local result = StringUtils.split(",a,b,c,", ",")
    return Test.assertEqual(result, { "", "a", "b", "c", "" }, "StringUtils.split should handle leading and trailing delimiters")
end)

Test.new("StringUtils.split should handle string delimiter", function (self)
    local result = StringUtils.split("OhMyGod", "My")
    return Test.assertEqual(result, { "Oh", "God" }, "StringUtils.split should split strings by the given string delimiter")
end)
