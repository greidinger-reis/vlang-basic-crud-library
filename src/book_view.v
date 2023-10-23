module main

import vweb

['/'; get]
pub fn (mut ctx App) index() vweb.Result {
	page_title := 'Book store'
	book_list := ctx.book_find_all()

	current_user := ctx.get_current_customer()

	return $vweb.html()
}