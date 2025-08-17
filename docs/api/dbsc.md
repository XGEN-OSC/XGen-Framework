## DBSC
*The `DBSC` (Database Synchronized Class) class provides a simple way to synchronize classes and objects with the database.*

### DBSC.Meta
*Metadata for a DBSC class.*

**fields**<br>
`name` - `string` The name of the table representing this class in the database.<br>
`columns` - `table<`[`DBSC.Meta.Column`](#dbscmetacolumn)`>` The columns of table in the database.<br>

---

### DBSC.Meta.Column
*Column metadata for a DBSC class.*

**fields**<br>
`name` - `string` the name of the column. This is the name of the column in the database and must be the name of the value in the class.<br>
`type` - `string` the type of the value. This can be a normal database type e.g. VARCHAR or the class name of another [`DBSC`](#dbsc) class.<br>
`primary_key` - `boolean?` if true this column will be registered as primary key.<br>
`not_null` - `boolean?` if true this column will be registered as not nullable.<br>
`unique` - `boolean?` if true this column cannot have the same value twice.<br>

---

### DBSC:new(meta)
*Creates a new class extending the `DBSC` super class.*

---
**parameters**<br>
`meta` - [`DBSC.Meta`](#dbscmeta) the metadata for the database table.<br>

---
**returns**<br>
`class` - `T` the new class extending the `DBSC` class.<br>

---
**example**<br>
```lua
MyClass = DBSC:new({
    name = "my_class",
    columns = {
        { name = "identifier", type = "VARCHAR", primary_key = true }
    }
})
```

---

### DBSC:init()
*Initializes a class extending the DBSC super class. This will create the table in the database (if not exists). This requires the 'self' object to be a DBSC subclass, created with DBSC:new(meta)*

---

**example**
```LUA
-- after class creation and database initialization.

MyClass:init()
```

---

### DBSC:update()
*Updates the row in the database with the data of this object.*

---

**returns**  
`success` - `boolean` true if the object was successfully updated in the database, false if something went wrong (e.g. database not initialized, class not initialized, row deleted).

---

### DBSC:get(primary_keys)
*Loads an object by its primary keys from the database of this subclass of the DBSC super class. This will save the object in the cache for the given primary keys, so when this function is called *

---

**parameters**  
`primary_keys` - `table<string, any>` the values of the primary keys to get the object of this class for.

---

**returns**  
`obj` - `T?` the object for the given primary keys or `nil` if the object doesn't exist.

---

**example**
```LUA
local obj = MyClass:get({ identifier = "my_identifier" })
```

---

### DBSC:getWhere(conditions)
[DBSC:get(primary_keys)](#dbscgetprimary_keys)

*Loads a list of objects of this class where the given conditions are met. This will NOT put this object in the cache and should therefor be cached manually or when ever possible DBSC:get(primary_keys) be used instead.*

---

**parameters**  
`conditions` - `table<string, any>` the conditions that have to be met in order for the row to be selected. The key must be a valid column of the table in the database and the value must match the type of that column. The conditions are `AND` connected.

---

**returns**  
`objects` - `table<T>` The objects that match the given conditions.

---

### DBSC:delete()
*Deletes this object from the database and cache.*

---

**returns**  
`success` - `boolean` true if the row was deleted, false otherwise.

---

**example**
```LUA
-- myObject must be an object of a class extending the DBSC class.
myObject:delete()
```

---
