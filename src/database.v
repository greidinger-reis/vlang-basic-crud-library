module main

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

pub fn seed_tables(db orm.Connection, n int) ! {
	customer_list := sql db {
		select from Customer where email == 'admin@email.com'
	}!
	if customer_list.len == 0 {
		return error('Admin user not found')
	}
	customer := &customer_list[0]

	book := Book.new('Test book', 'Test author', 10.0, 10)

	sql db {
		insert book into Book
	}!

	mut items := []NewOrderItemDto{}
	items << NewOrderItemDto{
		book_id: book.id
		quantity: 1
		price: book.price.f64()
	}

	for _ in 0 .. n {
		order := Order.new(
			customer_id: customer.id
			order_items: items
		)
		sql db {
			insert order into Order
		}!
	}
}

pub fn create_admin_user(db orm.Connection) ! {
	admin_user := Customer.new_admin(name: 'admin', email: 'admin@email.com', password: 'admin')!

	sql db {
		insert admin_user into Customer
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

pub fn create_connection_sqlite() sqlite.DB {
	return sqlite.connect('db.sqlite') or {
		panic('Failed to create database connection: (${err.msg()})')
	}
}
