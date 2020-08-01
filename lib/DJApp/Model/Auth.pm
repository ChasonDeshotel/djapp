package DJApp::Model::Auth;
use Moo;
use Types::Standard qw(Str Bool Undef);

use DJApp::DB;

my $dbh = DJApp::DB->new();

## need to actually implement this
sub _build_is_authorized {
	my $self = shift;

	if ($self->username eq 'test' and $self->password eq 'pw') {
		return 1;
	}

	return 0;
}

sub _build_auth_key {
	my $self = shift;

	if ($self->username eq 'test' and $self->password eq 'pw') {
		return 'abcd';
	}

	return undef;
}

has is_authorized => (
	is    => 'rw'
	, isa => Bool
	, default => 0
);

has auth_key => (
	is    => 'lazy'
	, isa => Str|Undef #undef if auth fails
);

has username => (
	is    => 'ro'
	, isa => Str
);

has password => (
	is    => 'ro'
	, isa => Str
);

1;
