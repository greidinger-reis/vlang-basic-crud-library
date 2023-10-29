module main

import vweb
import math

['/admin/books'; get]
pub fn (mut ctx App) admin_books() vweb.Result {
	page_title := 'Admin Book Page'
	csrf_token := ctx.get_csrf_token()

	mut current_page := ctx.query['page'].int()
	if current_page == 0 {
		current_page = 1
	}

	limit := current_page * 10
	offset := (current_page - 1) * 10

	book_list, book_full_len := ctx.book_find_all(limit, offset)

	page_count := math.ceil(f64(book_full_len) / 10.0)

	return $vweb.html()
}

['/admin/books/partial'; get]
pub fn (mut ctx App) admin_partialbooks() vweb.Result {
	mut current_page := ctx.query['page'].int()
	if current_page == 0 {
		current_page = 1
	}

	limit := current_page * 10
	offset := (current_page - 1) * 10

	book_list, book_full_len := ctx.book_find_all(limit, offset)

	page_count := math.ceil(f64(book_full_len) / 10.0)

	return $vweb.html()
}

['/admin/books/partial/navigation'; get]
pub fn (mut ctx App) admin_partialnavigation() vweb.Result {
	page_count := ctx.req.header.get_custom('page_count') or { '1' }.int()
	current_page := ctx.req.header.get_custom('current_page') or { '1' }.int()

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
