package Sys::CpuLoad;

# Copyright (c) 1999 Clinton Wong. All rights reserved.
# This program is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself. 

use strict;
use vars qw($VERSION);
$VERSION = '0.01';

=head1 NAME

Sys::CpuLoad - a module to retrieve system load averages.

=head1 DESCRIPTION

This module retrieves the 1 minute, 5 minute, and 15 minute load average
of a machine.

=head1 SYNOPSIS

 use Sys::CpuLoad;
 print '1 min, 5 min, 15 min load average: ',
       join(',', CpuLoad::load()), "\n";

=head1 TO-DO

Support for systems without /proc/loadavg or /usr/bin/uptime by using
native system calls.  Ability to read CPU usage of individual CPUs on
multiprocessor machines.

=head1 AUTHOR

 Clinton Wong, clintdw@netcom.com

=head1 COPYRIGHT

 Copyright (c) 1999 Clinton Wong. All rights reserved.
 This program is free software; you can redistribute it
 and/or modify it under the same terms as Perl itself.

=cut

use IO::File;

sub load {

  # for OS's that don't have /proc/loadavg or /usr/bin/uptime, 
  # we'll have to re-visit this with OS specific calls.

  # first we'll try to look at /proc/loadavg.  If it doesn't exist,
  # we'll call /usr/bin/uptime.  Otherwise, return (undef, undef, undef).

  my ($avg1, $avg5, $avg15);
  my $fh = new IO::File('/proc/loadavg', 'r');
  if (defined $fh) {
    my $line = <$fh>;
    $fh->close();
    if ($line =~ /^(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
      ($avg1, $avg5, $avg15) = ($1, $2, $3);
    }
  } else {
    $fh=new IO::File('/usr/bin/uptime|');
    if (defined $fh) {
      my $line = <$fh>;
      $fh->close();
      if ($line =~ /(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*$/) {
        ($avg1, $avg5, $avg15) = ($1, $2, $3);
      } else {
        return (undef, undef, undef);
      } # ! -e /proc/loadavg and problems parsing output of /usr/bin/uptime
      
    } else  {
      return (undef, undef, undef);
    } # ! -e /proc/loadavg and /usr/bin/uptime failed!
  } # else try /usr/bin/uptime

  return ($avg1, $avg5, $avg15);
}

1;

