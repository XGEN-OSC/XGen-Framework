local function init()
    DB.init()
    XPlayer:init() -- Initialize the XPlayer table
    local xPlayer = XPlayer:new("Player1", math.random(18, 40))
    if not xPlayer:insert() then error("Failed to insert player into the database.") end
    print(StringUtils.format("$StringUtils.dumpTable(XPlayer:get({ name = \"Player1\" }))$"))

    print("Database initialized successfully.")
end

init() -- TODO: Call this in the initialization event for this resource