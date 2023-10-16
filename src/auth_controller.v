module main

import vweb

struct SignInBodyDto {
	email    string [required]
	password string [required]
}

struct SignInResponseDto {
	id           string [required]
	name         string [required]
	email        string [required]
	access_token string [required]
}

['/auth/signin'; post]
pub fn (mut ctx App) handle_signin() vweb.Result {
	credentials := json_decode[SignInBodyDto](ctx.req.data) or {
		ctx.set_status(400, '')
		return ctx.text('Bad request')
	}

	customer_found := ctx.customer_find_by_email(credentials.email) or {
		ctx.set_status(400, '')
		return ctx.text('Invalid Credentials')
	}

	valid_password := customer_found.check_password(credentials.password)
	eprintln(valid_password)

	if !valid_password {
		ctx.set_status(400, '')
		return ctx.text('Invalid Credentials')
	}

	token := ctx.make_token(sub: customer_found.id) or {
		ctx.set_status(400, '')
		return ctx.text('Unauthorized')
	}

	eprintln(customer_found)

	return ctx.json_response(SignInResponseDto{
		id: customer_found.id
		email: customer_found.email
		name: customer_found.name
		access_token: token
	})
}
