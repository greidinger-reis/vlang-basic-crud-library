module main

import rand

[table: 'book']
[noinit]
pub struct Book {
pub mut:
	id     string [primary; sql_type: 'varchar(26)']
	title  string
	author string
	// Same issue as in the order_item entity
	price string
	stock int
}

pub struct BookDto {
	title  string [required]
	author string [required]
	price  f64    [required]
	stock  u32    [required]
}

pub fn Book.new(title string, author string, price f64, stock u32) &Book {
	return &Book{
		id: rand.ulid()
		title: title
		author: author
		price: price.str()
		stock: int(stock)
	}
}

pub fn Book.from_json(data string) !&Book {
	input := json_decode[BookDto](data)!
	return Book.new(input.title, input.author, input.price, input.stock)
}

pub fn (b &Book) to_dto() &BookDto {
	return &BookDto{
		title: b.title
		author: b.author
		price: b.price.f64()
		stock: u32(b.stock)
	}
}
