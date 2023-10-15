module e2e

import database
import customer
import book
import order

fn test_create_order() ! {
	mut conn := database.create_connection_sqlite_memory()
	defer {
		conn.close() or { panic(err) }
	}
	database.make_tables(conn)!

	c := customer.Customer.new(
		name: 'John Doe'
		email: 'johndoe@email.com'
		password: '1234567'
	)!

	sql conn {
		insert c into customer.Customer
	}!

	b := book.Book.new('The Lord of the Rings', 'J. R. R. Tolkien', 10.0, 999)

	sql conn {
		insert b into book.Book
	}!

	o := order.Order.new(order.NewOrderDto{
		customer_id: c.id
		order_items: [
			order.NewOrderItemDto{
				book_id: b.id
				price: 10.0
				quantity: 2
			},
		]
	})

	sql conn {
		insert o into order.Order
	}!

	found := sql conn {
		select from order.Order limit 1
	}!

	assert found.first().id == o.id
	assert found.first().customer_id == c.id
	assert found.first().total_price == 20.0
	assert found.first().created_at.unix == o.created_at.unix
}
