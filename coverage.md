



## xgen-core/server/util/dbsc.lua
*COVERAGE*: 37/125 (29.0%)
```LUA
41   |     return nil
```
```LUA
64   |             sql = sql .. " AUTO_INCREMENT"
```
```LUA
76   |             sql = sql .. " UNIQUE"
```
```LUA
98   |     for i, key in ipairs(self.__meta.columns) do
99   |         if key.auto_increment then
100  |             goto continue
```
```LUA
102  |         if key.primary_key then
103  |             pks[key.name] = self[key.name]
104  |             pksString = pksString .. ":" .. tostring(self[key.name])
```
```LUA
106  |         if key.default then
107  |             if i >= #self.__meta.columns then
108  |                 sql = sql:sub(1, -3)
```
```LUA
110  |             goto continue
```
```LUA
112  |         sql = sql .. key.name
113  |         if i < #self.__meta.columns then
114  |             sql = sql .. ", "
```
```LUA
116  |         table.insert(values, "?")
```
```LUA
118  |         if key.foreign_key_class then
```
```LUA
120  |             table.insert(thisVals, val)
121  |             goto continue
```
```LUA
124  |         table.insert(thisVals, self[key.name])
125  |         ::continue::
```
```LUA
127  |     sql = sql .. ") VALUES (" .. table.concat(values, ", ") .. ")"
```
```LUA
129  |     if not Database.Execute(sql, thisVals) then
130  |         return false
```
```LUA
133  |     self:get(pks)
```
```LUA
135  |     return true
```
```LUA
148  |     for i, key in ipairs(self.__meta.columns) do
149  |         if key.primary_key then
150  |             table.insert(conditions, key.name .. " = ?")
151  |             table.insert(condValues, self[key.name])
```
```LUA
153  |             sql = sql .. key.name .. " = ?"
```
```LUA
155  |             if key.foreign_key_class then
```
```LUA
157  |                 table.insert(values, val)
```
```LUA
159  |                 table.insert(values, self[key.name])
```
```LUA
162  |             if i < #self.__meta.columns then
163  |                 sql = sql .. ", "
```
```LUA
168  |     sql = sql .. " WHERE " .. table.concat(conditions, " AND ")
169  |     for _, value in ipairs(condValues) do
170  |         table.insert(values, value)
```
```LUA
172  |     return Database.Execute(sql, values)
```
```LUA
180  |     for _, value in pairs(primary_keys) do
181  |         pksString = pksString .. ":" .. tostring(value)
```
```LUA
184  |     if self.__cache[pksString] then
185  |         return self.__cache[pksString]
```
```LUA
192  |     for _, key in ipairs(self.__meta.columns) do
193  |         if key.primary_key then
194  |             table.insert(conditions, key.name .. " = ?")
195  |             table.insert(values, primary_keys[key.name])
```
```LUA
199  |     sql = sql .. table.concat(conditions, " AND ")
```
```LUA
203  |     if result then
```
```LUA
205  |         setmetatable(instance, self)
206  |         instance.__index = instance
207  |         self.__index = self
208  |         for _, key in ipairs(self.__meta.columns) do
209  |             if key.foreign_key_class then
```
```LUA
211  |                 instance[key.name] = foreignKeyClass:get({[key.foreign_key_ref_name] = result[string.upper(key.name)]})
```
```LUA
213  |                 instance[key.name] = result[string.upper(key.name)]
```
```LUA
217  |         self.__cache[pksString] = instance
```
```LUA
219  |         return instance
```
```LUA
222  |     return nil
```
```LUA
234  |     for key, value in pairs(conditions) do
235  |         table.insert(conds, key .. " = ?")
236  |         table.insert(values, value)
```
```LUA
239  |     sql = sql .. table.concat(conds, " AND ")
```
```LUA
242  |     if not results then return {} end
```
```LUA
245  |     for _, result in ipairs(results) do
```
```LUA
247  |         setmetatable(instance, self)
248  |         for _, key in ipairs(self.__meta.columns) do
249  |             if key.foreign_key_class then
```
```LUA
251  |                 instance[key.name] = foreignKeyClass:get({[key.foreign_key_ref_name] = result.Column[string.upper(key.foreign_key_ref_name)]})
```
```LUA
253  |                 instance[key.name] = result.Column[string.upper(key.name)]
```
```LUA
256  |         table.insert(instances, instance)
```
```LUA
260  |     return instances
```
```LUA
268  |     for _, key in ipairs(self.__meta.columns) do
269  |         if key.primary_key then
270  |             pksString = pksString .. ":" .. tostring(self[key.name])
```
```LUA
274  |     if not self.__cache[pksString] then
275  |         return true
```
```LUA
282  |     for _, key in ipairs(self.__meta.columns) do
283  |         if key.primary_key then
284  |             table.insert(conditions, key.name .. " = ?")
285  |             table.insert(values, self[key.name])
```
```LUA
289  |     sql = sql .. table.concat(conditions, " AND ")
290  |     if not Database.Execute(sql, values) then
291  |         return false
```
```LUA
294  |     self.__cache[pksString] = nil
```
```LUA
296  |     return true
```

## xgen-core/server/main.lua
*COVERAGE*: 3/4 (75.0%)
```LUA
8    |     cb(Core)
```

## xgen-core/server/core.lua
*COVERAGE*: 3/16 (18.0%)
```LUA
12   |     if players[player] then
13   |         return players[player]
```
```LUA
21   |     xPlayer = xPlayer or XPlayer:new(identifier)
22   |     xPlayer.hPlayer = player --[[@as HPlayer]]
23   |     players[player] = xPlayer
24   |     return xPlayer
```
```LUA
33   |     for i = 1, #path - 1 do
```
```LUA
35   |         if not module[part] then
36   |             error("Module " .. part .. " not found in path: " .. name)
```
```LUA
38   |         if type(module[part]) ~= "table" then
39   |             error("Expected table for module " .. part .. " in path: " .. name .. ", got " .. type(module[part]))
```
```LUA
41   |         module = module[part]
```
```LUA
45   |     module[functionName] = obj
```


