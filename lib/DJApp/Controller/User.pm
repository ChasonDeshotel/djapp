package DJApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::User;

sub set_live {
	my $self = shift;

	my $is_live = $self->param('is_live');
	#$self->render(json => {ay => 'yes'});
	$self->render(json => {
		auth_key  => $self->session('auth_key')
		, user    => $self->session('user')
		, is_live => 1
	});


	#$self->session('user')->set_live($self->param('is_live'));

	#$self->user_from_slug->set_live($self->param('is_live'));
	#$self->render(json => {'is_live' => $self->user_from_slug->is_live});
}

1;

