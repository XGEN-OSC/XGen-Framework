SIM = SIMULATION_CREATE("HELIX")
SERVER = SIMULATION_GET_SERVER(SIM)
XGEN_CORE = RESOURCE_LOAD(SIM, "src/main/Content/Script/xgen-core")
RESOURCE_START(XGEN_CORE)

RFX_REQUIRE("src/test/xgen-banking/test.lua")
RFX_REQUIRE("src/test/xgen-charcreator/test.lua")
RFX_REQUIRE("src/test/xgen-core/test.lua")
RFX_REQUIRE("src/test/xgen-multicharacter/test.lua")
RFX_REQUIRE("src/test/xgen-spawn/test.lua")
RFX_REQUIRE("src/test/xgen-target/test.lua")

Test.runAll()

local coverage = RESOURCE_GET_COVERAGE(XGEN_CORE)
local function dump(table)
    if type(table) ~= "table" then
        return tostring(table)
    end
    local str = "{"
    for k, v in pairs(table) do
        if type(v) == "table" then
            str = str .. k .. ": " .. dump(v) .. ", "
        else
            str = str .. k .. ": " .. tostring(v) .. ", "
        end
    end
    str = str .. "}"
    return str
end

local totalCovered = 0
local totalExecutable = 0

for _, entry in ipairs(coverage) do
    local fileName = entry.name
    local covered = #entry.covered
    local executable = #entry.executable
    totalCovered = totalCovered + covered
    totalExecutable = totalExecutable + executable
    print("Coverage for " .. fileName .. ": " .. executable .. "/" .. covered .. " (" .. math.floor((executable / (covered == 0 and 1 or covered)) * 100) .. "%)")
end

print("Total coverage: " .. totalExecutable .. "/" .. totalCovered .. " (" .. math.floor((totalExecutable / (totalCovered == 0 and 1 or totalCovered)) * 100) .. "%)")

if totalExecutable / totalCovered < 0.8 then
    error("Coverage is below 80%: " .. totalExecutable .. "/" .. totalCovered .. " (" .. math.floor((totalExecutable / (totalCovered == 0 and 1 or totalCovered)) * 100) .. "%)")
end