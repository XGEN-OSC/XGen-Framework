---@class Server
Server = Server or {}

---@class Server.DB
Server.DB = {}

--- Initializes the database.
function Server.DB.init()
    Database.Initialize('xgen/core/database.db')
    Server.XPlayer:init()
    Server.XAccount:init()
    Server.XCharacter:init()
    Server.XTransaction:init()
end
