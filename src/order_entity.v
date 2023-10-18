module main

import rand
import time

[table: 'order']
[noinit]
pub struct Order {
pub mut:
	id          string      [primary]
	customer_id string      [json: 'customerId'; references: 'customer(id)']
	created_at  time.Time   [json: 'createdAt']
	order_items []OrderItem [fkey: 'order_id'; json: 'orderItems']
}

[table: 'order_item']
[noinit]
pub struct OrderItem {
pub mut:
	id       string [primary]
	order_id string [json: 'orderId'; references: 'order(id)']
	book_id  string [json: 'bookId'; references: 'book(id)']
	// Price as f64 is bugged when inserting using the orm. it gets rounded to 0.0 idk why
	// for now we use string
	price    string
	quantity int
}

pub struct OrderResponseDto {
pub mut:
	id          string [required]
	customer_id string [json: 'customerId'; required]
	created_at  string [json: 'createdAt'; required]
	total_price f64    [json: 'totalPrice'; required]

	order_items []OrderItem [json: 'orderItems'; required]
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
	order_id := rand.ulid()
	mut order_items := []OrderItem{}

	for item in data.order_items {
		o_item := OrderItem{
			id: rand.ulid()
			book_id: item.book_id
			quantity: item.quantity
			price: item.price.str()
			order_id: order_id
		}
		order_items << o_item
	}

	order := Order{
		id: order_id
		customer_id: data.customer_id
		created_at: time.now()
		order_items: order_items
	}

	return &order
}

pub fn (o &Order) get_total_price() f64 {
	mut total_price := 0.0

	for item in o.order_items {
		total_price += item.quantity * item.price.f64()
	}

	return total_price
}

pub fn (o &Order) to_dto() &OrderResponseDto {
	return &OrderResponseDto{
		id: o.id
		created_at: o.created_at.str()
		customer_id: o.customer_id
		order_items: o.order_items
		total_price: o.get_total_price()
	}
}

pub fn (o []Order) to_dto() []OrderResponseDto {
	return o.map(*it.to_dto())
}
