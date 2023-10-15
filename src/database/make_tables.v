module database

import orm
import book
import customer
import order
import payment

pub fn make_tables(db orm.Connection) ! {
	sql db {
		create table book.Book
		create table customer.Customer
		create table order.Order
		create table order.OrderItem
		create table payment.Payment
	}!
}
