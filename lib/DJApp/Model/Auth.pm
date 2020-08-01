package DJApp::Model::Auth;
use Moo;
use Types::Standard qw(Str Bool Undef);
use DJApp::DB;

my $dbh = DJApp::DB->new();

sub _build_user_key {
	my $self = shift;

	if ($self->username eq 'test' and $self->password eq 'pw') {
		return 'abcd';
	}

	return undef;
}

has user_key => (
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
