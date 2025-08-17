## XPlayer
*The `XPlayer` class represents a player in the XGen Framework, handling player identification, session tracking, and character management. It extends the [`DBSC`](./dbsc.md) (Database Synchronized Class) for database integration.*


**fields**<br>
`identifier` - `string` The unique identifier of the player (primary key).<br>
`joined` - `string` The timestamp when the player joined.<br>
`last_seen` - `string` The timestamp when the player was last seen.<br>
`current_character` - [`XCharacter?`](./xcharacter.md) The character this player is currently playing.<br>
`hPlayer` - `HPlayer?` The connected HELIX player instance.<br>

---

### XPlayer:new(identifier)
*Creates a new player instance and inserts it into the database.*

---

**parameters**<br>
`identifier` - `string` The identifier of the player.<br>

---

**returns**<br>
`xPlayer` - [`XPlayer`](#xplayer) The new player instance.<br>

---

**example**<br>
```lua
local player = XPlayer:new("steam:110000112345678")
```

---

### XPlayer:connected()
*Called when a player connects to the server. Updates the last seen timestamp and triggers the join logic.*

---

### XPlayer:onJoin()
*Called when a player joins the server or unloads their current character. Starts character selection.*

---

### XPlayer:loadCharacter(citizenId)
*Sets the character this player is currently playing.*

---

**parameters**<br>
`citizenId` - `string` The citizen ID of the character to load.<br>

---

**returns**<br>
`success` - `boolean` Whether the character was successfully loaded.<br>

---

**example**<br>
```lua
player:loadCharacter("citizen_1234")
```

---

### XPlayer:unloadCharacter()
*Unloads the current character and returns the player to character selection.*

---
**example**
```lua
player:unloadCharacter()
```
