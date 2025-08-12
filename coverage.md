





## xgen-core/server/core.lua
*COVERAGE*: 4/8 (50.0%)
```LUA
20   |     local xPlayer = XPlayer:get({identifier = identifier}) --[[@as XPlayer?]]
21   |     xPlayer = xPlayer or XPlayer:new(identifier)
```
```LUA
36   |             error("Module " .. part .. " not found in path: " .. name)
```
```LUA
39   |             error("Expected table for module " .. part .. " in path: " .. name .. ", got " .. type(module[part]))
```


## xgen-core/server/src/xcharactersystem.lua
*COVERAGE*: 3/6 (50.0%)
```LUA
10   |     error("startCharacterSelection function should be overwritten by the installed character selection system (external resource).")
```
```LUA
18   |     error("startCreateNewCharacter function should be overwritten by the installed character creation system (external resource).")
```
```LUA
25   |     error("onCharacterLoaded function should be overwritten by the installed character spawn system (external resource).")
```

## xgen-core/server/src/xcharacter.lua
*COVERAGE*: 5/9 (55.0%)
```LUA
29   |     setmetatable(instance, self)
```
```LUA
31   |     instance.citizen_id = StringUtils.generate("AAAA-0000")
```
```LUA
36   |     instance.account = XAccount:new()
37   |     if not instance:insert() then
```

## xgen-core/server/src/xplayer.lua
*COVERAGE*: 6/19 (31.0%)
```LUA
22   |     setmetatable(instance, self)
```
```LUA
25   |     if not instance:insert() then
26   |        error("Failed to insert new player into the database.")
```
```LUA
28   |     return self:get({identifier = identifier}) --[[@as XPlayer]]
```
```LUA
34   |     self:onJoin()
```
```LUA
36   |     self.last_seen = os.date("%Y-%m-%d %H:%M:%S") --[[@as string]]
37   |     if not self:update() then
38   |         error("Failed to update player last seen timestamp.")
```
```LUA
45   |     XCharacterSystem.startCharacterSelection(self)
```
```LUA
53   |     local character = XCharacter:get({citizen_id = citizenId}) --[[@as XCharacter?]]
```
```LUA
58   |         error("Character is already bound to a player.")
```
```LUA
62   |     XCharacterSystem.onCharacterLoaded(self, character)
```
```LUA
72   |     self:onJoin()
```

## xgen-core/server/src/xaccount.lua
*COVERAGE*: 18/63 (28.0%)
```LUA
54   |     return self:getBalanceFloat() >= amount
```
```LUA
63   |     major = math.floor(major)
64   |     minor = math.floor(minor)
```
```LUA
80   |         error("Cannot add a negative amount to the account balance.")
```
```LUA
83   |     major = math.floor(major)
84   |     minor = math.floor(minor)
```
```LUA
92   |         self.balance_major = self.balance_major + math.floor(self.balance_minor / 100)
```
```LUA
96   |     if not self:update() then
```
```LUA
99   |         error("Failed to update account balance.")
```
```LUA
110  |         error("Cannot add a negative amount to the account balance.")
```
```LUA
113  |     local major = math.floor(amount)
```
```LUA
115  |     self:addBalance(major, minor)
```
```LUA
123  |         error("Cannot remove a negative amount from the account balance.")
```
```LUA
126  |     major = math.floor(major)
127  |     minor = math.floor(minor)
```
```LUA
132  |     if self.balance_major < major or (self.balance_major == major and self.balance_minor < minor) then
133  |         error("Insufficient funds to remove from account balance.")
```
```LUA
143  |     if not self:update() then
```
```LUA
146  |         error("Failed to update account balance.")
```
```LUA
154  |         error("Cannot remove a negative amount from the account balance.")
```
```LUA
157  |     local major = math.floor(amount)
```
```LUA
159  |     self:removeBalance(major, minor)
```
```LUA
170  |     local formatted_major = tostring(self.balance_major)
171  |         :reverse():gsub("(%d%d%d)", "%1" .. thousandsSeparator)
172  |         :reverse()
173  |     if formatted_major:sub(1, 1) == thousandsSeparator then
174  |         formatted_major = formatted_major:sub(2)
```
```LUA
176  |     local formatted_minor = string.format("%02d", self.balance_minor)
```
```LUA
178  |     return string.format("%s%s%s", formatted_major, decimalSeparator, formatted_minor)
```
```LUA
189  |         error("Invalid target account.")
```
```LUA
192  |     if not self:hasBalance(major, minor) then
193  |         error("Insufficient funds to send money.")
```
```LUA
196  |     self:removeBalance(major, minor)
197  |     to_account:addBalance(major, minor)
```
```LUA
199  |     local transaction = XTransaction:new(self.bid, to_account.bid, major, minor, reason or "Transfer")
```
```LUA
201  |         error("Failed to create transaction.")
```
```LUA
214  |     local major = math.floor(amount)
```
```LUA
217  |     return self:send(major, minor, to_account, reason)
```
```LUA
224  |     local sent = XTransaction:getWhere({from_bid = self.bid}) --[[@as table<XTransaction>]]
225  |     local received = XTransaction:getWhere({to_bid = self.bid}) --[[@as table<XTransaction>]]
```
```LUA
228  |     for _, tx in ipairs(sent) do
229  |         table.insert(transactions, tx)
```
```LUA
231  |     for _, tx in ipairs(received) do
232  |         table.insert(transactions, tx)
```
```LUA
241  |     return string.format("XAccount(%s, %d.%02d)", self.bid, self.balance_major, self.balance_minor)
```

## xgen-core/server/src/xtransaction.lua
*COVERAGE*: 4/7 (57.0%)
```LUA
26   |     setmetatable(instance, self)
27   |     instance.transaction_id = StringUtils.generate("TX-....-....-....-....")
```
```LUA
33   |     if not instance:insert() then
```






## xgen-charcreator/server/main.lua
*COVERAGE*: 0/1 (0.0%)
```LUA
7    |     print("Starting character creation for " .. xPlayer.identifier)
```


## xgen-multicharacter/server/main.lua
*COVERAGE*: 0/1 (0.0%)
```LUA
7    |     print("Starting character selection for " .. xPlayer.identifier)
```


## xgen-spawn/server/main.lua
*COVERAGE*: 0/1 (0.0%)
```LUA
8    |     print("Character loaded for " .. xPlayer.identifier .. ": " .. xCharacter:getName())
```




Total coverage: 146/221 (66%)