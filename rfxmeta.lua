---@meta RFX

---@param path string
function RFX_REQUIRE(path) end

---@param path string
---@param output string
---@param ignore string[]
function PACK(path, output, ignore) end

---@param context string
---@return number reference
function SIMULATION_CREATE(context) end

---@param sim number
---@return number server
function SIMULATION_GET_SERVER(sim) end

---@param sim number
---@param path string
---@return number resource
function RESOURCE_LOAD(sim, path) end

---@param resource number
function RESOURCE_START(resource) end

---@param server number
---@param resource number
---@return number environment
function ENVIRONMENT_GET(server, resource) end

---@param environment number
---@param key string
---@return any value
function ENVIRONMENT_GET_VAR(environment, key) end

---@class Test
Test = {}

---@param name string
---@param cb fun(self: Test) : boolean
function Test.new(name, cb) end

---@param condition boolean
---@param message string
---@return boolean passed
function Test.assert(condition, message) end

---@param a any
---@param b any
---@param message string
---@return boolean passed
function Test.assertEqual(a, b, message) end

---@param value any
---@param acceptedValues any[]
---@param message string
---@return boolean passed
function Test.assertOneOf(value, acceptedValues, message) end

---@param callback fun()
---@param message string
---@return boolean passed
function Test.assertError(callback, message) end

function Test.runAll() end

function Test:run() end
