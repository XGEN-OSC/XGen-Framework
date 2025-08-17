## XPlayer
*The `XPlayer` class represents a player in the XGen Framework, handling player identification, session tracking, and character management. It extends the [`DBSC`](./dbsc.md) (Database Synchronized Class) for database integration.*

### Fields
`identifier` - `string` The unique identifier of the player (primary key).
`joined` - `string` The timestamp when the player joined.
`last_seen` - `string` The timestamp when the player was last seen.
`current_character` - [`XCharacter?`](./xcharacter.md) The character this player is currently playing.
`hPlayer` - `HPlayer?` The connected HELIX player instance.

---

### [`XPlayer:new`](#xplayernewidentifier)
*Creates a new player instance and inserts it into the database.*

**parameters**  
`identifier` - `string` The identifier of the player.

**returns**  
`xPlayer` - [`XPlayer`](#xplayer) The new player instance.

---

### [`XPlayer:connected`](#xplayerconnected)
*Called when a player connects to the server. Updates the last seen timestamp and triggers the join logic.*

---

### [`XPlayer:onJoin`](#xplayeronjoin)
*Called when a player joins the server or unloads their current character. Starts character selection.*

---

### [`XPlayer:loadCharacter`](#xplayerloadcharactercitizenid)
*Sets the character this player is currently playing.*

**parameters**  
`citizenId` - `string` The citizen ID of the character to load.

**returns**  
`success` - `boolean` Whether the character was successfully loaded.

---

### [`XPlayer:unloadCharacter`](#xplayerunloadcharacter)
*Unloads the current character and returns the player to character selection.*

---

### Example Usage
```lua
local player = XPlayer:new("steam:110000112345678")
player:connected()
player:loadCharacter("citizen_1234")
player:unloadCharacter()
```
