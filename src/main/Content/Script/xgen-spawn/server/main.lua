---@type Core
XCore = nil
Events.Call("xgen:core:get", function (core)
    XCore = core
end)

XCore.inject("XCharacterSystem.onCharacterLoaded", function(xPlayer, xCharacter)
    print("Character loaded for " .. xPlayer.identifier .. ": " .. xCharacter:getName())
end)
