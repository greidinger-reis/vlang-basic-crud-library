module main

pub fn (mut ctx App) book_find_all() []Book {
	book_list := sql ctx.db {
		select from Book
	} or { return [] }
	return book_list
}

fn (mut ctx App) book_create(book &Book, book_image &BookImage) !&Book {
	sql ctx.db {
		insert book into Book
		insert book_image into BookImage
	}!

	book_list := sql ctx.db {
		select from Book where id == book.id limit 1
	}!

	if book_list.len == 0 {
		return error('Book created not found')
	}

	return &book_list[0]
}

pub fn (mut ctx App) book_find_by_id(id string) ?&Book {
	book_list := sql ctx.db {
		select from Book where id == id
	} or { return none }

	if book_list.len == 0 {
		return none
	}

	return &book_list[0]
}

pub fn (mut ctx App) book_image_find_by_id(id string) ?&BookImage {
	book_image_list := sql ctx.db {
		select from BookImage where book_id == id
	} or { return none }

	if book_image_list.len == 0 {
		return none
	}

	return &book_image_list[0]
}
