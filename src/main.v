module main

import os
import db.pg
import vweb
import internal.book
import internal.customer
import internal.order
import internal.payment

const (
	api_port    = os.getenv('API_PORT').int()
	db_port     = os.getenv('DB_PORT').int()
	db_host     = os.getenv('DB_HOST')
	db_user     = os.getenv('DB_USER')
	db_password = os.getenv('DB_PASSWORD')
	db_name     = os.getenv('DB_NAME')
)

fn create_connection() pg.DB {
	return pg.connect(
		host: db_host
		port: db_port
		user: db_user
		password: db_password
		dbname: db_name
	) or { panic('Failed to create database connection: (${err.msg()})') }
}

fn init() {
	db := create_connection()
	sql db {
		create table book.Book
		create table customer.Customer
		create table order.Order
		create table order.OrderItem
		create table payment.Payment
	} or { panic('failed to create tables (${err.msg()})') }
}

fn main() {
	pool := vweb.database_pool(handler: create_connection)
	app := App.new(pool)
	vweb.run(app, api_port)
}
