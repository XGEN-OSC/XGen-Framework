## Core
*The `Core` module provides utility functions for player management and module injection in the XGen Framework server.*


### Core.getXPlayer(player)
*Returns the [`XPlayer`](../../../../../../docs/api/xplayer.md) instance associated with the given HELIX player.*

---

**parameters**<br>
`player` - `HPlayer` The HELIX player object.<br>

---

**returns**<br>
`xPlayer` - [`XPlayer`](../../../../../../docs/api/xplayer.md) The XPlayer instance associated with the player.<br>

---

**example**<br>
```lua
local xPlayer = Core.getXPlayer(hPlayer)
```

---

### Core.inject(name, obj)
*Injects a given object or value into a module by path.*

---

**parameters**<br>
`name` - `string` The dot-separated path to the module field to inject into.<br>
`obj` - `any` The object or value to inject.<br>

---

**example**<br>
```lua
Core.inject("SomeModule.someFunction", function() print("Hello!") end)
```

---
