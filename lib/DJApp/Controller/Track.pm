package DJApp::Controller::Track;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(secure_compare);
use DJApp::Model::Track;

sub view {
	my $self = shift;
	my $track = DJApp::Model::Track->new({
		id => $self->param('id')
	});

	# testing builders
	my $artist = $track->artist;
	my $title  = $track->title;

	use Data::Dumper;
	$self->render(json => Dumper($track));
}

sub create {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Track->new({
		artist => $self->param('artist')
		, title => $self->param('title')
	})->ins;
	$self->render(text => $res);
}

sub delete {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Track->new({
		id => $self->param('id')
	})->del;
	$self->render(text => $res);
}

1;

__END__


sub push_to_playlist {
	my $c = shift;

	# Require authentication
f (not secure_compare $c->req->url->to_abs->userinfo, 'test:test123') {
		$c->res->headers->www_authenticate('Basic');
		$c->render(text => 'Authentication required!', status => 401);
		return 1
	}

	#my $track = $c->track->new({
	#	'artist' => $c->param('artist')
	#	, 'title' => $c->param('title')
	#});


	$c->render(
		template  => 'tracklist'
		, artist  => $c->param('artist')
		, title   => $c->param('title')
	);
}

1;
