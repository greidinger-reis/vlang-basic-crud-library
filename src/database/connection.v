module database

import db.pg
import db.sqlite
import os

const (
	db_port     = os.getenv('DB_PORT').int()
	db_host     = os.getenv('DB_HOST')
	db_user     = os.getenv('DB_USER')
	db_password = os.getenv('DB_PASSWORD')
	db_name     = os.getenv('DB_NAME')
)

pub fn create_connection_pg() pg.DB {
	return pg.connect(
		host: database.db_host
		port: database.db_port
		user: database.db_user
		password: database.db_password
		dbname: database.db_name
	) or { panic('Failed to create database connection: (${err.msg()})') }
}

pub fn create_connection_sqlite_memory() sqlite.DB {
	return sqlite.connect(':memory:') or {
		panic('Failed to create database connection: (${err.msg()})')
	}
}
