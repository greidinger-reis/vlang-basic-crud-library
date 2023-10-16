module main

fn test_create_order() ! {
	mut conn := create_connection_sqlite_memory()
	defer {
		conn.close() or { panic(err) }
	}
	make_tables(conn)!

	c := Customer.new(
		name: 'John Doe'
		email: 'johndoe@email.com'
		password: '1234567'
	)!

	sql conn {
		insert c into Customer
	}!

	b := Book.new('The Lord of the Rings', 'J. R. R. Tolkien', 10.0, 999)

	sql conn {
		insert b into Book
	}!

	o := Order.new(NewOrderDto{
		customer_id: c.id
		order_items: [
			NewOrderItemDto{
				book_id: b.id
				price: 10.0
				quantity: 2
			},
		]
	})

	sql conn {
		insert o into Order
	}!

	found := sql conn {
		select from Order limit 1
	}!

	if found.len == 0 {
		return error('Order not found')
	}

	assert found.first().id == o.id
	assert found.first().customer_id == c.id
	assert found.first().total_price == 20.0
	assert found.first().created_at.unix == o.created_at.unix
}
