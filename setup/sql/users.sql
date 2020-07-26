create table djapp.users (
	id serial primary key
	, username text
	, password_salt text --not null
	, password_hash text --not null
	, name_first text
	, name_last text
	, name_dj text not null
	, slug text not null unique
	, bio text
	, email text not null
	, is_live boolean not null default false
	, audio_stream_url text
	, video_stream_url text
	, enabled boolean not null default false
	, theme_color text
)
