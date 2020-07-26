package DJApp::Model::Mix;
use Moo;
use Types::Standard qw(Str Int Undef);
use MooX::Types::MooseLike::Base qw(ArrayRef);
use Time::Piece;

use lib qw(lib);
use DJApp::DB;
use DJApp::Model::Track;
use DJApp::Model::File;
use DJApp::Model::User;

my $dbh = DJApp::DB->new();

sub BUILD {
	my ($self, $args) = @_;
	#die "cannot use ID and artist/title at the same time"
	#	if exists $args->{id} && (exists $args->{artist} || exists $args->{title});

	# id provided? does it exist?
	if (exists $args->{id}) {
		my ($res) = $dbh->selectrow_array('select 1 from djapp.mixes where id = ? limit 1', undef, $self->{id});
		die "set with ID $args->{id} does not exist" if not $res == '1';
	}

	# id not provided? need title to create

}

sub ins {
	my $self = shift;
	my $sth = $dbh->prepare('insert into djapp.mixes (user_id, title) values (?,?)');
	return $sth->execute($self->user_id,$self->title);
}

sub del {
	my $self = shift;
	my $sth = $dbh->prepare('delete from djapp.mixes where id = ?');
	return $sth->execute($self->id);
}

sub _build_tracks {
	my $self = shift;

	my @tracks;
	for ($dbh->selectall_array('select play_order, track_id from djapp.tracklists where set_id = ? order by play_order', undef, $self->id)) {
		push @tracks, DJApp::Model::Track->new({
			id => @$_[1]
			, play_order => @$_[0]
		});
	}
	return \@tracks;
	
};

sub _build_title {
	my $self = shift;
	my ($title) = $dbh->selectrow_array('select title from djapp.mixes where id = ? limit 1', undef, $self->id);
	return $title;
}

sub _build_file_id {
	my $self = shift;
	my ($file_id) = $dbh->selectrow_array('select file_id from djapp.mixes where id = ? limit 1', undef, $self->id);
	return $file_id
}

sub _build_download_link {
	my $self = shift;
	if ($self->file_id) {
		return DJApp::Model::File->new({id => $self->file_id})->filename;
	}
}

sub _build_date_live {
	my $self = shift;
	my ($date_live) = $dbh->selectrow_array("select to_char(date_live :: date, 'yyyy/mm/dd') from djapp.mixes where id = ? limit 1", undef, $self->id);
	return $date_live;
}

has tracks => (
	#isa => ArrayRef[DJApp::Model::Track]
	isa => ArrayRef
	, is => 'lazy'
);

has user_id => (
	is => 'ro'
	, isa => Int
);

has title => (
	is    => 'lazy'
	, isa => Str
);

has id => (
	is    => 'ro'
	, isa => Int
);

has download_link => (
	is    => 'lazy'
	, isa => Str|Undef # url
);

has file_id => (
	is    => 'lazy'
	, isa => Int|Undef
);

has date_live => (
	is    => 'lazy'
  , isa => Str #date
);

1;
