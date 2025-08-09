XCore = nil
Events.Call("xgen:core:get", function (core)
    XCore = core
end)

XCore.inject("XCharacterSystem.startCreateNewCharacter", function(xPlayer)
    print("Starting character creation for " .. xPlayer.identifier)
end)
