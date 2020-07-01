create table djapp.users (
	id serial primary key
	, username text
	, password_salt text
	, password_hash text
	, name_first text
	, name_last text
	, name_dj text
	, email text
	, is_live boolean not null default false
	, enabled boolean not null default false
)
