module book

import order
import json
import rand

[table: 'book']
[noinit]
pub struct Book {
pub mut:
	id     string [primary]
	title  string
	author string
	price  f64    [sql_type: 'decimal(10,2)']
	stock  int

	order_items []order.OrderItem [fkey: 'book_id']
}

pub fn Book.new(title string, author string, price f64, stock u32) &Book {
	return &Book{
		id: rand.uuid_v4()
		title: title
		author: author
		price: price
		stock: int(stock)
	}
}

pub struct BookFromJsonDto {
	title  string [required]
	author string [required]
	price  f64    [required]
	stock  u32    [required]
}

pub fn Book.from_json(data string) !&Book {
	input := json.decode(BookFromJsonDto, data)!
	return Book.new(input.title, input.author, input.price, input.stock)
}
