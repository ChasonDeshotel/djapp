package DJApp::Controller::Registration;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::User;

sub register {
	my $self = shift;

	my $username = $self->param('username');
	my $password = $self->param('password');

	if (!$username || !$password ) {
		$self->flash( error => 'fill in all fields');
		$self->redirect_to('register');
	}

	$self->flash(message => 'user added');
	$self->redirect_to('register');
}

sub generate_password {
	my $password = shift;

	my $pbkdf2 = Crypt::PBKDF2->new(
		hash_class => 'HMACSHA1', 
		iterations => 1000,	   
		output_len => 20,		 
		salt_len   => 4,		 
	);

	return $pbkdf2->generate($password);
}

1;
