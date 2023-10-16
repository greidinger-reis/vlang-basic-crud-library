module main

pub fn (mut ctx App) book_get_all() ![]Book {
	book_list := sql ctx.db {
		select from Book
	}!
	return book_list
}

pub fn (mut ctx App) book_create(book &Book) !&Book {
	// This works, but the price is not being inserted correctly, gets inserted as 0
	// sql ctx.db {
	// 	insert book into Book
	// }!

	ctx.db.exec_param_many('insert into book(id, title, author, price, stock) values($1, $2, $3, $4, $5)',
		[book.id, book.title, book.author, book.price.str(), book.stock.str()])!

	book_list := sql ctx.db {
		select from Book where id == book.id limit 1
	}!

	if book_list.len == 0 {
		return error('Book created not found')
	}

	b := book_list.first()

	return &b
}

pub fn (mut ctx App) book_get_by_id(id string) ?&Book {
	book_list := sql ctx.db {
		select from Book where id == '${id}'
	} or { []Book{} }

	if book_list.len == 0 {
		return none
	}

	b := book_list.first()

	return &b
}
