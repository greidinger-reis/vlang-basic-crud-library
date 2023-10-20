module main

import vweb
import db.pg
// import db.sqlite

pub struct App {
	vweb.Context
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

// pub fn App.new(db sqlite.DB) &App {
// 	return &App{
// 		db: db
// 	}
// }

['/'; get]
pub fn (app &App) index() vweb.Result {
	page_title := 'Vweb Home'
	return $vweb.html()
}
