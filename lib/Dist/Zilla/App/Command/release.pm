use strict;
use warnings;
package Dist::Zilla::App::Command::release;
# ABSTRACT: release your dist to the CPAN

use Dist::Zilla::App -command;

=head1 SYNOPSIS

  dzil release

  dzil release --trial

This command is a very, very thin wrapper around the
C<L<release|Dist::Zilla/release>> method on the Dist::Zilla object.  It will
build, archive, and release your distribution using your Releaser plugins.  The
only option, C<--trial>, will cause it to build a trial build.

=cut

sub abstract { 'release your dist' }

sub opt_spec {
  [ 'trial' => 'build a trial release that PAUSE will not index' ],
  [ 'jobs|j=i' => 'number of parallel test jobs to run' ],
}

sub execute {
  my ($self, $opt, $arg) = @_;

  my $zilla;
  {
    # isolate changes to RELEASE_STATUS to zilla construction
    local $ENV{RELEASE_STATUS} = $ENV{RELEASE_STATUS};
    $ENV{RELEASE_STATUS} = 'testing' if $opt->trial;
    $zilla = $self->zilla;
  }

  local $ENV{HARNESS_OPTIONS} = join ':', split(':', $ENV{HARNESS_OPTIONS} // ''), 'j'.$opt->jobs if $opt->jobs;
  $self->zilla->release;
}

1;
