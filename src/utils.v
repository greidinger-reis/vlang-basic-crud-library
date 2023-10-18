module main

import prantlf.json
import vweb

// In vlang 0.4.2 the json module is broken, and is corrupting data on the stack

fn (mut ctx App) json_response[T](data T) vweb.Result {
	json_str := json.marshal(data, json.MarshalOpts{}) or { 'Unknown error stringifying object' }
	ctx.set_content_type('application/json')
	return ctx.ok(json_str)
}

pub fn json_decode[T](json_str string) !T {
	return json.unmarshal[T](json_str, json.UnmarshalOpts{})!
}

pub fn validate_form_data[T](form_data map[string]string) ! {
	$for field in T.fields {
		if form_data[field.name].is_blank() {
			return error('Missing field: ${field.name}')
		}
	}
}
