local Pack = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Pack")

Test.new('Pack should exist', function (self)
    return Test.assert(Pack ~= nil, "Pack should not be nil")
end)

Test.new('Pack.Pack should pack functions from class to object', function (self)
    local obj = { my_val = 42 }
    local clazz = {
        my_func = function(self) return self.my_val end,
    }
    Pack.Pack(obj, clazz)
    return Test.assertEqual(obj:my_func(), 42, "Packed function should return correct value") and
    Test.assertEqual(obj.my_val, 42, "Original value should remain unchanged")
end)

Test.new('Pack.Pack should handle nested tables with metatables', function (self)
    local obj = {}
    local nested = { nested_func = function(self) return "nested" end }
    setmetatable(nested, nested)
    local clazz = {
        my_func = function(self) return "my_func" end,
        nested_table = nested
    }
    Pack.Pack(obj, clazz)
    return Test.assertEqual(obj:my_func(), "my_func", "Packed function should return correct value") and
    Test.assertEqual(obj.nested_table:nested_func(), "nested", "Nested packed function should return correct value")
end)
