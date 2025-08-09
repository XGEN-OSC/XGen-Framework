---@class XCharacterSystem This character system should be overwritten by
---an external resource (e.g. multicharacter).
XCharacterSystem = {}

---Starts the character selection process for the given player.
---This is where you should e.g. fade out the screen, set the players coords,
---and display the character selection UI.
---@param xPlayer XPlayer The player for whom to start character selection.
function XCharacterSystem.startCharacterSelection(xPlayer)
    error("startCharacterSelection function should be overwritten by the installed character selection system (external resource).")
end

---This function should start the creation of a new character.
---This is where you should e.g. fade out the screen, set the players coords,
---and display the character creation UI.
---@param xPlayer XPlayer The player for whom to start character creation.
function XCharacterSystem.startCreateNewCharacter(xPlayer)
    error("startCreateNewCharacter function should be overwritten by the installed character creation system (external resource).")
end

---This function should usually be overwritten by the installed character spawn system (external resource).
---@param xPlayer XPlayer The player for whom the character was loaded.
---@param xCharacter XCharacter The character that was loaded.
function XCharacterSystem.onCharacterLoaded(xPlayer, xCharacter)
    error("onCharacterLoaded function should be overwritten by the installed character spawn system (external resource).")
end
