---@class DB
DB = {}

--- Initializes the database.
function DB.init()
    Database.Initialize('xgen/core/database.db')
    XPlayer:init()
    XCharacter:init()
end
