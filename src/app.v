module main

import vweb
// import db.pg
import db.sqlite

[noinit]
pub struct App {
	vweb.Context // pub:
	// 	db_handle vweb.DatabasePool[pg.DB] [required]
	// pub mut:
	// 	db pg.DB
pub mut:
	// Please don't ever access current_user before checking user_signed_in
	// This could be a Option, but then in the html template, we would need to cast it, because we cannot unwrap it or use the or{} block unfortunately
	current_user   &Customer = unsafe { nil }
	user_signed_in bool

	middlewares    map[string][]vweb.Middleware
	db             sqlite.DB
}

// pub fn App.new(db_handle vweb.DatabasePool[pg.DB]) &App {
// 	return &App{
// 		db_handle: db_handle
// 	}
// }

pub fn App.new(db sqlite.DB, middlewares map[string][]vweb.Middleware) &App {
	return &App{
		db: db
		middlewares: middlewares
	}
}
