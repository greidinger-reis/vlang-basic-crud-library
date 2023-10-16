module main

pub fn (mut ctx App) order_create(input &NewOrderDto) !&Order {
	o := Order.new(input)

	sql ctx.db {
		insert o into Order
	}!

	order_list := sql ctx.db {
		select from Order where id == o.id limit 1
	}!

	order := order_list.first()
	return &order
}
