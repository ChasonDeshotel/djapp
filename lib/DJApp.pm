package DJApp;
use Mojo::Base 'Mojolicious';
use DJApp::Model::DJ;
use DJApp::Controller::DJ;
use DJApp::Controller::Auth;


sub startup {
  my $self = shift;

  my $config = $self->plugin('Config');
  #$self->secrets($config->{secrets});
	#$self->plugin('DefaultHelpers');
	
	$self->plugin('authentication' => {
		autoload_user   => 1
		, session_key   => 'djapp'
		, load_user     => sub { return DJApp::Controller::Auth::load_user(@_) }
		, validate_user => sub { return DJApp::Controller::Auth::validate_user(@_) }
	});

	my $r = $self->routes;

	### similar post routes return JSON?

	### home
	$self->defaults(layout => 'default'); 
	$r->get('/')->to(template => 'index');

	### user routes
	$self->defaults(layout => 'user-default'); 
	$r->get('/:slug')->to(controller => 'DJ', action => 'view', template => 'user-page');

	### track routes
	$r->get('/track/:id')->to(controller => 'Track', action => 'view', layout => 'default');
	$r->get('/track/:id/:action')->to(controller => 'Track');

	### mix routes
	$r->get('/:slug/mix/:id')->to(controller => 'Mix', action => 'view', template => 'mix');
	$r->get('/:slug/mixes')->to(controller => 'DJ', action => 'view_mixes', template => 'mixes');
	$r->get('/mix/:id')->to(controller => 'Mix', action => 'view');
	$r->get('/mix/:id/:action')->to(controller => 'Mix');

	### auth routes
  $r->get ('/login')->to(controller => 'Auth', template => 'login', layout => 'default');
	$r->post('/login')->to(controller => 'Auth', action => 'log_in');
	$r->get ('/register')->to(template => 'register');
	$r->post('/register')->to(controller => 'Registration', action => 'register');

	### auth required
	my $auth_required = $r->under('/')->to('Auth#auth_or_redirect');
	$auth_required->post('/u/set_live/:is_live')->to(controller => 'User', action => 'set_live');
	$auth_required->post('/track/:action')->to(controller => 'Track');
	$auth_required->post('/:slug/mix/:action')->to(controller => 'Mix');

	### tracklist routes

	# should make this work with dates too
	#my $tracklist_id_format = qr/all|live|\d+/;

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


};

1;
