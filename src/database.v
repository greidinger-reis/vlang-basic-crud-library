import orm
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

pub fn make_tables(db orm.Connection) ! {
	sql db {
		create table Book
		create table Customer
		create table Order
		create table OrderItem
		create table Payment
	}!
}

pub fn create_connection_pg() pg.DB {
	return pg.connect(
		host: db_host
		port: db_port
		user: db_user
		password: db_password
		dbname: db_name
	) or { panic('Failed to create database connection: (${err.msg()})') }
}

pub fn create_connection_sqlite_memory() sqlite.DB {
	return sqlite.connect(':memory:') or {
		panic('Failed to create database connection: (${err.msg()})')
	}
}
