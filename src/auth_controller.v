module main

import vweb

['/auth/signin'; post]
pub fn (mut ctx App) handle_signin() vweb.Result {
	token := ctx.make_token(sub: 'admin') or {
		ctx.set_status(400, 'bad request')
		return ctx.text('Unauthorized')
	}

	return ctx.json_response({
		'token': token
	})
}
