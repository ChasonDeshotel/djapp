package DJApp::Controller::DJ;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::DJ;

sub dj_from_slug {
	my $self = shift;
	return DJApp::Model::DJ->new({
		slug => $self->param('slug')
	});
}	

sub view {
	my $self = shift;
	$self->stash(title => 'DJAPP', dj => $self->dj_from_slug);
}

sub view_mixes {
	my $self = shift;
	$self->stash(title => 'DJAPP', dj => $self->dj_from_slug);
}

1;
