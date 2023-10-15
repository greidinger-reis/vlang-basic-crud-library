module customer

import internal.order

[table: 'customer']
[noinit]
pub struct Customer {
pub mut:
	id            string [primary]
	name          string
	email         string
	password_hash string [json: 'passwordHash']
	is_admin      bool   [json: 'isAdmin']
	// uncomment this line and watch the compiler go boom
	// orders []order.Order [fkey: 'customer_id']
}
