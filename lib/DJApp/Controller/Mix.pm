package DJApp::Controller::Mix;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw/secure_compare/;
use DJApp::Model::Mix;

# should be helper? shared w/ controller::user
sub user_from_slug {
	my $self = shift;
	return DJApp::Model::User->new({
		slug => $self->param('slug')
	});
}	

sub view {
	my $self = shift;

	my $mix = DJApp::Model::Mix->new({
		id => $self->param('id')
	});

	$self->stash(title => 'DJAPP', mix => $mix, user => $self->user_from_slug);
};

sub create {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Mix->new({
		user_id => 1 # get from auth
		, title => $self->param('title')
	})->ins;
	$self->render(text => $res);
}

sub delete {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Mix->new({
		id => $self->param('id')
	})->del;
	$self->render(text => $res);
}

1;
