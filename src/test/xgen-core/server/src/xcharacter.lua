local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]

local XCharacter = Server.XCharacter
local XPlayer = Server.XPlayer

Test.new("XCharacter should exist", function (self)
    return Test.assert(XCharacter ~= nil, "XCharacter should not be nil")
end)

Test.new("XCharacter.new should create new character", function (self)
    local xPlayer = XPlayer:new("asdf")
    local character = XCharacter:new(xPlayer, "max", "mustermann", "2000-01-01")
    return Test.assert(character ~= nil, "XCharacter should not be nil") and
        Test.assert(character.owner == xPlayer, "XCharacter should have the correct XPlayer reference") and
        Test.assert(character.account ~= nil, "XCharacter should have an account")
end)
