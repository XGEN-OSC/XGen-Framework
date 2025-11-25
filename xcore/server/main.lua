local function loadAllOrganizations()
    for _, job in pairs(Config.jobs) do
        local _ = XCore.Organization.ById(job.name)
    end
end

local function onStartup()
    loadAllOrganizations()
end

onStartup()
