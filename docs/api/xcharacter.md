## XCharacter
*The `XCharacter` class represents a single character in the game, bound to a player. It extends the [`DBSC`](./dbsc.md) (Database Synchronized Class) for database support.*

### Fields
`citizen_id` - `string` The unique identifier for the character (primary key).

`owner` - [`XPlayer`](./xplayer.md) The player who owns this character.

`firstname` - `string` The first name of the character.

`lastname` - `string` The last name of the character.

`date_of_birth` - `string` The date of birth of the character in YYYY-MM-DD format.

`account` - [`XAccount`](./xaccount.md) The player's primary banking account.

`xPlayer` - [`XPlayer`](./xplayer.md) The player this character is currently bound to.

---

### XCharacter:new(owner, firstname, lastname, date_of_birth)
*Creates a new character instance and inserts it into the database.*

**parameters**  
`owner` - [`XPlayer`](./xplayer.md) The player who owns this character.  
`firstname` - `string` The first name of the character.  
`lastname` - `string` The last name of the character.  
`date_of_birth` - `string` The date of birth in YYYY-MM-DD format.

**returns**  
`character` - [`XCharacter`](#xcharacter) The new character instance.

---

### XCharacter:getName()
*Returns the character's full name.*

**returns**  
`name` - `string` The full name of the character.

---

### Example Usage
```lua
local character = XCharacter:new(player, "John", "Doe", "1990-01-01")
local name = character:getName()
print(name) -- John Doe
```
