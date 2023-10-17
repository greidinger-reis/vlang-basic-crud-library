module main

pub fn (mut ctx App) order_create(input &NewOrderDto) !&Order {
	order := Order.new(input)

	sql ctx.db {
		insert order into Order
	}!

	return order
}
