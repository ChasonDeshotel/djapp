package DJApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::User;

sub user_from_slug {
	my $self = shift;
	return DJApp::Model::User->new({
		slug => $self->param('slug')
	});
}	

sub view {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->user_from_slug);
}

sub view_mixes {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->user_from_slug);
}

sub set_live {
	my $self = shift;
	$self->user_from_slug->set_live($self->param('is_live'));
	$self->render(json => {'is_live' => $self->user_from_slug->is_live});
}

1;
