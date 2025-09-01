local function init()
    Server.DB.init()
end

init()

Events.Subscribe("xgen:core:get", function (cb)
    cb(Server.Core)
end)