## XTransaction : DBSC
[DBSC](dbsc.md#dbsc)  
*A transaction represents a money transfer from one account to another. **Objects of this class should not be created manually.***

**fields**  
`transaction_id` - `string` the transaction id of this transaction  
`from_bid` - `string` the id of the account where the money was sent from  
`to_bid` - `string`  the id of the account the money got sent to  
`amount_major` - `number` the major amount (before the .)  
`amount_minor` - `number` the minor amount (after the .)  
`reason` - `string` the reason the transaction was made  
`timestamp` - `TIMESTAMP` the date and time the transaction was made  

--- 

### XTransaction:get(primary_keys)
[DBSC:get(primary_keys)](dbsc.md#dbscgetprimary_keys)  

---

**parameters**  
`primary_keys` - `{ transaction_id : string }` the primary keys (in this case the transaction id)

---

### XTransaction:getWhere(conditions)
[DBSC:getWhere(conditions)](./dbsc.md#dbscgetwhereconditions)  

---