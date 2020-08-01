package DJApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use Mojolicious::Plugin::Authentication;
use DJApp::Model::User;
use DJApp::Model::Auth;

## authentication plugin helper
sub load_user {
	my ($self, $auth_key) = @_;
	return DJApp::Model::User->new({ auth_key => $auth_key });
}

## authentication plugin helper
sub validate_user {
	my ($self, $username, $password) = @_;

	$self->app->log->info("user $username attempting login");

	my $auth_key = DJApp::Model::Auth->new({
		username   => $username
		, password => $password
	})->auth_key;

	if ($auth_key) {
		$self->app->log->info("user $username successful login with key $auth_key");
		return $auth_key;
	} else {
		$self->app->log->info("user $username logged out due to failing login");
		$self->logout();
		return undef;
	}
}

## actual route/endpoint for the login POST
sub log_in {
	my $self = shift;
	
	my $is_authorized = $self->authenticate($self->param('username'), $self->param('password'));

	if ($is_authorized) {
		$self->flash(message => 'logged in');
		$self->render(text => 'logged in: ' . $self->current_user->id);
	} else {
		$self->flash(message => 'not logged in');
		$self->render(text => 'unauthorized');
	}
}

## route for checking auth status/redirect
sub auth_or_redirect {
	my $self = shift;
	
	if ($self->is_user_authenticated) {
		return 1;
	} else {
		$self->flash(message => 'not logged in');
		$self->redirect_to('/login');
		return undef
	}
}

1;
