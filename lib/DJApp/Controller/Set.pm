package DJApp::Controller::Set;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw/secure_compare/;
use DJApp::Model::Set;

sub view {
	my $self = shift;

	my $set = DJApp::Model::Set->new({
		id => $self->param('id')
	});

	my $tracks = $set->tracks;

	use Data::Dumper;
	$self->render(json => Dumper($set));
};

sub create {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Set->new({
		user_id => 1 # get from auth
		, title => $self->param('title')
	})->ins;
	$self->render(text => $res);
}

sub delete {
	# authenticate
	my $self = shift;
	my $res = DJApp::Model::Set->new({
		id => $self->param('id')
	})->del;
	$self->render(text => $res);
}

#sub download {
#	my $c = shift;
#	$c->render(text => 'if a download was a available it would download');
#}
#
### POST METHODS
#
#sub append {
#	my $c = shift;
#
#	# Require authentication
#	if (not secure_compare $c->req->url->to_abs->userinfo, 'test:test123') {
#		$c->res->headers->www_authenticate('Basic');
#		$c->render(text => 'Authentication required!', status => 401);
#		return 1
#	}
#
#	#my $track = $c->track->new({
#	#	'artist' => $c->param('artist')
#	#	, 'title' => $c->param('title')
#	#});
#
#	$c->conn->run(fixup => sub {
#		$_->do(
#			'insert into tracklists (artist, title) values (?,?)'
#			, undef
#			, $c->param('artist') #$track->{artist}
#			, $c->param('title') #$track->{title}
#			#, $set_id
#		);
#	});
#
#	$c->render(
#		template  => 'tracklist'
#		, artist  => $c->param('artist')
#		, title   => $c->param('title')
#	);
#}
#
#sub upload {
#	# this will upload a mix and attach it to the specified tracklist
#}

1;
