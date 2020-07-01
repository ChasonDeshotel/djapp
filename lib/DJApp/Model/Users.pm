package DJApp::Model::Users;
use Modern::Perl;

use Mojo::Util qw(secure_compare);

my $USERS = {
	test => 'test123'
};

sub new { bless {}, shift }

sub is_authorized {
	my ($self, $user, $pass) = @_;

	return 1 if $USERS->{$user} && secure_compare $USERS->{$user}, $pass;

	return undef;
}
