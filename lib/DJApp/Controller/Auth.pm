package DJApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::Auth;

sub log_in {
	my $self = shift;
	
	my $is_authorized = DJApp::Model::Auth->new({
		username   => $self->param('username')
		, password => $self->param('password')
	})->is_authorized;

	$self->render(json => {'is_authorized'=>$is_authorized});

}

1;
