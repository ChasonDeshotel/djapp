package DJApp::Controller::Registration;
use Mojo::Base 'Mojolicious::Controller';

sub register {
	my $c = shift;
	$c->render(
		template  => 'register'
		, error   => $c->flash('error')
		, message => $c->flash('message')
	);
}

sub register_new_user {
	my $c = shift;
	my $conn = $c->conn;

	my $username = $c->param('username');
	my $password = $c->param('password');

	my $query = 'select now() as now';
	my $sth = $conn->run(fixup => sub {
		$_->do('insert into users (username) values (?)', undef, $username);
	});

	$c->render(text => $username);


	#my $confirm_password = $c->param('confirm_password');
	#my $first_name = $c->param('firstName');
	#my $middle_name = $c->param('middleName');
	#my $last_name = $c->param('lastName');

#	if (! $email || ! $password || ! $confirm_password || ! $first_name || ! $last_name) {
#		$c->flash( error => 'Username, Password, First Name and Last Name are the mandatory fields.');
#		$c->redirect_to('register');
#	}
#
#	if ($password ne $confirm_password) {
#		$c->flash( error => 'Password and Confirm Password must be same.');
#		$c->redirect_to('register');
#	}

#	my $dbh = $c->app->{_dbh};

#	my $user = $dbh->resultset('User')->search({ email => $email });

#	if (! $user->first ) {
#		eval {
#			$dbh->resultset('User')->create({ 
#				email	   => $email,
#				password	=> generate_password($password),
#				first_name  => $first_name,
#				middle_name => $middle_name,
#				last_name   => $last_name,
#				status	  => 1
#			});
#		};
#		if ($@) {
#			$c->flash( error => 'Error in db query. Please check mysql logs.');
#			$c->redirect_to('register');
#		}
#		else {
#			$c->flash( message => 'User added to the database successfully.');
#			$c->redirect_to('register');
#		}
#	}
#	else {
#		$c->flash( error => 'Username already exists.');
#		$c->redirect_to('register');
#	}
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
