module main

pub fn validate_form_data[T](form_data map[string]string) ! {
	$for field in T.fields {
		if form_data[field.name].is_blank() {
			return error('Missing field: ${field.name}')
		}
	}
}