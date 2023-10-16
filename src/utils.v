module main

import prantlf.json
import vweb

// In Vlang 0.4.2 the stdlib json.encode() is bugged and is stringifying garbage values on objects
fn (mut ctx App) json_response[T](data T) vweb.Result {
	json_str := json.marshal(data, json.MarshalOpts{}) or { 'Unknown error stringifying object' }
	ctx.set_content_type('application/json')
	return ctx.ok(json_str)
}
