module main

import vweb
import os

const api_port = os.getenv('API_PORT').int()

fn init() {
	conn := create_connection_pg()
	make_tables(conn) or { panic(err) }
	create_admin_user(conn) or { eprintln('Admin user already exists, skipping') }
}

fn main() {
	pool := vweb.database_pool(handler: create_connection_pg)
	app := App.new(pool)
	vweb.run(app, api_port)
}
