package Sys::CpuLoad;

# Copyright (c) 1999-2002 Clinton Wong. All rights reserved.
# This program is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself. 

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter AutoLoader DynaLoader);

@EXPORT = qw();
@EXPORT_OK = qw(load);
$VERSION = '0.02';

bootstrap Sys::CpuLoad $VERSION;

=head1 NAME

Sys::CpuLoad - a module to retrieve system load averages.

=head1 DESCRIPTION

This module retrieves the 1 minute, 5 minute, and 15 minute load average
of a machine.

=head1 SYNOPSIS

 use Sys::CpuLoad;
 print '1 min, 5 min, 15 min load average: ',
       join(',', CpuLoad::load()), "\n";

=head1 AUTHOR

 Clinton Wong
 Contact info:
 http://search.cpan.org/search?mode=author&query=CLINTDW

=head1 COPYRIGHT

 Copyright (c) 1999-2002 Clinton Wong. All rights reserved.
 This program is free software; you can redistribute it
 and/or modify it under the same terms as Perl itself.

=cut

use IO::File;

sub load {

  # handle bsd getloadavg()
  if (lc $^O =~ /bsd/) { return getbsdload() }

  # handle linux proc filesystem
  my $fh = new IO::File('/proc/loadavg', 'r');
  if (defined $fh) {
    my $line = <$fh>;
    $fh->close();
    if ($line =~ /^(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
      return ($1, $2, $3);
    }
  }
   
  $fh=new IO::File('/usr/bin/uptime|');
  if (defined $fh) {
    my $line = <$fh>;
    $fh->close();
    if ($line =~ /(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*$/) {
      return ($1, $2, $3);
    }
  }
    
  return (undef, undef, undef);
}

1;
__END__

