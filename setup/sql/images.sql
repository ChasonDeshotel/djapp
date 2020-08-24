create table djapp.images (
	id serial primary key
	, user_id int 
	, filename text
	, uploaded_timestamp timestamp not null default current_timestamp 
)
