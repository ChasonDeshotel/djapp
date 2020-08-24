package DJApp::Controller::Account;
use Mojo::Base 'Mojolicious::Controller';
use DJApp::Model::Mix;
#use DJApp::Model::Account;

sub set_live {
	my $self = shift;

	$self->current_user->set_live($self->param('is_live'));

	$self->render(json => {
		user_key  => $self->current_user->user_key
		, user    => $self->current_user->username
		, is_live => $self->current_user->is_live
	});
}

sub settings {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub connections {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub post {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub schedule {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub mixes {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

sub mix {
	my $self = shift;

	$self->render(text => 'forbidden', status => 403)
		unless $self->current_user->owns_mix($self->param('id'));

	my $mix = DJApp::Model::Mix->new({id => $self->param('id')});

	$self->stash(title => 'DJAPP', user => $self->current_user, mix => $mix);
}

sub edit_mix {
	my $self = shift;

	my $image = $self->req->upload('image_file');
	$image->move_to('/srv/www/djapp/tmp/'.$self->param('image_file')->filename);
	#my $size = $upload->size; # in bytes

	$self->render(json => $self->req->body_params);
	#$self->flash(notice => {title => 'Success', text => 'Changes saved'});
	#$self->redirect_to($self->url_for);
}

sub statistics {
	my $self = shift;
	$self->stash(title => 'DJAPP', user => $self->current_user);
}

1;
