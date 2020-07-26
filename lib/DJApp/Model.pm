package DJApp::Model;
use DBI;
use Moo;

#my $conn = DBIx::Connector->new($config->{conn_str});
#my $dbh = DBI->connect($data_source, $username, $auth, \%attr);
#my $dbh = $conn->dbh;

sub new {
	my $self = shift;
	my $conn_str = 'dbi:Pg:dbname=djapp';
	my $dbh = DBI->connect($conn_str);
	
	return $dbh->selectall_hashref('select id, artist, title from tracklists', 'id');
}

1;
