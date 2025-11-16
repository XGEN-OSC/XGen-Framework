---@enum Event
Event = {
    ---@type 'xcore:account:balance:changed' (accountId: string, newBalance: number) triggered when an account's balance changes.
    ACCOUNT_BALANCE_CHANGED = "xcore:account:balance:changed",

    ---@type 'xcore:character:loaded' (xPlayer: XCore.Player, xCharacter: XCore.Character) triggered when a character is loaded for a player.
    SERVER_CHARACTER_LOADED = "xcore:character:loaded",

    ---@type 'xcore:character:loaded' (xCharacter: XCore.CharacterData) triggered on the client, when a character is loaded.
    CLIENT_CHARACTER_LOADED = "xcore:character:loaded",
}