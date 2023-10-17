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
	id    string [primary; sql_type: 'varchar(26)']
	name  string
	email string [unique]
	// uncomment this line and watch the compiler go boom
	// orders []order.Order [fkey: 'customer_id']
}

pub struct NewCustomerDto {
pub mut:
	name     string [required]
	email    string [required]
	password string [required]
}

pub fn Customer.new(data NewCustomerDto) !&Customer {
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
	eprintln('checking password: ${password} against ${c.password_hash}')
	bcrypt.compare_hash_and_password(password.bytes(), c.password_hash.bytes()) or { return false }

	return true
}
