package DJApp::Model::File;
use DJApp::DB;
use Moo;
use Types::Standard qw(Str Int);
#use strictures 2;
#use namespace::clean;

my $dbh = DJApp::DB->new();

sub _build_filename {
	my $self = shift;
	my ($filename) = $dbh->selectrow_array('select filename from djapp.files where id = ? limit 1', undef, $self->id);
	return $filename;
}

sub _build_user_id {
	my $self = shift;
	my ($user_id) = $dbh->selectrow_array('select user_id from djapp.files where id = ? limit 1', undef, $self->id);
	return $user_id;
}

has id => (
	is    => 'rw'
	, isa => Int
);

has filename => (
	is    => 'lazy'
	, isa => Str
);

has user_id => (
	is    => 'lazy'
	, isa => Int
);

1;
