local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]

local XPlayer = Server.XPlayer
local XCharacter = Server.XCharacter

Test.new("XPlayer should exist", function()
    return Test.assert(XPlayer ~= nil, "XPlayer should exist")
end)

Test.new("XPlayer should not allow duplicate identifiers", function (self)
    XPlayer:new("my_not_unique_identifier")
    return Test.assertError(function()
        XPlayer:new("my_not_unique_identifier")
    end, "Failed to insert new player into the database.")
end)

Test.new("XPlayer.connected should update players last_seen time", function (self)
    local player = XPlayer:new("feafsdfegasdg") --[[@as Server.XPlayer]]
    player.last_seen = "2000-01-01 00:00:00" --[[@as string]]
    player:connected()
    return Test.assert(player.last_seen ~= "2000-01-01 00:00:00", "XPlayer.last_seen should be set on connect")
end)

Test.new("XPlayer:loadCharacter should load a character", function (self)
    local player = XPlayer:new("aaa") --[[@as Server.XPlayer]]
    local character = XCharacter:new(player, "max", "mustermann", os.date("%Y-%m-%d %H:%M:%S") --[[@as string]]) --[[@as Server.XCharacter]]
    return Test.assert(player:loadCharacter(character.citizen_id), "XPlayer:loadCharacter should return true")
end)

Test.new("XPlayer:unloadCharacter should unload the players character", function (self)
    local player = XPlayer:get({identifier = "aaa"}) --[[@as Server.XPlayer]]
    player:unloadCharacter()
    return Test.assert(player.current_character == nil, "XPlayer:unloadCharacter should set current_character to nil")
end)

Test.new("XPlayer:loadCharacter should throw error if chracter is already being used", function (self)
    local player = XPlayer:get({identifier = "aaa"}) --[[@as Server.XPlayer]]
    local character = XCharacter:new(player, "max", "mustermann", os.date("%Y-%m-%d %H:%M:%S") --[[@as string]]) --[[@as Server.XCharacter]]
    local _ = player:loadCharacter(character.citizen_id)
    local player2 = XPlayer:new("bbb") --[[@as Server.XPlayer]]
    return Test.assertError(function()
        local _ = player2:loadCharacter(character.citizen_id)
    end, "Character is already bound to a player.")
end)
