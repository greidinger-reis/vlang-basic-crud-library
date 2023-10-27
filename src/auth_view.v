module main

import vweb

['/signup'; get]
fn (mut ctx App) auth_signup() vweb.Result {
	page_title := 'Signup page'
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}

['/signin'; get]
fn (mut ctx App) auth_signin() vweb.Result {
	page_title := 'Signin page'
	csrf_token := ctx.get_csrf_token()

	return $vweb.html()
}
