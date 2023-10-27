module main

import vweb
import os
import vweb.csrf

const api_port = os.getenv('API_PORT').int()

const (
	csrf_config = csrf.CsrfConfig{
		secret: os.getenv('CSRF_SECRET')
		allowed_hosts: ['*']
	}
)

fn init() {
	conn := create_connection_sqlite()
	make_tables(conn) or { panic(err) }
	create_admin_user(conn) or { eprintln('NOTICE:  Admin user already exists, skipping') }
}

fn main() {
	// pool := vweb.database_pool(handler: create_connection_pg)
	// mut app := App.new(pool)
	db := create_connection_sqlite()
	middlewares := setup_middlewares()
	mut app := App.new(db, middlewares)

	app.handle_static('src/assets', true)

	vweb.run(app, api_port)
}

['/'; get]
pub fn (mut ctx App) index() vweb.Result {
	page_title := 'Book store'
	book_list := ctx.book_find_all()
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}
