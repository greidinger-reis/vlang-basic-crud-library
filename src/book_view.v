module main

import vweb

['/'; get]
pub fn (mut ctx App) index() vweb.Result {
	page_title := 'Book store'
	book_list := ctx.book_find_all()
	return $vweb.html()
}