## XCharacter
*The `XCharacter` class represents a single character in the game, bound to a player. It extends the [`DBSC`](./dbsc.md) (Database Synchronized Class) for database support.*


**fields**<br>
`citizen_id` - `string` The unique identifier for the character (primary key).<br>
`owner` - [`XPlayer`](./xplayer.md) The player who owns this character.<br>
`firstname` - `string` The first name of the character.<br>
`lastname` - `string` The last name of the character.<br>
`date_of_birth` - `string` The date of birth of the character in YYYY-MM-DD format.<br>
`account` - [`XAccount`](./xaccount.md) The player's primary banking account.<br>
`xPlayer` - [`XPlayer`](./xplayer.md) The player this character is currently bound to.<br>

---

### XCharacter:new(owner, firstname, lastname, date_of_birth)
*Creates a new character instance and inserts it into the database.*

---

**parameters**<br>
`owner` - [`XPlayer`](./xplayer.md) The player who owns this character.<br>
`firstname` - `string` The first name of the character.<br>
`lastname` - `string` The last name of the character.<br>
`date_of_birth` - `string` The date of birth in YYYY-MM-DD format.<br>

---

**returns**<br>
`character` - [`XCharacter`](#xcharacter) The new character instance.<br>

---

**example**<br>
```lua
local character = XCharacter:new(player, "John", "Doe", "1990-01-01")
```

---

### XCharacter:getName()
*Returns the character's full name.*

---

**returns**<br>
`name` - `string` The full name of the character.<br>

---

**example**<br>
```lua
local name = character:getName()
print(name) -- John Doe
```

---
