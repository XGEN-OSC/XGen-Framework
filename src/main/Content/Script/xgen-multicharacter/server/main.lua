XCore = nil
Events.Call("xgen:core:get", function (core)
    XCore = core
end)

XCore.inject("XCharacterSystem.startCharacterSelection", function(xPlayer)
    print("Starting character selection for " .. xPlayer.identifier)
end)
