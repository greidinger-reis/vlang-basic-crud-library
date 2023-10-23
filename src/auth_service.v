module main

import os
import jwt

const (
	auth_secret_key       = os.getenv('AUTH_SECRET')
	auth_exp_time_seconds = os.getenv('AUTH_EXP_TIME_SECONDS').int()
)

pub struct JwtPayload {
	sub string
}

pub fn (mut ctx App) make_token(payload JwtPayload) !string {
	token := jwt.encode[JwtPayload](
		payload: JwtPayload{
			sub: payload.sub
		}
		key: auth_secret_key
	)!

	return token
}

pub fn (mut ctx App) get_current_customer() ?&Customer {
	token := ctx.get_cookie('Token') or { return none }
	decoded := jwt.decode[JwtPayload](token: token, key: auth_secret_key) or { return none }
	customer := ctx.customer_find_by_id(decoded.sub)
	return customer
}
