module main

[table: 'book']
[noinit]
pub struct Book {
pub mut:
	id     string [default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
	title  string
	author string
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
		title: title
		author: author
		price: price
		stock: int(stock)
	}
}

pub fn Book.from_json(data string) !&Book {
	input := json_decode[NewBookDto](data)!
	return Book.new(input.title, input.author, input.price, input.stock)
}
