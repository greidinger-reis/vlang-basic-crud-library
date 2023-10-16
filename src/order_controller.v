module main

import vweb

struct NewOrderInputDto {
	book_id  string
	quantity int
}

struct NewOrderInputBodyDto {
	items []NewOrderInputDto
}

['/orders'; post]
pub fn (mut ctx App) handle_order_create() vweb.Result {
	customer := ctx.get_current_customer() or {
		ctx.set_status(401, 'Unauthorized')
		return ctx.text('Unauthorized')
	}

	input := json_decode[NewOrderInputBodyDto](ctx.req.data) or {
		ctx.set_status(400, 'Bad Request')
		return ctx.text('Invalid JSON body (${err.msg()})')
	}

	mut new_order_items := []NewOrderItemDto{}

	for i in input.items {
		book := ctx.book_get_by_id(i.book_id) or {
			ctx.set_status(400, 'Bad Request')
			return ctx.text('Invalid book id')
		}
		new_order_items << NewOrderItemDto{
			price: book.price
			book_id: book.id
			quantity: i.quantity
		}
	}

	new_order_dto := &NewOrderDto{
		customer_id: customer.id
		order_items: new_order_items
	}

	created := ctx.order_create(new_order_dto) or {
		ctx.set_status(500, 'Internal Server Error')
		return ctx.text('Failed to create order (${err.msg()})')
	}

	ctx.set_status(201, 'created')
	return ctx.json(created)
}
