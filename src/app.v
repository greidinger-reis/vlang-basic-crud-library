module main

import vweb
import db.pg
import book

pub struct App {
	vweb.Context
	vweb.Controller
pub:
	db_handle vweb.DatabasePool[pg.DB] [required]
pub mut:
	db pg.DB
}

pub fn App.new(db_handle vweb.DatabasePool[pg.DB]) &App {
	book_controller := book.BookController.new(db_handle)
	eprintln('[Vweb] BookController started on /books')

	return &App{
		db_handle: db_handle
		controllers: [
			vweb.controller('/books', book_controller),
		]
	}
}
