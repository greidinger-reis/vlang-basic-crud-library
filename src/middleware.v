module main

import vweb
import vweb.csrf

pub fn (mut ctx App) before_request() {
	if current_user := ctx.get_current_user() {
		ctx.user_signed_in = true
		ctx.current_user = current_user
	}
}

fn setup_middlewares() map[string][]vweb.Middleware {
	mut middlewares := map[string][]vweb.Middleware{}

	csrf_middleware := [csrf.middleware(csrf_config)]

	middlewares['/admin'] = csrf_middleware
	middlewares['/api/auth'] = csrf_middleware

	return middlewares
}
