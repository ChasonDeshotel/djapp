package DJApp::Model::User;
use Moo;
use Types::Standard qw(Str Int Bool Undef);
use MooX::Types::MooseLike::Base qw(ArrayRef);
#use strictures 2;
#use namespace::clean;
use DJApp::Model::Mix;
use DJApp::DB;
use DJApp::Controller::Auth;

my $dbh = DJApp::DB->new();

sub BUILD {
	my ($self, $args) = @_;
	die "must have at least one of the following: username, user_key"
		unless (exists $args->{username} || exists $args->{user_key});
}

sub ins {
	my $self = shift;
	my $sth = $dbh->prepare('insert into djapp.users (email, username) values (?,?)');
	$sth->execute($self->artist,$self->title) or die $sth->errstr;
	return $sth->errstr || 1;
}

sub set_live {
	my ($self, $is_live) = @_;
	my $sth = $dbh->prepare('update djapp.users set is_live = ? where user_key = ?');
	$sth->execute($is_live,$self->user_key) or die $sth->errstr;
	return $is_live;
}

sub _build_is_live {
	my $self = shift;
	my ($is_live) = $dbh->selectrow_array('select is_live from djapp.users where username = ? limit 1', undef, $self->username);
	return $is_live;
}

sub _build_live_mix {
	my $self = shift;

	if ($self->is_live) {
		my ($current_mix_id) = $dbh->selectrow_array('select * from djapp.mixes where user_id = ? order by date_live desc limit 1', undef, $self->id);
		return DJApp::Model::Mix->new({id => $current_mix_id});
	} else {
		return undef;
	}
}

sub _build_email {
	my $self = shift;
	my ($email) = $dbh->selectrow_array('select email from djapp.users where username = ? limit 1', undef, $self->username);
	return $email;
}

sub _build_theme_color {
	my $self = shift;
	my ($theme_color) = $dbh->selectrow_array('select theme_color from djapp.users where username = ? limit 1', undef, $self->username);
	return $theme_color || 'light-blue accent-4';
}

sub _build_username {
	my $self = shift;
	my ($username) = $dbh->selectrow_array('select username from djapp.users where user_key = ? limit 1', undef, $self->user_key);
	return $username;
}

sub _build_name_first {
	my $self = shift;
	my ($name_first) = $dbh->selectrow_array('select name_first from djapp.users where username = ? limit 1', undef, $self->username);
	return $name_first;
}

sub _build_name_last {
	my $self = shift;
	my ($name_last) = $dbh->selectrow_array('select name_last from djapp.users where username = ? limit 1', undef, $self->username);
	return $name_last;
}

sub _build_name_dj {
	my $self = shift;
	my ($name_dj) = $dbh->selectrow_array('select name_dj from djapp.users where username = ? limit 1', undef, $self->username);
	return $name_dj;
}

sub _build_bio {
	my $self = shift;
	my ($bio) = $dbh->selectrow_array('select bio from djapp.users where username = ? limit 1', undef, $self->username);
	return $bio;
}

sub _build_mixes {
	my $self = shift;
	my @mixes;
	for (@{$dbh->selectcol_arrayref('select id from djapp.mixes where user_id = ? order by date_live', undef, $self->id)}) {
		push(@mixes, DJApp::Model::Mix->new({id => $_}));
	}
	return \@mixes;
}

sub _build_id {
	my $self = shift;
	my ($id) = $dbh->selectrow_array('select id from djapp.users where username = ? limit 1', undef, $self->username);
	return $id;
}

has is_live => (
	is    => 'lazy'
	, isa => Bool
);

has live_mix => (
	is    => 'lazy'
);

has theme_color => (
	is    => 'lazy'
	, isa => Str|Undef
);

has email => (
	is    => 'lazy'
	, isa => Str|Undef
);

has username => (
	is    => 'lazy'
	, isa => Str
);

has password => (
	is    => 'rw'
	, isa => Str
);

has name_first => (
	is    => 'lazy'
	, isa	=> Str
);

has name_last => (
	is    => 'lazy'
	, isa	=> Str
);

has name_dj => (
	is    => 'lazy'
	, isa	=> Str
);

has bio => (
	is    => 'lazy'
	, isa	=> Str|Undef
);

has mixes => (
	is     => 'lazy'
	, isa  => ArrayRef
);

has id  => (
	is    => 'lazy'
	, isa => Int
);

has user_key  => (
	is    => 'ro'
	, isa => Str
);

#has is_authorized => (
#	is    => 'rw'
#	, isa => Bool
#	, default => 0
#);

#has schedule => (
#	is    => 'lazy'
#	, isa => Calendar?
#);


1;

