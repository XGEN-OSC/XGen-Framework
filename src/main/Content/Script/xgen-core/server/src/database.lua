---@class DB
DB = {}

--- Initializes the database.
function DB.init()
    Database.Initialize('xgen/core/database.db')
    XPlayer:init()
    XAccount:init()
    XCharacter:init()
end
