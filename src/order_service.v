module main

pub fn (mut ctx App) order_create(input &NewOrderDto) !&Order {
	o := Order.new(input)
	print('creating order: ${o}')

	sql ctx.db {
		insert o into Order
	}!

	order_list := sql ctx.db {
		select from Order where id == o.id limit 1
	}!

	if order_list.len == 0 {
		return error('Order created not found')
	}

	order := order_list.first()
	return &order
}
