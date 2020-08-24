package DJApp;
use Mojo::Base 'Mojolicious';
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
	$r->get('/')->to(template => 'index', layout => 'default');

	### auth required
	my $auth_required = $r->under('/')->to('Auth#auth_or_redirect');
	$auth_required->get ('/account/settings'    )->to(controller => 'Account', action => 'settings'   , layout => 'user-admin');
	$auth_required->get ('/account/connections' )->to(controller => 'Account', action => 'connections', layout => 'user-admin');
	$auth_required->get ('/account/post'        )->to(controller => 'Account', action => 'post'       , layout => 'user-admin');
	$auth_required->get ('/account/schedule'    )->to(controller => 'Account', action => 'schedule'   , layout => 'user-admin');
	$auth_required->get ('/account/mixes'       )->to(controller => 'Account', action => 'mixes'      , layout => 'user-admin');
	$auth_required->get ('/account/stats'       )->to(controller => 'Account', action => 'statistics' , layout => 'user-admin');
	$auth_required->post('/account/mix/edit'    )->to(controller => 'Account', action => 'edit_mix'   , layout => 'user-admin');
	$auth_required->get ('/account/mix/:id/edit')->to(controller => 'Account', action => 'mix'        , layout => 'user-admin');

	$auth_required->post('/u/set_live/:is_live')->to(controller => 'User', action => 'set_live');
	$auth_required->post('/track/:action')->to(controller => 'Track');
	$auth_required->post('/:username/mix/:action')->to(controller => 'Mix');

	### api
	#$r->get('/api/tracklist/:id');
	

	### track routes
	$r->get('/track/:id')->to(controller => 'Track', action => 'view', layout => 'default');
	$r->get('/track/:id/:action')->to(controller => 'Track');

	### mix routes
	$r->get('/:username/mix/:id')->to(controller => 'Mix', action => 'view', template => 'mix', layout => 'user-default');
	$r->get('/:username/mixes')->to(controller => 'User', action => 'view_mixes', template => 'mixes', layout => 'user-default');
	$r->get('/mix/:id')->to(controller => 'Mix', action => 'view', layout => 'user-default');
	$r->get('/mix/:id/:action')->to(controller => 'Mix', layout => 'user-default');

	### auth routes
  $r->get ('/login')->to(controller => 'Auth', template => 'login', layout => 'default');
	$r->post('/login')->to(controller => 'Auth', action => 'log_in');
	$r->get ('/register')->to(template => 'register');
	$r->post('/register')->to(controller => 'Registration', action => 'register');
	$r->get ('/logoff')->to(controller => 'Auth', action => 'log_out');


	### user routes
	$r->get('/:username')->to(controller => 'User', action => 'view', template => 'user-page', layout => 'user-default');

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
