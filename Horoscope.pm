package Date::Horoscope;

use Data::Dumper;
use Date::Manip;


use strict qw(vars subs);
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.01';

# year is irrelevant for our purposes

%Date::Horoscope::horoscope = (
	      'aries' => {
		  'position' => 1,
		  'start' => '3/21/93', 
		  'end'   => '4/20/93',
	      },
	      'taurus' => {
		  'position' => 2,
		  'start' => '4/21/93', 
		  'end'   => '5/20/93',
	      },
	      'gemini' => {
		  'position' => 3,
		  'start' => '5/21/93', 
		  'end'   => '6/21/93',
	      },
	      'cancer' => {
		  'position' => 4,
		  'start' => '6/22/93', 
		  'end'   => '7/22/93',
	      },
	      'leo' => {
		  'position' => 5,
		  'start' => '7/23/93', 
		  'end'   => '8/23/93',
	      },
	      'virgo' => {
		  'position' => 6,
		  'start' => '8/24/93', 
		  'end'   => '9/22/93',
	      },
	      'libra' => {
		  'position' => 7,
		  'start' => '9/23/93', 
		  'end'   => '10/22/93',
	      },
	      'scorpio' => {
		  'position' => 8,
		  'start' => '10/23/93', 
		  'end'   => '11/21/93',
	      },
	      'sagittarius' => {
		  'position' => 9,
		  'start' => '11/22/93', 
		  'end'   => '12/21/93',
	      },
	      'capricorn' => {
		  'position' => 10,
		  'start' => '12/22/93', 
		  'end'   => '1/19/93',
	      },
	      'aquarius' => {
		  'position' => 11,
		  'start' => '1/20/93', 
		  'end'   => '2/18/93',
	      },
	      'pisces' => {
		  'position' => 12,
		  'start' => '2/19/93', 
		  'end'   => '3/20/93',
	      }
	      );


# Preloaded methods go here.
sub day_month_logic {
    my ($M,$D)=@_;

    warn "day_month_logic: $M, $D";

    ($M  < 0)  &&              return -1;
    ($M  > 0)  &&              return  1;
    ($M == 0)  && ($D == 0) && return  0;
    ($M == 0)  && ($D  > 0) && return  1;
    ($M == 0)  && ($D  < 0) && return -1;
}

sub day_month_cmp {
    my ($A,$B,$C)=@_;

    warn Data::Dumper->Dump([$A, $B, $C], [ qw(A B C) ]);

    my (%month,%day);

    $month{A} = $A->{month} - $C->{month};
    $month{B} = $B->{month} - $C->{month};
    $day{A}   = $A->{day}   - $C->{day};
    $day{B}   = $B->{day}   - $C->{day};

    my $S = day_month_logic($month{A},$day{A});
    my $E = day_month_logic($month{B},$day{B});

    warn "S/E: $S/$E";
    ($S == -1) && ( ($E == 0) || ($E == 1) ) && return 1;
    ($S ==  0) &&   ($E == 1)                && return 1;
}

sub locate {
    my $input_date = $_[0];

    warn " input date: $input_date";

    for my $h (keys %Date::Horoscope::horoscope) {
	my $start = $Date::Horoscope::horoscope{$h}{start};
	my $end   = $Date::Horoscope::horoscope{$h}{end};
	
	warn "testing $h";

	my (%parse, %month, %day);

	my @d= (\$input_date, \$start, \$end);

# -----------------------------------------------------------------------
# The reason for this kruft:

# You cannot use symbolic references on my variables. I dont know why and
# I dont think it should be this way.

# If I used hard references then I wouldnt be able to bind the
# %month and %day references with the named used in the 
# symbolic reference
# -----------------------------------------------------------------------

	$month{input_date} = &UnixDate($input_date, '%f');
	  $day{input_date} = &UnixDate($input_date, '%e');
	$month{start}      = &UnixDate($start, '%f');
	  $day{start}      = &UnixDate($start, '%e');
	$month{end}        = &UnixDate($end, '%f');
	  $day{end}        = &UnixDate($end, '%e');


	warn Data::Dumper->Dump([$input_date,\%month],['input_date','month']);

	my $day_month_cmp = day_month_cmp
	     (
	      { month => $month{start},      day => $day{start}       },
	      { month => $month{end},        day => $day{end}         },
	      { month => $month{input_date}, day => $day{input_date}  }
	      );

	warn "day_month_cmp: $day_month_cmp";
	return $h if ($day_month_cmp);
	    
    }
}
    


# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Date::Horoscope - Date operations based on the horoscope calendar

=head1 SYNOPSIS

#!/usr/bin/perl

use Date::Horoscope;
use Date::Manip;

$date='1969-05-11';
$x='date';
 warn &UnixDate($$x, '%f');

print $Date::Horoscope::horoscope{Date::Horoscope::locate('1969-05-11')}->{position}, $/;


=head1 DESCRIPTION

This module was written to help with the zodiac processing for a site I was
contracting at. It returns either an all-lowercase zodiac based on a given
date. You can take this string and use it as a key to %horoscope to get a
position in the zodiac cycle.

=head1 API

=head2 locate

Provide any date parseable by Date::Manip and it turns an all-lowercase zodiac
name.

=head2 %horoscope

This hash contains the position, and start and end dates for a zodiac sign.
The zodiac starts with Aries as far as I know. Some idiot didn't think 
taurus was number 1.

=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut
