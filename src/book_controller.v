module main

import vweb

['/api/books/:id'; get]
pub fn (mut ctx App) handle_book_get_one(id string) vweb.Result {
	book := ctx.book_find_by_id(id) or {
		ctx.set_status(404, 'Not Found')
		return ctx.text('Not Found')
	}

	return ctx.json_response(*book)
}

['/api/books'; get]
pub fn (mut ctx App) handle_book_get_all() vweb.Result {
	book_list := ctx.book_find_all()
	// return ctx.json(book_list)
	return ctx.json_response(book_list)
}

// TODO: Protect this route with authentication (admin only)
['/api/books'; post]
pub fn (mut ctx App) handle_book_create() vweb.Result {
	book_data := Book.from_form(ctx.form) or {
		ctx.set_status(400, '')
		return ctx.text('Invalid form data (${err.msg()})')
	}

	book_image := BookImage.from_files(book_data, ctx.files) or {
		ctx.set_status(400, '')
		return ctx.text('Invalid form data (${err.msg()})')
	}

	ctx.book_create(book_data, book_image) or {
		ctx.set_status(500, 'Internal Server Error')
		return ctx.text('Internal Server Error (${err.msg()})')
	}

	ctx.set_status(201, 'created')

	// return ctx.text('Created')
	return ctx.redirect('/admin/books')
}

['/api/books/:id/cover'; get]
pub fn (mut ctx App) handle_image_get(id string) vweb.Result {
	book_image := ctx.book_image_find_by_id(id) or {
		ctx.set_status(404, '')
		return ctx.text('Not Found')
	}

	ctx.set_content_type(book_image.content_type)

	return ctx.ok(book_image.blob)
}
