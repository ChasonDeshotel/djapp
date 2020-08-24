package DJApp::Controller::Mix;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw/secure_compare/;
use DJApp::Model::Mix;

sub view {
	my $self = shift;

	$self->stash(
		title  => 'DJApp'
		, mix  => DJApp::Model::Mix->new({id => $self->param('id')})
		, user => DJApp::Model::User->new({username => $self->param('username')})
	);
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
