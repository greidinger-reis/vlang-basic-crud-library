module main

import database
import vweb
import os

const api_port = os.getenv('API_PORT').int()

fn init() {
	conn := database.create_connection_pg()
	database.make_tables(conn) or { panic(err) }
}

fn main() {
	pool := vweb.database_pool(handler: database.create_connection_pg)
	app := App.new(pool)
	vweb.run(app, api_port)
}
