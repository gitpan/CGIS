package CGIS;

# $Id: CGIS.pm,v 1.5 2002/12/18 02:03:30 sherzodr Exp $

use strict;
use warnings;
use vars ('@ISA');
require CGI;
@ISA = ('CGI');


($CGIS::VERSION) = '$Revision: 1.5 $' =~ m/Revision:\s*(\S+)/;

# Preloaded methods go here.

sub session {
    my $self = shift;
        
    my $session_obj = $self->{_SESSION_OBJ};    
    unless ( defined $session_obj ) {
        require CGI::Session;
        $session_obj = new CGI::Session(undef, $self, 
                                {Directory=>$CGITempFile::TMPDIRECTORY});
        $self->{_SESSION_OBJ} = $session_obj;
        $self->param($session_obj->name, $session_obj->id);
    }

    unless ( @_ ) {
        return $session_obj;
    }
    
    return $session_obj->param(@_);
}


sub header {
    my $self = shift;

    my $session = $self->session();
    my $cookie = $self->cookie($session->name, $session->id);

    return $self->SUPER::header(-cookie=>$cookie, @_);
}




1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

CGIS - Session enabled version of CGI.pm

=head1 SYNOPSIS

    use CGIS;
    
    $cgi = new CGIS;

    # use $cgi the same way you use CGI.pm, in addition:

    # storing data in the session:
    $cgi->session("full_name", "Sherzod Ruzmetov");

    # reading data off the session
    $full_name = $cgi->session("full_name");

    # If no arguments passed to session(), it returns CGI::Session driver 
    # object:
    $session = $cgi->session();

=head1 DESCRIPTION

CGIS is a simple, session-enabled extension for Lincoln Stein's L<CGI|CGI>.
Instead of loading CGI, you load CGIS, and use it the way you have been using
CGI, without any exceptions. 

In addition, CGIS provides C<session()> method, to support persistent session
management accross subsequent HTTP requests, and partially overrides header()
method to ensure proper HTTP headers are sent out with valid session data (cookies).

CGIS requires CGI::Session installed properly. Uses B<$CGITempFile::TMPDIRECTORY> as the default location for storing session files.
This variable is defined in Lincoln Stein's L<CGI>. You can hardcode this value
to point to some other location.

=head1 EXAMPLES

=head2 SENDING THE SESSION COOKIE

In session management enabled sites, you most likely
send proper session cookie to the user's browser at each request.
Instead of doing it manual, simply call CGIS's header() method, 
as you would that of CGI.pm's:

    print $cgi->header();

And you are guaranteed that proper cookie's sent out to the user's
computer.

=head2 STORING DATA IN THE SESSION
    
    # store user's name in the session for later use:
    $cgi->session("full_name", "Sherzod Ruzmetov");

    # store user's email for later:
    $cgi->session("email", 'sherzodr@cpan.org');

=head2 READING DATA OFF THE SESSION

    my $full_name = $cgi->session("full_name");
    my $email     = $cgi->param('email');
    print qq~<a href="mailto:$email">$full_name</a>~;

=head2 GETTING CGI::Session OBJECT

For further performing more sophisticated oprations, you may need to
get underlying CGI::Session object directly. To do this, simply call session()
with no arguments:

    $session = $cgi->session();

    # now ref($session) == 'CGI::Session::File';

    # set expiration ticker:
    $session->expire("+10m");

    # delete the session for good:
    $session->delete();

For more tricks, consult with L<CGI::Session|CGI::Session> manual.

=head1 AUTHOR

Sherzod B. Ruzmetov E<lt>sherzodr@cpan.orgE<gt>

=head1 COPYRIGHT

This library is free software. You can modify and/or distribute it
under the same terms as Perl itself.

=head1 SEE ALSO

L<CGI::Session>, L<CGI>

=cut
