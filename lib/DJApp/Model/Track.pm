package DJApp::Model::Track;
use DJApp::DB;
use Moo;
use Types::Standard qw(Str Int);
#use strictures 2;
#use namespace::clean;

my $dbh = DJApp::DB->new();

sub BUILD {
	my ($self, $args) = @_;
	die "cannot use ID and artist/title at the same time"
		if exists $args->{id} && (exists $args->{artist} || exists $args->{title});

	# id provided? does it exist?
	if (exists $args->{id}) {
		my ($res) = $dbh->selectrow_array('select 1 from djapp.tracks where id = ? limit 1', undef, $self->{id});
		die "track with ID $args->{id} does not exist" if not $res == '1';
	}
}

sub ins {
	my $self = shift;
	my $sth = $dbh->prepare('insert into djapp.tracks (artist, title) values (?,?)');
	return $sth->execute($self->artist,$self->title);
}

sub del {
	my $self = shift;
	my $sth = $dbh->prepare('delete from djapp.tracks where id = ?');
	return $sth->execute($self->id);
}

sub _build_artist {
	my $self = shift;
	my ($artist) = $dbh->selectrow_array('select artist from djapp.tracks where id = ? limit 1', undef, $self->id);
	return $artist || 'Unknown';
}

sub _build_title {
	my $self = shift;
	my ($title) = $dbh->selectrow_array('select title from djapp.tracks where id = ? limit 1', undef, $self->id);
	return $title || 'Unknown';
}


has artist => (
	is        => 'lazy'
	, isa     => Str
);

has title => (
	is        => 'lazy'
	, isa     => Str
);

has play_order => (
	is    => 'rw'
	, isa => Int
);

has id => (
	is    => 'ro'
	, isa => Int
);


1;
