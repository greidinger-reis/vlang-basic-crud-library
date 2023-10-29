module main

import vweb

['/admin/books'; get]
pub fn (mut ctx App) admin_books() vweb.Result {
	page_title := 'Admin Book Page'
	book_list := ctx.book_find_all()
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}

['/admin'; get]
pub fn (mut ctx App) admin_index() vweb.Result {
	page_title := 'Admin Page'
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}

['/admin/sidemenu'; get]
pub fn (mut ctx App) admin_sidemenu() vweb.Result {
	location := ctx.req.header.get_custom('Location') or { 'unknown' }
	return $vweb.html()
}
