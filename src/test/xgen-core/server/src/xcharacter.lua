local XCharacter = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server.XCharacter") --[[@as Server.XCharacter]]
local XPlayer = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server.XPlayer") --[[@as Server.XPlayer]]

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
