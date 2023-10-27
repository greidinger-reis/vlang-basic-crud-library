module main

import os
import jwt
import time
import vweb.csrf

const (
	auth_secret_key       = os.getenv('AUTH_SECRET')
	csrf_secret_key       = os.getenv('CSRF_SECRET')
	auth_exp_time_seconds = os.getenv('AUTH_EXP_TIME_SECONDS').int()
	auth_token_name       = 'accesstoken'
)

struct JwtPayload {
	sub string [required]
}

fn (mut ctx App) make_auth_token(customer_id string) !string {
	token := jwt.encode[JwtPayload](
		payload: JwtPayload{
			sub: customer_id
		}
		key: auth_secret_key
	)!

	return token
}

fn (mut ctx App) get_csrf_token() string {
	return csrf.set_token(mut ctx.Context, &csrf_config)
}

fn (mut ctx App) set_auth_token(token string) {
	ctx.set_cookie(
		name: auth_token_name
		value: token
		expires: time.now().add_seconds(auth_exp_time_seconds)
		max_age: 0
		path: '/'
		domain: ctx.req.host
		secure: true
		http_only: true
		same_site: .same_site_strict_mode
	)
}

fn (mut ctx App) nullify_auth_token() {
	ctx.set_cookie(
		name: auth_token_name
		value: ''
		expires: time.now().add_seconds(-auth_exp_time_seconds)
		max_age: 0
		path: '/'
		domain: ctx.req.host
		secure: true
		http_only: true
		same_site: .same_site_strict_mode
	)
}

fn (mut ctx App) get_current_user() ?&Customer {
	token := ctx.get_cookie(auth_token_name) or { return none }
	decoded := jwt.decode[JwtPayload](token: token, key: auth_secret_key) or { return none }
	customer := ctx.customer_find_by_id(decoded.sub)
	return customer
}
