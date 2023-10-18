module main

pub fn (mut ctx App) order_create(input &NewOrderDto) !&Order {
	order := Order.new(input)

	sql ctx.db {
		insert order into Order
	}!

	return order
}

pub fn (mut ctx App) order_find_all() []Order {
	orders := sql ctx.db {
		select from Order
	} or { return [] }

	return orders
}

pub fn (mut ctx App) order_find_by_id(id string) ?&Order {
	orders := sql ctx.db {
		select from Order where id == id
	} or { return none }

	if orders.len == 0 {
		return none
	}

	return &orders[0]
}
