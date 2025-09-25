## xgen-core\server\core.lua
*COVERAGE*: 16/17 (94.0%)
```LUA
17   |         return players[player]
```
## xgen-core\server\interface\xcharactersystem.lua
*COVERAGE*: 5/8 (62.0%)
```LUA
13   |     error("startCharacterSelection function should be overwritten by the installed character selection system (external resource).")
```
```LUA
21   |     error("startCreateNewCharacter function should be overwritten by the installed character creation system (external resource).")
```
```LUA
28   |     error("onCharacterLoaded function should be overwritten by the installed character spawn system (external resource).")
```
## xgen-core\server\src\xaccount.lua
*COVERAGE*: 82/92 (89.0%)
```LUA
101  |         self.balance_major = _major
102  |         self.balance_minor = _minor
103  |         error("Failed to update account balance.")
```
```LUA
143  |         self.balance_major = self.balance_major - 1
144  |         self.balance_minor = self.balance_minor + 100
```
```LUA
148  |         self.balance_major = _major
149  |         self.balance_minor = _minor
150  |         error("Failed to update account balance.")
```
```LUA
201  |         error("Failed to create transaction.")
```
```LUA
232  |         table.insert(transactions, tx)
```
## xgen-core\server\src\xcharacter.lua
*COVERAGE*: 25/26 (96.0%)
```LUA
45   |         error("Failed to create character: " .. instance.citizen_id .. "(citizen id already in use?)")
```
## xgen-core\server\src\xplayer.lua
*COVERAGE*: 39/44 (88.0%)
```LUA
44   |         error("Failed to update player last seen timestamp.")
```
```LUA
60   |         self.current_character.xPlayer = nil
61   |         self.current_character = nil
```
```LUA
65   |         return false
```
```LUA
78   |         return
```
## xgen-core\server\src\xtransaction.lua
*COVERAGE*: 25/26 (96.0%)
```LUA
39   |         error("Failed to create transaction: " .. instance.transaction_id .. "(transaction id already in use?)")
```
## xgen-core\server\util\dbsc.lua
*COVERAGE*: 126/133 (94.0%)
```LUA
76   |             sql = sql .. " AUTO_INCREMENT"
```
```LUA
116  |             goto continue
```
```LUA
126  |             goto continue
```
```LUA
137  |             goto continue
```
```LUA
141  |         ::continue::
```
```LUA
291  |         return true
```
```LUA
307  |         return false
```

Total coverage: 419/447 (93%)