module main

import time

[table: 'order']
[noinit]
pub struct Order {
pub mut:
	id          string    [default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
	customer_id string    [json: 'customerId'; references: 'customer(id)']
	created_at  time.Time [json: 'createdAt']

	order_items []OrderItem [fkey: 'order_id'; json: 'orderItems']
}

[table: 'order_item']
[noinit]
pub struct OrderItem {
pub mut:
	id       string [default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
	order_id string [json: 'orderId'; references: 'order(id)']
	book_id  string [json: 'bookId'; references: 'book(id)']
	price    f64    [sql_type: 'decimal(8,2)']
	quantity int
}

pub struct NewOrderItemDto {
pub mut:
	book_id  string
	quantity int
	price    f64
}

pub struct NewOrderDto {
pub mut:
	customer_id string
	order_items []NewOrderItemDto
}

pub fn Order.new(data &NewOrderDto) &Order {
	mut order_items := []OrderItem{}

	for item in data.order_items {
		o_item := OrderItem{
			book_id: item.book_id
			quantity: item.quantity
		}
		order_items << o_item
	}

	order := Order{
		customer_id: data.customer_id
		created_at: time.now()
		order_items: order_items
	}

	return &order
}

pub fn (o &Order) get_total_price() f64 {
	mut total_price := 0.0

	for item in o.order_items {
		total_price += item.quantity * item.price
	}

	return total_price
}
