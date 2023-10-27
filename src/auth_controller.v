module main

import vweb
import templates

struct SignInBodyDto {
	email    string [required]
	password string [required]
}

fn SignInBodyDto.from_form(form map[string]string) !&SignInBodyDto {
	validate_form_data[SignInBodyDto](form)!

	return &SignInBodyDto{
		email: form['email']
		password: form['password']
	}
}

struct AuthResponseDto {
	id           string [required]
	name         string [required]
	email        string [required]
	access_token string [required]
}

['/api/auth/signin'; post]
fn (mut ctx App) handle_signin() vweb.Result {
	credentials := SignInBodyDto.from_form(ctx.form) or {
		ctx.set_status(400, '')
		error := 'Invalid Form Data'
		return ctx.html(templates.form_error(error))
	}

	customer_found := ctx.customer_find_by_email(credentials.email) or {
		ctx.set_status(400, '')
		error := 'Invalid Credentials'
		return ctx.html(templates.form_error(error))
	}

	valid_password := customer_found.check_password(credentials.password)

	if !valid_password {
		ctx.set_status(400, '')
		error := 'Invalid Credentials'
		return ctx.html(templates.form_error(error))
	}

	token := ctx.make_auth_token(customer_found.id) or {
		ctx.set_status(422, '')
		error := 'Failed to create customer. ${err.msg()}'
		return ctx.html(templates.form_error(error))
	}

	ctx.header.add_custom('HX-Redirect', '/') or {
		ctx.set_status(500, '')
		error := 'Unknown Error'
		return ctx.html(templates.form_error(error))
	}

	ctx.set_auth_token(token)

	return ctx.ok('')
}

['/api/auth/signup'; post]
fn (mut ctx App) handle_signup() vweb.Result {
	user_data := Customer.from_form(ctx.form) or {
		ctx.set_status(400, '')
		error := 'Invalid form data ${err.msg()}'
		return ctx.html(templates.form_error(error))
	}

	if _ := ctx.customer_find_by_email(user_data.email) {
		ctx.set_status(400, '')
		error := 'Email already in use'
		return ctx.html(templates.form_error(error))
	}

	ctx.customer_create(user_data) or {
		ctx.set_status(422, '')
		error := 'Failed to create customer. ${err.msg()}'
		return ctx.html(templates.form_error(error))
	}

	token := ctx.make_auth_token(user_data.id) or {
		ctx.set_status(422, '')
		error := 'Failed to create customer. ${err.msg()}'
		return ctx.html(templates.form_error(error))
	}

	ctx.set_auth_token(token)

	ctx.header.add_custom('HX-Redirect', '/') or {
		ctx.set_status(500, '')
		error := 'Unknown error'
		return ctx.html(templates.form_error(error))
	}

	return ctx.ok('')
}

['/api/auth/signout'; post]
fn (mut ctx App) handle_signout() vweb.Result {
	ctx.nullify_auth_token()

	ctx.header.add_custom('HX-Redirect', '/') or {
		ctx.set_status(500, '')
		ctx.text('Unkown error')
	}

	return ctx.ok('')
}

['/api/auth/me'; get]
fn (mut ctx App) handle_get_current_user_info() vweb.Result {
	if !ctx.user_signed_in {
		ctx.set_status(401, 'Unauthorized')
		return ctx.text('')
	}

	return ctx.json(AuthResponseDto{
		id: ctx.current_user.id
		name: ctx.current_user.name
		email: ctx.current_user.email
		access_token: 'something'
	})
}
