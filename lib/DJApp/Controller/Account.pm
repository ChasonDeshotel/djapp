package DJApp::Controller::Account;
use Mojo::Base 'Mojolicious::Controller';
#use DJApp::Model::Account;

sub set_live {
	my $self = shift;

	$self->current_user->set_live($self->param('is_live'));

	$self->render(json => {
		user_key  => $self->current_user->user_key
		, user    => $self->current_user->username
		, is_live => $self->current_user->is_live
	});
}

sub settings {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub connections {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub post {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub schedule {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub mixes {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub statistics {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

1;
