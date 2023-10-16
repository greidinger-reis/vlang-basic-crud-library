module main

import vweb

['/books/:id'; get]
pub fn (mut ctx App) handle_book_get_one(id string) vweb.Result {
	book := ctx.book_get_by_id(id) or {
		ctx.set_status(404, 'Not Found')
		return ctx.text('Not Found')
	}

	return ctx.json_response(*book)
}

['/books'; get]
pub fn (mut ctx App) handle_get_all() vweb.Result {
	book_list := ctx.book_get_all() or {
		ctx.set_status(500, 'Internal Server Error')
		return ctx.text('Internal Server Error')
	}

	// return ctx.json(book_list)
	return ctx.json_response(book_list)
}

// TODO: Protect this route with authentication (admin only)
['/books'; post]
pub fn (mut ctx App) handle_create() vweb.Result {
	book_data := Book.from_json(ctx.req.data) or {
		ctx.set_status(400, 'Bad Request')
		return ctx.text('Bad Request')
	}

	book := ctx.book_create(book_data) or {
		ctx.set_status(500, 'Internal Server Error')
		return ctx.text('Internal Server Error')
	}

	ctx.set_status(201, 'created')

	// for some reason this one works fine
	return ctx.json(book)
}
