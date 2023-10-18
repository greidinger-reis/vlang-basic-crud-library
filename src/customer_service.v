module main

pub fn (mut ctx App) customer_create(customer &Customer) ! {
	sql ctx.db {
		insert customer into Customer
	}!
}

pub fn (mut ctx App) customer_find_by_email(email string) ?&Customer {
	customer_list := sql ctx.db {
		select from Customer where email == email limit 1
	} or { return none }

	if customer_list.len == 0 {
		return none
	}

	return &customer_list[0]
}

pub fn (mut ctx App) customer_find_by_id(id string) ?&Customer {
	customer_list := sql ctx.db {
		select from Customer where id == id limit 1
	} or { return none }

	if customer_list.len == 0 {
		return none
	}

	return &customer_list[0]
}
