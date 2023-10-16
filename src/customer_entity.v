module main

import rand
import crypto.bcrypt

[table: 'customer']
[noinit]
pub struct Customer {
pub mut:
	id            string [primary]
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
		id: rand.uuid_v4()
		is_admin: false
		email: data.email
		name: data.name
		password_hash: bcrypt.generate_from_password(data.password.bytes(), 12) or {
			return error('failed to hash password')
		}
	}

	return &customer
}
