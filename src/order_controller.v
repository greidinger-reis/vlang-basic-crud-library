module main

import vweb

struct NewOrderInputDto {
	book_id  string
	quantity int
}

struct NewOrderInputBodyDto {
	items []NewOrderInputDto
}

['/api/orders'; post]
pub fn (mut ctx App) handle_order_create() vweb.Result {
	customer := ctx.get_current_customer() or {
		ctx.set_status(401, '')
		return ctx.text('Unauthorized')
	}

	input := json_decode[NewOrderInputBodyDto](ctx.req.data) or {
		ctx.set_status(400, '')
		return ctx.text('Invalid JSON body (${err.msg()})')
	}

	mut new_order_items := []NewOrderItemDto{}

	for i in input.items {
		book := ctx.book_find_by_id(i.book_id) or {
			ctx.set_status(400, '')
			return ctx.text('Invalid book id')
		}
		new_order_items << NewOrderItemDto{
			price: book.price.f64()
			book_id: book.id
			quantity: i.quantity
		}
	}

	new_order_dto := &NewOrderDto{
		customer_id: customer.id
		order_items: new_order_items
	}

	created := ctx.order_create(new_order_dto) or {
		ctx.set_status(500, '')
		return ctx.text('Failed to create order (${err.msg()})')
	}

	ctx.set_status(201, '')
	return ctx.json_response(*created.to_dto())
}

['/api/orders'; get]
pub fn (mut ctx App) handle_order_find_all() vweb.Result {
	customer := ctx.get_current_customer() or {
		ctx.set_status(401, '')
		return ctx.text('Unauthorized')
	}

	if !customer.is_admin {
		ctx.set_status(403, '')
		return ctx.text('Forbidden')
	}

	orders := ctx.order_find_all()

	return ctx.json_response(orders.to_dto())
}

['/orders/:id'; get]
pub fn (mut ctx App) handle_order_find_one(id string) vweb.Result {
	customer := ctx.get_current_customer() or {
		ctx.set_status(401, '')
		return ctx.text('Unauthorized')
	}

	order := ctx.order_find_by_id(id) or {
		ctx.set_status(404, '')
		return ctx.text('Order not found')
	}

	if order.customer_id != customer.id {
		ctx.set_status(403, '')
		return ctx.text('Forbidden')
	}

	return ctx.json_response(*order.to_dto())
}
