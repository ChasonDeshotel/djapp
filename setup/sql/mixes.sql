create table djapp.mixes (
	id serial primary key
	, user_id int 
	, title text
	, file_id int
	, image_id int
	, date_live timestamp not null default current_timestamp 
--	, foreign key (tracklist_id) references tracklists(id) int
)
