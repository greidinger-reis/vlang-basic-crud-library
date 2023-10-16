module main

import time

[table: 'payment']
[noinit]
pub struct Payment {
pub mut:
	id             string    [primary]
	order_id       string    [json: 'orderId'; references: 'order(id)']
	payment_amount f64       [json: 'paymentAmount']
	payment_date   time.Time [json: 'paymentDate']
}
