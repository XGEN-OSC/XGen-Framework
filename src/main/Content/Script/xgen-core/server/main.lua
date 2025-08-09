local function init()
    DB.init()
    local xPlayer = XPlayer:new("player_identifier")
    Core.injectFunction("XPlayer.onJoin", function(self)
        print("Player " .. self.identifier .. " has joined the server.")
    end)
    xPlayer:connected()
end

init()