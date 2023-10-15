module book

import internal.order

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

// pub fn Book.new() &Book {
// }

// struct BookFromJsonDto {
// 	name  string [required]
// 	price f64    [required]
// 	sku   string
// }

// pub fn Book.from_json(data string) !&Book {
// }
