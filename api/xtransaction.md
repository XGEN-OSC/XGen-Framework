## XTransaction : DBSC
*A transaction represents a money transfer from one account to another. **Objects of this class should not be created manually.***

**fields**<br>
`transaction_id` - `string` the transaction id of this transaction.<br>
`from_bid` - `string` the id of the account where the money was sent from.<br>
`to_bid` - `string` the id of the account the money got sent to.<br>
`amount_major` - `number` the major amount (before the .).<br>
`amount_minor` - `number` the minor amount (after the .).<br>
`reason` - `string` the reason the transaction was made.<br>
`timestamp` - `TIMESTAMP` the date and time the transaction was made.<br>

---

### XTransaction:get(primary_keys)
*Gets a transaction by its primary keys.*

---
**parameters**<br>
`primary_keys` - `{ transaction_id : string }` the primary keys (in this case the transaction id).<br>

---

### XTransaction:getWhere(conditions)
*Gets transactions matching the given conditions.*

---
**parameters**<br>
`conditions` - `table` the conditions to match.<br>

---