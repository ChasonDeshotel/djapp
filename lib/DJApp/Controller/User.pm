package DJApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::User;

sub set_live {
	my $self = shift;

	$self->current_user->set_live($self->param('is_live'));

	$self->render(json => {
		user_key  => $self->current_user->user_key
		, user    => $self->current_user->username
		, is_live => $self->current_user->is_live
	});
}

sub user_from_username {
	my $self = shift;
	return DJApp::Model::User->new({
		username => $self->param('username')
	});
}	

sub view {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->user_from_username, current_user => $self->current_user);
}

sub view_mixes {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->user_from_username, current_user => $self->current_user);
}

1;
