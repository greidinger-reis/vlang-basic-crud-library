module main

import crypto.bcrypt

[table: 'customer']
[noinit]
pub struct Customer {
pub mut:
	id            string [default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
	name          string
	email         string
	password_hash string [json: 'passwordHash']
	is_admin      bool   [json: 'isAdmin']
	// uncomment this line and watch the compiler go boom
	// orders []order.Order [fkey: 'customer_id']
}

pub struct NewCustomerDto {
pub mut:
	name     string
	email    string
	password string
}

pub fn Customer.new(data NewCustomerDto) !&Customer {
	customer := Customer{
		is_admin: false
		email: data.email
		name: data.name
		password_hash: bcrypt.generate_from_password(data.password.bytes(), 12) or {
			return error('failed to hash password')
		}
	}

	return &customer
}

pub fn (c &Customer) check_password(password string) bool {
	bcrypt.compare_hash_and_password(c.password_hash.bytes(), password.bytes()) or { return false }

	return true
}
