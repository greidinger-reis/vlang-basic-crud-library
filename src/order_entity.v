module main

import time
import json
import rand

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
	mut total_price := 0.0

	for item in data.order_items {
		o_item := OrderItem{
			id: rand.uuid_v4()
			book_id: item.book_id
			quantity: item.quantity
		}
		total_price = total_price + (item.price * item.quantity)
		order_items << o_item
	}

	order := Order{
		id: rand.uuid_v4()
		customer_id: data.customer_id
		created_at: time.now()
		total_price: total_price
		order_items: order_items
	}

	return &order
}
