create table djapp.files (
	id serial primary key
	, user_id int 
	, type_id int
	, filename text
	, uploaded_timestamp timestamp not null default current_timestamp 
)
