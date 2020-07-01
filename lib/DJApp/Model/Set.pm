package DJApp::Model::Set;
use Moo;
use Types::Standard qw(Str Int);
use MooX::Types::MooseLike::Base qw(ArrayRef);

use lib qw(lib);
use DJApp::DB;
use DJApp::Model::Track;

my $dbh = DJApp::DB->new();

sub BUILD {
	my ($self, $args) = @_;
	#die "cannot use ID and artist/title at the same time"
	#	if exists $args->{id} && (exists $args->{artist} || exists $args->{title});

	# id provided? does it exist?
	if (exists $args->{id}) {
		my ($res) = $dbh->selectrow_array('select 1 from djapp.sets where id = ? limit 1', undef, $self->{id});
		die "set with ID $args->{id} does not exist" if not $res == '1';
	}

	# id not provided? need title to create

}

sub ins {
	my $self = shift;
	my $sth = $dbh->prepare('insert into djapp.sets (user_id, title) values (?,?)');
	return $sth->execute($self->user_id,$self->title);
}

sub del {
	my $self = shift;
	my $sth = $dbh->prepare('delete from djapp.sets where id = ?');
	return $sth->execute($self->id);
}

sub _build_tracks {
	my $self = shift;

	my $dbh = DJApp::DB->new();

	my @tracks;
	
	my $res = $dbh->selectall_hashref('select play_order, track_id from djapp.tracklists where set_id = ?', 'play_order', undef, $self->id);
	foreach (keys %$res) {
		push @tracks, DJApp::Model::Track->new({
			id => $res->{$_}->{track_id}
			, play_order => $res->{$_}->{play_order}
		});
	}

	return \@tracks;
	
};

sub _build_download_link {
	# different formats?
	return 1;
};

has tracks => (
	#isa => ArrayRef[DJApp::Model::Track]
	isa => ArrayRef
	, is => 'lazy'
	, builder => '_build_tracks'
);

has user_id => (
	is => 'ro'
	, isa => Int
);

has title => (
	is => 'ro'
);

has id => (
	is    => 'ro'
	, isa => Int
);

has download_link => (
	is => 'lazy'
	, isa => Str # url
);

1;
