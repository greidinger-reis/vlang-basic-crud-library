module main

import vweb
import db.pg

pub struct App {
	vweb.Context
	vweb.Controller
pub:
	db_handle vweb.DatabasePool[pg.DB] [required]
pub mut:
	db pg.DB
}

pub fn App.new(db_handle vweb.DatabasePool[pg.DB]) &App {
	return &App{
		db_handle: db_handle
	}
}
