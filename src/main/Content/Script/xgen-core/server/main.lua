local function init()
    DB.init()

    local xPlayer = XPlayer:new("Player1")
    if not xPlayer:insert() then error("Failed to insert player into the database.") end
    local xCharacter = XCharacter:new(xPlayer.identifier)
    if not xCharacter:insert() then error("Failed to insert character into the database.") end
    xPlayer = XPlayer:get({ identifier = xPlayer.identifier }) --[[@as XPlayer]]

    local xCharacters = XCharacter:getWhere({ owner = xPlayer.identifier }) --[[@as table<XCharacter>]]

    print("player: ", StringUtils.dumpTable(xPlayer))
    print("characters: ", StringUtils.dumpTable(xCharacters))
end

init() -- TODO: Call this in the initialization event for this resource