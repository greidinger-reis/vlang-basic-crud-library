module order

import time

[table: 'order']
[noinit]
pub struct Order {
pub mut:
	id          string    [primary]
	customer_id string    [json: 'customerId'; references: 'customer(id)']
	created_at  time.Time [json: 'createdAt']
	total_price f64       [json: 'totalPrice']

	order_items []OrderItem [fkey: 'order_id'; json: 'orderItems']
}

[table: 'order_item']
[noinit]
pub struct OrderItem {
pub mut:
	id       string [primary]
	order_id string [json: 'orderId'; references: 'order(id)']
	book_id  string [json: 'bookId'; references: 'book(id)']
	quantity int
}
