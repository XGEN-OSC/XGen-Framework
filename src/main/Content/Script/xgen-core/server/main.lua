local function init()
    DB.init()
    XPlayer:init() -- Initialize the XPlayer table
    local xPlayer = XPlayer:new("Player1", math.random(18, 40))
    if not xPlayer:insert() then error("Failed to insert player into the database.") end
    print(StringUtils.format("$StringUtils.dumpTable(XPlayer:get({ name = \"Player1\" }))$"))
    xPlayer.age = xPlayer.age - 10
    if not xPlayer:update() then error("Failed to update player in the database.") end
    print(StringUtils.format("$StringUtils.dumpTable(XPlayer:get({ name = \"Player1\" }))$"))
    if not xPlayer:delete() then error("Failed to delete player from the database.") end
    print(StringUtils.format("$StringUtils.dumpTable(XPlayer:get({ name = \"Player1\" }))$"))

    print("Database initialized successfully.")
end

init() -- TODO: Call this in the initialization event for this resource