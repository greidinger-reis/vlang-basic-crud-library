module main

import vweb

struct SignInBodyDto {
	email    string [required]
	password string [required]
}

struct AuthResponseDto {
	id           string [required]
	name         string [required]
	email        string [required]
	access_token string [required]
}

['/api/auth/signin'; post]
pub fn (mut ctx App) handle_customer_signin() vweb.Result {
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

	return ctx.json_response(AuthResponseDto{
		id: customer_found.id
		email: customer_found.email
		name: customer_found.name
		access_token: token
	})
}

['/api/auth/signup'; post]
pub fn (mut ctx App) handle_customer_signup() vweb.Result {
	credentials := json_decode[NewCustomerDto](ctx.req.data) or {
		ctx.set_status(400, '')
		return ctx.text('Bad request')
	}

	if _ := ctx.customer_find_by_email(credentials.email) {
		ctx.set_status(400, '')
		return ctx.text('Email already in use')
	}

	new_customer := Customer.new(credentials) or {
		ctx.set_status(422, '')
		return ctx.text('Failed to create customer. ${err.msg()}')
	}

	ctx.customer_create(new_customer) or {
		ctx.set_status(422, '')
		return ctx.text('Failed to create customer. ${err.msg()}')
	}
	token := ctx.make_token(sub: new_customer.id) or {
		ctx.set_status(422, '')
		return ctx.text('Failed to create customer. ${err.msg()}')
	}

	return ctx.json_response(AuthResponseDto{
		id: new_customer.id
		email: new_customer.email
		name: new_customer.name
		access_token: token
	})
}
