package DJApp::Model::Tracklist;
use Moo;
use Types::Standard qw( Str Int );
use DJApp::DB;
use DJApp::Model::Track;

my $dbh = DJApp::DB->new();

sub get_tracklist_by_id {
	my $self = shift;
	# iterate and make new track objects
	my @ret = $dbh->selectall_array('select * from djapp.tracklists');
	return DJApp::Model::Track->new({'artist'=>@ret[0], 'title'=>@ret[1]});
	# iterate and make tracks
	# add to object
	# return self
}

has tracks => (
	is => 'rw'
	, default => sub{ [] }
	, required => 0
);

has id => (
	is => 'ro'
	, isa => Int
	, required => 0
);

has title => (
	is => 'rw'
	, isa => Str
	, required => 0
);

has author => (
	is => 'rw'
	, isa => Str
	, required => 0
);

1;
