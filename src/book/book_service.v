module book

pub fn (mut c BookController) get_all() ![]Book {
	book_list := sql c.db {
		select from Book
	}!
	return book_list
}

pub fn (mut c BookController) create(book Book) !&Book {
	// This works, but the price is not being inserted correctly, gets inserted as 0
	// sql c.db {
	// 	insert book into Book
	// }!

	c.db.exec_param_many('insert into book(id, title, author, price, stock) values($1, $2, $3, $4, $5)',
		[book.id, book.title, book.author, book.price.str(), book.stock.str()])!

	book_list := sql c.db {
		select from Book where id == book.id limit 1
	}!

	b := book_list.first()

	return &b
}
