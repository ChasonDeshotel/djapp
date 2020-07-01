use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use DJApp::Model::Track;

my $t = Test::Mojo->new('DJApp');


$my $track = DJApp::Model::Track->new({ artist => 'slime grub', title => 'slimin yuh street' });

$t->get_ok('/track/12/view')
	->status_is(200)
	->content_like(qw/avril/);
);



like $t->post_ok('/insurance' => form => {name 

$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

done_testing();
