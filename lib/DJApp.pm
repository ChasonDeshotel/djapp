package DJApp;
use Mojo::Base 'Mojolicious';
use DBIx::Connector;
use Mojo::Util qw(secure_compare);
use lib qw(lib);

sub startup {
  my $self = shift;
  my $config = $self->plugin('Config');
  #$self->secrets($config->{secrets});
	#$self->plugin('DefaultHelpers');
	
	$self->defaults(layout => 'default'); 
	
	my $conn = DBIx::Connector->new($config->{conn_str});
	my $dbh = $conn->dbh;
	$self->helper(dbh => sub { state $dbh = $conn->dbh });
	$self->helper(conn => sub { state $conn = $conn });

	$self->helper(auth => sub {
		if (secure_compare $self->req->url->to_abs->userinfo, 'user:pass') {
			$self->session(auth => 1);
			return 1
		} else {
			$self->res->headers->www_authenticate('Basic');
			$self->render(text => 'Authentication required!', status => 401);
			return 0
		}
	});

	my $r = $self->routes;

	### user routes
	$r->get('/:slug')->to(controller => 'User', action => 'view', template => 'user-page');
	$r->get('/:slug/set_live/:is_live')->to(controller => 'User', action => 'set_live', template => 'user-page');

	### track routes
	$r->get('/track/:id')->to(controller => 'Track', action => 'view');
	$r->get('/track/:id/:action')->to(controller => 'Track');
	$r->post('/track/:action')->to(controller => 'Track');

	### mix routes
	$r->get('/:slug/mix/:id')->to(controller => 'Mix', action => 'view', template => 'mix');
	$r->get('/mix/:id')->to(controller => 'Mix', action => 'view');
	$r->get('/mix/:id/:action')->to(controller => 'Mix');
	$r->post('/mix/:action')->to(controller => 'Mix');


	### tracklist routes

	# should make this work with dates too
	my $tracklist_id_format = qr/all|live|\d+/;


	# default to view all tracklists
#	$r->get('/tracklist/:id/:action' => [
#			action => ['view','download']
#			, id => $tracklist_id_format
#	])->to(controller => 'Tracklist', id => 'all', action => 'view');
#
#	# tracklists to edit must be explicitly defined
#	$r->post('/tracklist/:id/:action' => [
#			action => ['append','replace','delete','remove','clear','upload']
#			, id => $tracklist_id_format
#	])->to(controller => 'Tracklist');
#
#	$r->post('/tracklist/new')->to(controller => 'Tracklist', action => 'new_tracklist');
#
#	## register new user routes
#	$r->get ('/register')->to(controller => 'Registration', action => 'register');
#	$r->post('/register')->to(controller => 'Registration', action => 'register_new_user');

#	$r->post('/authtest' => sub {
#		my $c = shift;
#
#		my $user = $c->param('username');
#		my $pass = $c->param('password');
#
#		return $c->render(text => "welcome $user")
#			if $c->users->is_authorized($user, $pass);
#		
#		$c->render(text => 'not authorized');
#	});

};

1;
