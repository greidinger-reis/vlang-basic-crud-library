module main

pub fn (mut ctx App) customer_find_by_id(id string) ?&Customer {
	customer_list := sql ctx.db {
		select from Customer where id == id limit 1
	} or { return none }

	customer := customer_list.first()
	return &customer
}
