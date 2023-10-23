module main

import vweb

['/signup';get]
fn (mut ctx App) signup_page() vweb.Result {
	page_title := 'Signup page'

	return $vweb.html()
}

['/signin'; get]
fn (mut ctx App) signin_page() vweb.Result {
	page_title := 'Signin page'

	return $vweb.html()
}