module book

import vweb
import db.pg

[noinit]
pub struct BookController {
	vweb.Context
pub mut:
	db        pg.DB
	db_handle vweb.DatabasePool[pg.DB] [required]
}

pub fn BookController.new(db_handle vweb.DatabasePool[pg.DB]) &BookController {
	book_controller := BookController{
		db_handle: db_handle
	}

	return &book_controller
}

['/'; get]
pub fn (mut c BookController) handle_get_all() vweb.Result {
	book_list := c.get_all() or {
		c.set_status(500, 'Internal Server Error')
		return c.json({
			'error': 'Internal Server Error'
		})
	}
	// eprintln('controller: book_list = ${book_list}')

	return c.json(book_list)
}

// TODO: Protect this route with authentication (admin only)
['/'; post]
pub fn (mut c BookController) handle_create() vweb.Result {
	book_data := Book.from_json(c.req.data) or {
		c.set_status(400, 'Bad Request')
		return c.json({
			'error': 'Invalid Book Data'
		})
	}

	book := c.create(book_data) or {
		c.set_status(500, 'Internal Server Error')
		return c.json({
			'error': 'Internal Server Error'
		})
	}

	c.set_status(201, 'created')
	return c.json(book)
}
