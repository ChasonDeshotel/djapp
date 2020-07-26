package DJApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::Auth;
use DJApp::Model::User;
use Mojolicious::Plugin::Authentication;

sub log_in {
	my $self = shift;

	$self->app->plugin('authentication' => {
		autoload_user   => 1
		, session_key   => 'djapp'
		, load_user     => sub {
				my ($self, $uid) = @_;
				return DJApp::Model::User->new({id => $uid});
			}
		, validate_user => sub {
				my ($self, $username, $password) = @_;

				### should be user key
				my $uid = DJApp::Model::Auth->new({
					'username'   => $username
					, 'password' => $password
				})->uid;
				$self->session(user => $uid);

				return $uid;
			}
	});
	
	my $authenticated = $self->authenticate(
		$self->param('username')
		, $self->param('password')
	);	

#	if ($authenticated) {
#		$self->flash( message => 'logged in' );
#	} else {
#		$self->flash( message => 'not logged in' );
#	}

	$self->render(json => {authenticated => $authenticated});

}

sub user_exists {
	my $self = shift;
	
	if ( $self->session('user') ) {
		return 1;
	} else {
		$self->redirect_to('login');
	}
}

sub test {
	my $self = shift;
	$self->render(json=>{foo=>'test'});
}

1;
