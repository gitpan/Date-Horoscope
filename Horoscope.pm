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
$VERSION = '1.2';

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
		  'start' => '1/1/93',   # NOT TRUE BUT NECESSARY
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



# day_month_logic:
# -----------------------------------------------------------------------
# Return a one if the day/month combo is greater than the day/month combo
# it was subtracted from. Return 0 if equal and -1 if less.

sub day_month_logic {
    my ($M,$D)=@_;

    warn "day_month_logic: $M, $D";

    ($M  < 0)  &&              return -1;
    ($M  > 0)  &&              return  1;
    ($M == 0)  && ($D == 0) && return  0;
    ($M == 0)  && ($D  > 0) && return  1;
    ($M == 0)  && ($D  < 0) && return -1;
}


sub locate {
    my $input_date = $_[0];

    my %input_date;
    $input_date{month} = &UnixDate($input_date, '%m');
    $input_date{day}   = &UnixDate($input_date, '%d');    
    $input_date{year}  = 1993;

    return 'capricorn' if $input_date{month}=12 && $input_date{day} >=22 && $input_date{day} <=31;

    
    $input_date{new} = "$input_date{year}-$input_date{month}-$input_date{day}";
    $input_date{new} =~ s/\s+//g;

    my @sorted_keys = 
	sort {
	    $Date::Horoscope::horoscope{$a}{position} 
	    <=> 
	    $Date::Horoscope::horoscope{$b}{position}
	} (keys %Date::Horoscope::horoscope);


    # this returns something like 'taurus', 'sagittarius', etc.
    for my $h (@sorted_keys) {
        # start and end dates of this zodiac sign... year irrelevant
	my $start = &ParseDate($Date::Horoscope::horoscope{$h}{start}); 
	my $end   = &ParseDate($Date::Horoscope::horoscope{$h}{end});
	my $input = &ParseDate($input_date{new});

	my $S=&Date_Cmp($start,$input);
	my $E=&Date_Cmp($end,$input);

	warn sprintf("H: %s S: %d E: %d", $h, $S, $E);
	warn sprintf ("start: %s end: %s input: %s", $start, $end, $input);

	return $h if (
		      ((!$S) || (!$E)) ||
		      (($S < 0) && ($E > 0))
		      );
	    
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

print $Date::Horoscope::horoscope{$x}/;


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

=head1 OTHER

I cannot say how tickled I am that RCS changes by <scalar>Date code into
as RCS string for me.

=head1 AUTHOR

T.M. Brannon

=head1 SEE ALSO

perl(1).

=cut
