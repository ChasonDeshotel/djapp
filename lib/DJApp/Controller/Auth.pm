package DJApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::Auth;
use DJApp::Model::User;
use Mojolicious::Plugin::Authentication;

sub load_user {
	my ($self, $auth_key) = @_;

	my $user = DJApp::Model::User->new({auth_key => $auth_key});
	$user->is_authorized(1);
	
	$self->app->log->info("build user with key $auth_key");
	$self->app->log->info($user);
	$self->session('user' => $user);

	return $user
}

sub validate_user {
	my ($self, $username, $password) = @_;

	$self->app->log->info("user $username attempting login");

	my $auth_key = DJApp::Model::Auth->new({
		username   => $username
		, password => $password
	})->auth_key;

	if ($auth_key) {
		$self->app->log->info("user $username successful login with key $auth_key");
		$self->session(auth_key => $auth_key);
		return $auth_key;

	} else {
		# login failed. delete current session
		$self->logout();
		#$self->session(expires => 1);
		#$self->session('user')->is_authorized(0);
		#$self->render(text => $self->session('user')->is_authorized);

		#$self->redirect_to('/login');
		return undef;
	}
}


sub log_in {
	my $self = shift;
	
	my $is_authorized = $self->authenticate($self->param('username'), $self->param('password'));

	if ($is_authorized) {
		$self->flash(message => 'logged in');
		$self->render(text => 'logged in: '.$self->session('user')->id);
	} else {
		$self->flash(message => 'not logged in');
		$self->render(text => 'unauthorized');
	}

}

sub user_exists {
	my $self = shift;
	
	if ($self->is_user_authenticated) {
		return 1;
	} else {
		$self->flash(message=>'not logged in');
		$self->redirect_to('/login');
		return undef
	}
}

1;
