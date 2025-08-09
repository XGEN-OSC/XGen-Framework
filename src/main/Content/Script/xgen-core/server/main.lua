local function init()
    DB.init()
end

init()

Events.Subscribe("xgen:core:get", function (cb)
    cb(Core)
end)