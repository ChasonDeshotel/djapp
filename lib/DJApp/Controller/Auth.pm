package DJApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use Mojolicious::Plugin::Authentication;
use DJApp::Model::User;
use DJApp::Model::Auth;

## authentication plugin helper
sub load_user {
	my ($self, $user_key) = @_;
	my $user = DJApp::Model::User->new({ user_key => $user_key });
	return $user;
}

## authentication plugin helper
sub validate_user {
	my ($self, $username, $password) = @_;

	$self->app->log->info("user $username attempting login");

	my $user_key = DJApp::Model::Auth->new({
		username   => $username
		, password => $password
	})->user_key;

	$self->app->log->info("$user_key") if $user_key;

	if ($user_key) {
		$self->app->log->info("user $username successful login with key $user_key");
		return $user_key;
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
		$self->flash(notice => {title => 'Welcome', text => 'Welcome, '.$self->current_user->name_first});
		$self->redirect_to('/'.$self->current_user->username);
	} else {
		$self->flash(notice => {title => 'Error', text => 'Not logged in'});
		$self->redirect_to('/login');
	}
}

sub log_out {
	my $self = shift;
	my $username = $self->current_user->username;
	$self->logout;
	$self->redirect_to('/'.$username);
}

## route for checking auth status/redirect
sub auth_or_redirect {
	my $self = shift;
	
	if ($self->is_user_authenticated) {
		return 1;
	} else {
		$self->flash(error => 'not logged in');
		$self->redirect_to('/login');
		return undef
	}
}

1;