## xgen-core/server/src/xcharactersystem.lua
*COVERAGE*: 4/7 (57.0%)
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
*COVERAGE*: 14/25 (56.0%)
```LUA
29   |     setmetatable(instance, self)
```
```LUA
31   |     instance.citizen_id = StringUtils.generate("AAAA-0000")
32   |     instance.owner = owner
33   |     instance.firstname = firstname
34   |     instance.lastname = lastname
35   |     instance.date_of_birth = date_of_birth
36   |     instance.account = XAccount:new()
37   |     if not instance:insert() then
38   |         error("Failed to create character: " .. instance.citizen_id .. "(citizen id already in use?)")
```
```LUA
40   |     return instance
```
```LUA
47   |     return self.firstname .. " " .. self.lastname
```

## xgen-core/server/src/xplayer.lua
*COVERAGE*: 14/38 (36.0%)
```LUA
22   |     setmetatable(instance, self)
23   |     self.__index = self
24   |     instance.identifier = identifier
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
54   |     if not character then
55   |         return false
```
```LUA
57   |     if character.xPlayer then
58   |         error("Character is already bound to a player.")
```
```LUA
60   |     self.current_character = character
61   |     self.current_character.xPlayer = self
62   |     XCharacterSystem.onCharacterLoaded(self, character)
63   |     return true
```
```LUA
67   |     if not self.current_character then
68   |         return
```
```LUA
70   |     self.current_character.xPlayer = nil
71   |     self.current_character = nil
72   |     self:onJoin()
```

## xgen-core/server/src/xaccount.lua
*COVERAGE*: 23/93 (24.0%)
```LUA
20   |     setmetatable(account, self)
21   |     account.bid = StringUtils.generate("AA-AAAA-0000")
22   |     account.balance_major = 0
23   |     account.balance_minor = 0
24   |     account:insert()
25   |     return account
```
```LUA
32   |     return self.balance_major + (self.balance_minor / 100)
```
```LUA
46   |     return self.balance_major, self.balance_minor
```
```LUA
54   |     return self:getBalanceFloat() >= amount
```
```LUA
63   |     major = math.floor(major)
64   |     minor = math.floor(minor)
```
```LUA
66   |     if self.balance_major > major then
67   |         return true
```
```LUA
69   |         return true
```
```LUA
72   |     return false
```
```LUA
79   |     if major < 0 or minor < 0 then
80   |         error("Cannot add a negative amount to the account balance.")
```
```LUA
83   |     major = math.floor(major)
84   |     minor = math.floor(minor)
```
```LUA
89   |     self.balance_major = self.balance_major + major
90   |     self.balance_minor = self.balance_minor + minor
91   |     if self.balance_minor >= 100 then
92   |         self.balance_major = self.balance_major + math.floor(self.balance_minor / 100)
93   |         self.balance_minor = self.balance_minor % 100
```
```LUA
96   |     if not self:update() then
97   |         self.balance_major = _major
98   |         self.balance_minor = _minor
99   |         error("Failed to update account balance.")
```
```LUA
109  |     if amount < 0 then
110  |         error("Cannot add a negative amount to the account balance.")
```
```LUA
115  |     self:addBalance(major, minor)
```
```LUA
122  |     if major < 0 or minor < 0 then
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
136  |     self.balance_major = self.balance_major - major
137  |     self.balance_minor = self.balance_minor - minor
138  |     if self.balance_minor < 0 then
139  |         self.balance_major = self.balance_major - 1
140  |         self.balance_minor = self.balance_minor + 100
```
```LUA
143  |     if not self:update() then
144  |         self.balance_major = _major
145  |         self.balance_minor = _minor
146  |         error("Failed to update account balance.")
```
```LUA
153  |     if amount < 0 then
154  |         error("Cannot remove a negative amount from the account balance.")
```
```LUA
159  |     self:removeBalance(major, minor)
```
```LUA
171  |         :reverse():gsub("(%d%d%d)", "%1" .. thousandsSeparator)
172  |         :reverse()
173  |     if formatted_major:sub(1, 1) == thousandsSeparator then
174  |         formatted_major = formatted_major:sub(2)
```
```LUA
178  |     return string.format("%s%s%s", formatted_major, decimalSeparator, formatted_minor)
```
```LUA
188  |     if not to_account or not to_account.bid then
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
200  |     if not transaction then
201  |         error("Failed to create transaction.")
```
```LUA
204  |     return transaction
```
```LUA
217  |     return self:send(major, minor, to_account, reason)
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
235  |     return transactions
```
```LUA
241  |     return string.format("XAccount(%s, %d.%02d)", self.bid, self.balance_major, self.balance_minor)
```

## xgen-core/server/src/xtransaction.lua
*COVERAGE*: 14/24 (58.0%)
```LUA
26   |     setmetatable(instance, self)
27   |     instance.transaction_id = StringUtils.generate("TX-....-....-....-....")
28   |     instance.from_bid = from_bid
29   |     instance.to_bid = to_bid
30   |     instance.reason = reason
31   |     instance.amount_major = amount_major
32   |     instance.amount_minor = amount_minor
33   |     if not instance:insert() then
34   |         error("Failed to create transaction: " .. instance.transaction_id .. "(transaction id already in use?)")
```
```LUA
36   |     return instance
```




Total coverage: 181/401 (45%)