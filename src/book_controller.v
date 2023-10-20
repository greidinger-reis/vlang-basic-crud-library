module main

import os
import vweb

const (
	valid_image_types = ['image/jpeg', 'image/png', 'image/webp']
)

['/api/books/:id'; get]
pub fn (mut ctx App) handle_book_get_one(id string) vweb.Result {
	book := ctx.book_find_by_id(id) or {
		ctx.set_status(404, 'Not Found')
		return ctx.text('Not Found')
	}

	return ctx.json(book)
}

['/api/books'; get]
pub fn (mut ctx App) handle_book_get_all() vweb.Result {
	book_list := ctx.book_find_all()
	return ctx.json(book_list)
}

// TODO: Protect this route with authentication (admin only)
['/api/books'; post]
pub fn (mut ctx App) handle_book_create() vweb.Result {
	if ctx.files['image'].len == 0 {
		ctx.set_status(400, '')
		return ctx.text('Missing book cover')
	}

	book_cover := ctx.files['image'][0]

	if book_cover.content_type !in valid_image_types {
		ctx.set_status(400, '')
		return ctx.text('Invalid book cover type')
	}

	if book_cover.data.len > 8 * 1024 * 1024 {
		ctx.set_status(400, '')
		return ctx.text('Book cover too large. (max 8MB)')
	}

	book_data := Book.from_form(ctx.form) or {
		ctx.set_status(400, '')
		return ctx.text('Invalid form data (${err.msg()})')
	}

	ctx.book_create(book_data, book_cover) or {
		ctx.set_status(500, '')
		return ctx.text('Internal Server Error (${err.msg()})')
	}

	ctx.set_status(201, 'created')
	return ctx.redirect('/admin/books')
}

['/api/books/:id/cover'; get]
pub fn (mut ctx App) handle_book_get_cover(id string) vweb.Result {
	files := os.ls('src/assets/covers') or {
		ctx.set_status(404, '')
		return ctx.text('Not Found')
	}

	filenames := files.filter(it.starts_with(id))

	if filenames.len == 0 {
		ctx.set_status(404, '')
		return ctx.text('Not Found')
	}

	ctx.header.set(.cache_control, 'public, max-age=31536000, immutable')
	ctx.header.set(.content_disposition, 'inline; filename="${filenames[0]}"')

	return ctx.file('src/assets/covers/${filenames[0]}')
}
