module main

import rand
import time
import net.http

[table: 'book_image']
[noinit]
pub struct BookImage {
	blob string [sql_type: 'blob']
pub mut:
	id           string [primary]
	book_id      string [json: 'bookId'; references: 'book(id)']
	alt_text     string [json: 'altText']
	content_type string [json: 'contentType']

	created_at time.Time [json: 'createdAt']
	updated_at time.Time [json: 'updatedAt']
}

pub fn BookImage.new(book &Book, image_blob string, content_type string, alt string) &BookImage {
	return &BookImage{
		id: rand.ulid()
		book_id: book.id
		alt_text: alt
		content_type: content_type
		blob: image_blob.str()
		created_at: time.now()
		updated_at: time.now()
	}
}

pub fn BookImage.from_files(book &Book, files map[string][]http.FileData) !&BookImage {
	if 'image' !in files {
		return error('No image file found')
	}

	images := files['image']

	if images.len > 1 {
		return error('Only one image file is allowed')
	}

	image := images[0]

	return BookImage.new(book, image.data, image.content_type, image.filename)
}

[table: 'book']
[noinit]
pub struct Book {
pub mut:
	id     string [primary; sql_type: 'varchar(26)']
	title  string
	author string
	// Same issue as in the order_item entity
	price string
	stock int
}

pub struct BookDto {
	title  string [required]
	author string [required]
	price  f64    [required]
	stock  u32    [required]
}

pub fn Book.new(title string, author string, price f64, stock u32) &Book {
	return &Book{
		id: rand.ulid()
		title: title
		author: author
		price: price.str()
		stock: int(stock)
	}
}

pub fn Book.from_json(data string) !&Book {
	input := json_decode[BookDto](data)!
	return Book.new(input.title, input.author, input.price, input.stock)
}

pub fn Book.from_form(form map[string]string) !&Book {
	validate_form_data[BookDto](form)!

	return Book.new(form['title'], form['author'], form['price'].f64(), form['stock'].u32())
}

pub fn (b &Book) to_dto() &BookDto {
	return &BookDto{
		title: b.title
		author: b.author
		price: b.price.f64()
		stock: u32(b.stock)
	}
}
