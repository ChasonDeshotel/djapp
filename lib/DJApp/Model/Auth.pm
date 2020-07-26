package DJApp::Model::Auth;
use Moo;
use Types::Standard qw(Str Bool);

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

has is_authorized => (
	is    => 'lazy'
	, isa => Bool
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
