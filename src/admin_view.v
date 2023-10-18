module main

import vweb

['/admin/books'; get]
pub fn (mut ctx App) admin_booklist() vweb.Result {
	page_title := 'Admin Book Page'
	book_list := ctx.book_find_all()

	return $vweb.html()
}
