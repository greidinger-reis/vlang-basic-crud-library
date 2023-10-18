module main

import vweb

['/books'; get]
pub fn (mut ctx App) books_list() vweb.Result {
	book_list := ctx.book_find_all()
	return $vweb.html()
}

['/new-book-form'; get]
pub fn (mut ctx App) books_form() vweb.Result {
	return $vweb.html()
}
