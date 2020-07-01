package DJApp::DB;
use DBI;

sub new {
	my $self = shift;

	my $conn_str = 'dbi:Pg:dbname=djapp';
	my $dbh = DBI->connect($conn_str);
	
	return $dbh;	
}

1;
