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
---@param path string
---@return number resource
function RESOURCE_LOAD(sim, path) end

---@param resource number
function RESOURCE_START(resource) end
