module main

import vweb

['/admin/books'; get]
pub fn (mut ctx App) admin_booklist() vweb.Result {
	page_title := 'Admin Book Page'
	book_list := ctx.book_find_all()
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}

['/admin/books/new'; get]
pub fn (mut ctx App) admin_newbook() vweb.Result {
	page_title := 'Admin New Book Page'
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}