module book

import json
import rand

[table: 'book']
pub struct Book {
pub mut:
	id     string [primary]
	title  string [sql_type: 'varchar(200)']
	author string [sql_type: 'varchar(100)']
	price  f64    [sql_type: 'decimal(8,2)']
	stock  int
}

pub struct NewBookDto {
	title  string [required]
	author string [required]
	price  f64    [required]
	stock  u32    [required]
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

pub fn Book.from_json(data string) !&Book {
	input := json.decode(NewBookDto, data)!
	return Book.new(input.title, input.author, input.price, input.stock)
}
