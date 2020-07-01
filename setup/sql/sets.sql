create table djapp.sets (
	id serial primary key
	, user_id int 
	, title text
	, file_id int
	, live_date timestamp not null default current_timestamp 
--	, foreign key (tracklist_id) references tracklists(id) int
)
