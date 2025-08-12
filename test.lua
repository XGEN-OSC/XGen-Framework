SIM = SIMULATION_CREATE("HELIX")
SERVER = SIMULATION_GET_SERVER(SIM)

XGEN_CORE = RESOURCE_LOAD(SIM, "src/main/Content/Script/xgen-core")
RESOURCE_START(XGEN_CORE)

RESOURCES = { XGEN_CORE }

ENVIRONMENT = ENVIRONMENT_GET(SERVER, XGEN_CORE)

RFX_REQUIRE("src/test/xgen-banking/test.lua")
RFX_REQUIRE("src/test/xgen-charcreator/test.lua")
RFX_REQUIRE("src/test/xgen-core/test.lua")
RFX_REQUIRE("src/test/xgen-multicharacter/test.lua")
RFX_REQUIRE("src/test/xgen-spawn/test.lua")
RFX_REQUIRE("src/test/xgen-target/test.lua")

Test.runAll()

local coverage = {}

local function contains(tbl, obj)
    for _, v in ipairs(tbl) do
        if v == obj then
            return true
        end
    end
    return false
end

local function get_cov_entry(file_name)
    for _, entry in ipairs(coverage) do
        if entry.name == file_name then
            return entry
        end
    end
    return nil
end

local function merge_array(arr1, arr2)
    local merged = {}
    for _, v in ipairs(arr1) do
        if not contains(merged, v) then
            table.insert(merged, v)
        end
    end
    for _, v in ipairs(arr2) do
        if not contains(merged, v) then
            table.insert(merged, v)
        end
    end
    return merged
end

for _, resource in ipairs(RESOURCES) do
    local cov = RESOURCE_GET_COVERAGE(resource)
    for _, entry in ipairs(cov) do
        local ent = get_cov_entry(entry.name)
        if ent == nil then
            table.insert(coverage, entry)
        else
            ent.covered = merge_array(ent.covered, entry.covered)
            ent.executable = merge_array(ent.executable, entry.executable)
        end
    end
end

local function readLineOfFile(file, line)
    local currentLine = 1
    for lineContent in file:lines() do
        if currentLine == line then
            return lineContent
        end
        currentLine = currentLine + 1
    end
    return nil
end

local totalCovered = 0
local totalExecutable = 0

local function not_covered(entry)
    local missing = {}
    for _, line in ipairs(entry.executable) do
        if not contains(entry.covered, line) then
            table.insert(missing, line)
        end
    end
    return missing
end

local function fixed_length_str(str, length)
    if #str < length then
        return str .. string.rep(" ", length - #str)
    elseif #str > length then
        return string.sub(str, 1, length)
    else
        return str
    end
end

local function save_coverage(text, file_name)
    local file = io.open(file_name, "w")
    if not file then
        error("Could not open file for writing: " .. file_name)
    end
    file:write(text)
    file:close()
end

local detailedCoverage = ""

for _, entry in ipairs(coverage) do
    local fileName = entry.name
    local path = entry.path
    local covered = #entry.covered
    local executable = #entry.executable
    totalCovered = totalCovered + covered
    totalExecutable = totalExecutable + executable
    local percentage = executable == covered and 1 or (executable == 0 and 1 or (covered / executable))
    local str = string.format("%s | %s | %.2f%%", fixed_length_str(fileName, 50), fixed_length_str(string.format("%d/%d", covered, executable), 10), math.floor(percentage * 100))
    print(">>> " .. str)
    if not (percentage == 1) then
        detailedCoverage = detailedCoverage .. "## " .. fileName .. "\n"
        detailedCoverage = detailedCoverage .. "*COVERAGE*:" .. string.format(" %d/%d (%.2f%%)", covered, executable, math.floor(percentage * 100))
        detailedCoverage = detailedCoverage .. "\n```LUA\n"
        local last = -1
        for _, line in ipairs(not_covered(entry)) do
            if last ~= -1 and last + 1 ~= line then
                detailedCoverage = detailedCoverage .. "```\n```LUA\n"
            end
            detailedCoverage = detailedCoverage .. fixed_length_str(tostring(line), 4) .. " | " .. tostring(readLineOfFile(io.open(path, "r"), line)) .. "\n"
            last = line
        end
        detailedCoverage = detailedCoverage .. "```\n"
    end
end
detailedCoverage = detailedCoverage .. "\n"
detailedCoverage = detailedCoverage .. "Total coverage: " .. totalCovered .. "/" .. totalExecutable .. " (" .. math.floor((totalCovered / (totalExecutable == 0 and 1 or totalExecutable)) * 100) .. "%)"

save_coverage(detailedCoverage, "coverage.md")

print(">>> Total coverage: " .. totalCovered .. "/" .. totalExecutable .. " (" .. math.floor((totalCovered / (totalExecutable == 0 and 1 or totalExecutable)) * 100) .. "%)")

if totalCovered / totalExecutable < 0.8 then
    error("Coverage is below 80%: " .. totalCovered .. "/" .. totalExecutable .. " (" .. math.floor((totalCovered / (totalExecutable == 0 and 1 or totalExecutable)) * 100) .. "%)")
end