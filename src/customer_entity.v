module main

import rand
import crypto.bcrypt

[table: 'customer']
[noinit]
pub struct Customer {
mut:
	password_hash string
	is_admin      bool
pub mut:
	id    string [primary]
	name  string
	email string [unique]
	// uncomment this line and watch the compiler go boom
	// orders []Order [fkey: 'customer_id']
}

pub struct NewCustomerDto {
pub mut:
	name     string [required]
	email    string [required]
	password string [required]
}

pub fn Customer.from_form(form map[string]string) !&Customer {
	validate_form_data[NewCustomerDto](form)!

	data := &NewCustomerDto{
		name: form['name']
		email: form['email']
		password: form['password']
	}

	return Customer.new(data)
}

pub fn Customer.new(data &NewCustomerDto) !&Customer {
	customer := Customer{
		id: rand.ulid()
		is_admin: false
		email: data.email
		name: data.name
		password_hash: bcrypt.generate_from_password(data.password.bytes(), 12) or {
			return error('failed to hash password')
		}
	}

	return &customer
}

pub fn Customer.new_admin(data NewCustomerDto) !&Customer {
	customer := Customer{
		id: rand.ulid()
		is_admin: true
		email: data.email
		name: data.name
		password_hash: bcrypt.generate_from_password(data.password.bytes(), 12) or {
			return error('failed to hash password')
		}
	}

	return &customer
}

pub fn (c &Customer) check_password(password string) bool {
	bcrypt.compare_hash_and_password(password.bytes(), c.password_hash.bytes()) or { return false }

	return true
}
