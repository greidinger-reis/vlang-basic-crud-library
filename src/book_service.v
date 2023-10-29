module main

import os
import net.http

pub fn (mut ctx App) book_find_all(limit int, offset int) ([]Book, int) {
	book_full_len := sql ctx.db {
		select count from Book
	} or { 0 }

	book_list := sql ctx.db {
		select from Book limit limit offset offset
	} or { [] }

	return book_list, book_full_len
}

fn (mut ctx App) book_create(book &Book, book_cover http.FileData) !&Book {
	sql ctx.db {
		insert book into Book
	}!

	book_list := sql ctx.db {
		select from Book where id == book.id limit 1
	}!

	if book_list.len == 0 {
		return error('Book created not found')
	}

	mut book_cover_file := os.open_file('src/assets/covers/${book.id}.${book_cover.content_type.split('/')[1]}',
		'w')!

	book_cover_file.write(book_cover.data.bytes())!

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
