package DJApp::Model::User;
use DJApp::DB;
use Moo;
use Types::Standard qw(Str Int Bool Undef);
use MooX::Types::MooseLike::Base qw(ArrayRef);
#use strictures 2;
#use namespace::clean;
use DJApp::Model::Mix;

my $dbh = DJApp::DB->new();

sub ins {
	my $self = shift;
	my $sth = $dbh->prepare('insert into djapp.users (email, username) values (?,?)');
	return $sth->execute($self->artist,$self->title);
}

sub set_live {
	my ($self, $is_live) = @_;
	my $sth = $dbh->prepare('update djapp.users set is_live = ? where id = ?');
	$sth->execute($is_live,$self->id);
	$self->_build_is_live;
}

sub _build_is_live {
	my $self = shift;
	my ($is_live) = $dbh->selectrow_array('select is_live from djapp.users where id = ? limit 1', undef, $self->id);
	return $is_live || 0;
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
	my ($email) = $dbh->selectrow_array('select email from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $email || die 'user does not exist';
}

sub _build_id {
	my $self = shift;
	my ($id) = $dbh->selectrow_array('select id from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $id || die 'user does not exist';
}

sub _build_username {
	my $self = shift;
	my ($username) = $dbh->selectrow_array('select username from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $username || die 'user does not exist';
}

sub _build_name_first {
	my $self = shift;
	my ($name_first) = $dbh->selectrow_array('select name_first from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $name_first || die 'user does not exist';
}

sub _build_name_last {
	my $self = shift;
	my ($name_last) = $dbh->selectrow_array('select name_last from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $name_last || die 'user does not exist';
}

sub _build_name_dj {
	my $self = shift;
	my ($name_dj) = $dbh->selectrow_array('select name_dj from djapp.users where slug = ? limit 1', undef, $self->slug);
	return $name_dj || die 'user does not exist';
}

sub _build_bio {
	my $self = shift;
	my ($bio) = $dbh->selectrow_array('select bio from djapp.users where slug = ? limit 1', undef, $self->slug);
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

has slug => (
	is => 'ro'
	, isa => Str
);

has is_live => (
	is    => 'lazy'
	, isa => Bool
);

has live_mix => (
	is    => 'lazy'
);

has email => (
	is    => 'lazy'
	, isa => Str
);

has username => (
	is    => 'lazy'
	, isa => Str
);

has artist => (
	is    => 'lazy'
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

#has schedule => (
#	is    => 'lazy'
#	, isa => Calendar?
#);


1;

