#PERL routine based on
#PROGRAM TO PRODUCE MICROGAL TIDE VALUES AT 10 MINUTE INTERVALS
#MODIFIED 14 FEB 1979 TO PROVIDE OPTIONAL PRINTOUT TO .01 MILLIGAL.
#MODIFIED DECEMBER 1983, JAN 1988, March 1998
#Dan Scheirer, Aug 2007: Tweaked to improve portability 
# (syntax fixes and preserve double-precision)
#Translated to PERL (2013) by Laura Connor
#
#This program returns the tidal acceleration used to correct gravity measurements.
#That is, it returns the UPWARD component of gravitational 
#acceleration due to the sun and moon. To correct gravity 
#measurements for tidal acceleration, the returned values are
#ADDED to the observed gravity measurement to correct for tide.
#************************************************************
# Check for data file on command line 
# and exit if not data file specified.
my $scriptname = $0;

if (($#ARGV +1) != 1) {
  my $Usage = "Usage: perl $scriptname <data file name> > <output file name>";
  print "$Usage\n";
  exit;
}
##############################################
#INPUTS: 
# Use an input file with the following format
# latitude minutes longitude minutes elevation year month day days

# latitude: degree part, South is negative, North is positive
# minutes; minutes part of latitude, always positive
# longitude: degree part, West is negative, East is positive
# minutes: minute part of longitude, always positive
# elevation: of obsevation point in meters
# year: YYYY, starting year
# month: MM, starting month
# day: DD, starting day
# days: number of days, from starting day, of gravity calculations due to earth tide
########################################################
# OUTPUTS:
# The program will output 2 columns of data
 # time mGals
 
# time format is:  YYYY-MM-DD-HH-MM (UTC)
# where YYYY is the year; MM is the month, DD is the day, HH is the hour, MM are the minutes past the hour (UTC)
# Redirect the output to a file instead of the screen using an   >   the redirect symbol  (as shown in the USAGE statement above)
###############################################################################

use Math::Trig;

my @DAYPM = (31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31.);
my @G;
# Double Precision numbers
my $CDEGTR = 1.7453292519943e-2;
my $CMINTR = 2.90888208666e-4;
my $CSECTR = 4.848136811e-6;
my $C0 = 3.84402e10;
my $C1 =1.495e13;
my $E =  0.05490;
my $RATIO = 0.074804;
my $OMEGA = 23.452 * $CDEGTR;
my $SMALLA = 6.37827e8;
my $AMU = 6.670e-8;
my $AMMOON = 7.3537e25;
my $AMSUN = 1.993e33;
my $PI2 = 6.2831853072;
my $SC1 = 1108411.2;
my $PC1 = 392515.94;
my $HC1 = 129602768.13;
my $ANC1 = 482912.63;
my $E11 = 1.675104e-2;
my $E12 = 4.180e-5;
my $E13 = 1.26e-7;
# Convert to milligals
my $MM = 1;
my $ARG5 = $OMEGA/2.;
my $ARG2 = 5.145 * $CDEGTR;
my $E_temp = $E**2;
my $APRIME = 1. / ($C0 * (1. - $E_temp));
my $SCON = 270. * $CDEGTR + 26. * $CMINTR + 14.72 * $CSECTR;
my $SSCON = 1336. * $PI2 + $SC1 * $CSECTR;
my $PCON = 334. * $CDEGTR + 19. * $CMINTR + 40.87 * $CSECTR;
my $PPCON = 11. * $PI2 + $PC1 * $CSECTR;
my $HCON = 279. * $CDEGTR + 41. * $CMINTR + 48.04 * $CSECTR;
my $ANCON = 259. * $CDEGTR + 10. * $CMINTR + 57.12 * $CSECTR;
my $AANCON = 5. * $PI2 + $ANC1 * $CSECTR;
my $P1CON = 281. * $CDEGTR + 13. * $CMINTR + 15. * $CSECTR;
my $CON1 = sin($OMEGA);
my $CON2 = cos($OMEGA);
my $CON3 = sin($ARG2);
my $CON4 = cos($ARG2);
my $CON5 = $APRIME * $E;
my $CON6 = $CON5 * $E;
my $ARG30 = $CON4 * $CON2;
my $ARG31 = $CON1 * $CON3;
my $CON7 = $CON5 * $RATIO * 15.0/ 8.;
my $Ratio_temp = $RATIO**2;
my $CON8 = $APRIME * $Ratio_temp;
my $CON9 = 5. * $E_temp / 4.;
my $CON10 = 15. * $RATIO * $E / 4.;
my $CON11 = 11. * $Ratio_temp / 8.;
# The elevation of the location in meters
my $SELEV;
#the Latitude in DEGREES and DECIMAL MINUTES (NORTH POSITIVE)
my $SLATD, my $SLATM;
#Longitude in DEGREES and DECIMAL MINUTES (WEST POSITIVE)
my $SLONGD, my $SLONGM;
#Starting date-YEAR MONTH DAY-(Example 2000 02 29)
my $DATEY, my $DATEM, my $DATED;
#TIME ZONE(Hours WEST of Greenwich PST=8,PDT=MST=7)
my $TIMEH = 0.;
#Number of days for which tide is to be calculated
my $DAYS;
my $NTOTAL;
#Generating tide correction values in MILLIGALS', 1' at 10 minute intervals')
while (<>) {
	if ($_ =~ m/^#/) {next;}
	($SLATD, $SLATM,$long_deg, $SLONGM, $SELEV, $DATEY,$DATEM,$DATED, $DAYS) = split " ";
}
$SLONGD = -$long_deg;
$LATD = int($SLATD);
$LONGD = int($SLONGD);
#print "$LATD,$LONGD  ";
if ($DATEY < 100.) {$DATEY += 2e3;}
$IDATEM = int($DATEM);
$IDATED = int($DATED);
$NDATEY = int($DATEY);
#print "$DATEY-$IDATEM-$IDATED ";
$IDATEY = int($DATEY - 1900);
#print "$IDATEY\n";  
my $MINUTE = 0.;
# 10 minute intervals
my $FINT = 10;
$NTOTAL = int($DAYS * 1440 / $FINT);
#print "$LATD, $SLATM,$LONGD, $SLONGM, $SELEV, $IDATEY,$IDATEM,$IDATED, $DAYS\n";
#print "TOTAL = $NTOTAL\n";
my $TIMEM = 0.;
my $totaln = $NTOTAL;
my $i = 0;
for ($i = 1; $i <= $totaln; $i++) {
	if ($i  == 1) { goto L75; }
	$MINUTE += $FINT;
     $DAYS5 = $MINUTE / 1440.;
     # print "[$i]MIN: $MINUTE $DAYS5 ";
      goto L350;
L75:$DAYS2 = 0.;
     # The sign transfer function SIGN(X,Y)
     # takes the sign of the second argument 
     # and puts it on the first argument, 
     # return ABS(X) if Y >= 0 and -ABS(X) if Y < 0. 
     $ALAMBD = $SLATD * $CDEGTR + sign($SLATM, $SLATD) * $CMINTR;
     my $sl_temp = $SLONGM / 60.;
     $ALONG = $SLONGD + sign($sl_temp, $SLONGD);
     $MONTH = int($DATEM);
     $IDAY = int($DATED);
     $pr_day = $IDAY;
     $IYEAR = int($DATEY - 1900);
     # This will always be zero ; we are using UTC time
     $IHOUR = int($TIMEH);
     $pr_hr = 0;
     $MINUTE = $TIMEM;
     $pr_mm = 0;
     #print "\n";
     #print "$IYEAR-$MONTH-$IDAY $IHOUR:$MINUTE\n";
# CALCULATE T (NUMBER OF JULIAN CENTURIES)
	my $j = 0;
	#print "\n";
	#print " [$j]:$DAYS2 ";
      for ($j = 1; $j <= 12; ++$j) {
      	$JS = $MONTH - $j;
      	if ($JS == 0) { goto L150; }
      	$DAYS2 += $DAYPM[$j - 1];
      	#print " [$j]:$DAYS2:[$DAYPM[$j - 1]] ";
      } # END for
      #print "\n";
L150:      $DAYS3 = $IDAY - 1.;
      $DAYS4 = $IHOUR / 24.;
      $DAYS5 = $MINUTE / 1440.;
      $DAYS1 = $IYEAR * 365.;
      $NYEAR = int($IYEAR / 4);
      $SJ = $IYEAR / 4. - $NYEAR;
      if ($SJ > 0) { goto L200; }
       	# IF(MONTH-2) 300,300,200
      if ( ($MONTH - 2 ) <= 0) {goto L300;}
      else {goto L200;}	
L200:	$DAYS6 = $NYEAR;
	  goto L350;
L300:	$DAYS6 = $NYEAR - 1.;
L350:#print "\nDAYS: $DAYS1 $DAYS2 $DAYS3 $DAYS4 $DAYS5 $DAYS6 ";
	  $STOR = $DAYS1 + $DAYS2 + $DAYS3 + $DAYS4 + $DAYS5 + $DAYS6 + 0.5;
      $T = $STOR / 36525.;
      $S = $SCON + ((0.0068 * $CSECTR * $T + 9.09 * $CSECTR) * $T + $SSCON) * $T;
      $P = $PCON + (((-0.045) * $CSECTR * $T - 37.24 * $CSECTR) * $T + $PPCON) * $T;
      $H = $HCON + (1.089 * $CSECTR * $T + $HC1 * $CSECTR) * $T;
      $AN = $ANCON + ((0.008 * $CSECTR * $T + 7.58 * $CSECTR) * $T - $AANCON) * $T;
      $P1 = $P1CON + ((0.012 * $CSECTR * $T + 1.63 * $CSECTR) * $T + 6189.03 * $CSECTR) * $T;
      $E1 = $E11 - ($E12 + $E13 * $T) * $T;
      my $AL_temp = (sin($ALAMBD))**2;
      $ARG1 = 1. / (1. + 0.006738 * $AL_temp);
      $CAPC = sqrt($ARG1);
      $RADIUS = $CAPC * $SMALLA + $ELEV;
      my $E1_temp = $E1**2;
      $APRIM1 = 1. / ($C1 * (1. - $E1_temp));
      $SMINP = $S - $P;
      $S2HP = $S - 2. * $H + $P;
      $SMINH = $S - $H;
      $HMINP1 = $H - $P1;
      $SMINP2 = 2. * $SMINP;
      $SMINH2 = 2. * $SMINH;
      $DISTEM = 1. / $C0 + $CON5 * cos($SMINP) + $CON6 * cos($SMINP2) + $CON7 * cos($S2HP) + $CON8 * cos($SMINH2);
      $DISTES = 1. / $C1 + $APRIM1 * $E1 * cos($HMINP1);
      $TZERO = $IHOUR + $MINUTE / 60.;
      $SMALLT = (15. * ($TZERO - 12.) - $ALONG) * $CDEGTR;
      $CHI1 = $SMALLT + $H;
      $ALSUN = $H + 2. * $E1 * sin($HMINP1);
      $ARG3 = $ARG30 - $ARG31 * cos($AN);
      $AI = acos($ARG3);
      $ARG4 = $CON3 * sin($AN) / sin($AI);
      $ANU = asin($ARG4);
      $CHI = $SMALLT + $H - $ANU;
      $SALPHA = $CON1 * sin($AN) / sin($AI);
      $CALPH1 = cos($AN) * cos($ANU) + sin($AN) * sin($ANU) * $CON2 + 1.;
      $ALPHA = 2. * atan2($SALPHA, $CALPH1);
      $XI = $AN - $ALPHA;
      $SIGMA = $S - $XI;
      $ALMOON = $SIGMA + 2. * $E * sin($SMINP) + $CON9 * sin($SMINP2) + $CON10 * sin($S2HP) + $CON11 * sin($SMINH2);
      $ARG6 = $ALSUN - $CHI1;
      $ARG7 = $ALSUN + $CHI1;
      my $cARG5_temp = cos($ARG5)**2;
      my $sARG5_temp  = sin($ARG5)**2;
      $CPHI = sin($ALAMBD) * sin($OMEGA) * sin($ALSUN) + cos($ALAMBD) * ($cARG5_temp * cos$ARG6 + $sARG5_temp * cos($ARG7));
      $ARG8 = $AI / 2.;
      $ARG9 = $ALMOON - $CHI;
      $ARG10 = $ALMOON + $CHI;
      my $cARG8_temp = cos($ARG8)**2;
      my $sARG8_temp = sin($ARG8)**2;
      $CTHETA = sin($ALAMBD) * sin($AI) * sin($ALMOON) + cos($ALAMBD) * ($cARG8_temp * cos($ARG9) + $sARG8_temp * cos($ARG10));
      $QR = 1e3;
      $DISTEM *= $QR;
      $DISTES *= $QR;
      my $ctheta2_tmp = $CTHETA**2;
      my $distem3_tmp = $DISTEM**3;
      my $qr3_tmp = $QR**3;
      my $qr4_tmp = $QR**4;
      my $radius2_tmp = $RADIUS**2;
      my $ctheta3_tmp = $CTHETA**3;
      my $distem4_tmp = $DISTEM**4;
      
      #GM=AMU*AMMOON*RADIUS*(3.d0*(CTHETA**2)-1.d0)*(DISTEM**3)/(QR**3)+3.d0*(AMU*AMMOON*(RADIUS**2)*(5.d0*(CTHETA**3)-3.d0*CTHETA))*(DISTEM**4)/(2.d0*QR**4)
      
      $GM = $AMU * $AMMOON * $RADIUS * (3. * $ctheta2_tmp - 1.) * $distem3_tmp / $qr3_tmp + 3. * ($AMU * $AMMOON * $radius2_tmp * (5.0 * $ctheta3_tmp - 3. * $CTHETA)) * $distem4_tmp / (2. * $qr4_tmp);
      $GM *= 1e3;
      my $cphi2_tmp = $CPHI**2;
      my $distes3_tmp = $DISTES**3;
      $GS = $AMU * $AMSUN * $RADIUS * (3. * $cphi2_tmp - 1.) * $distes3_tmp * 1e3 / $qr3_tmp;
      $GZERO = $GM + $GS;
      $G[$i - 1] = ($GZERO * 1160.) / 1e3;
      if ($pr_mm == 60) {
      	$pr_mm = 0;
      	$pr_hr++;
      }
      if ($pr_hr == 24) {
      	$pr_hr = 0;
      	$pr_day++;
      }
      
      my $str = "$DATEY"."-"."$DATEM"."-"."$pr_day"."-"."$pr_hr"."-"."$pr_mm";
      printf "%s %.4f\n", $str, $G[$i - 1];
      $pr_mm += $FINT;
	} #END  for (my $i = 1; $i <= $totaln; ++$i) {
    $NMIN = -143;
     --$IDATED;
   my $int_days = int($DAYS);
   my $k = 0;
   for ( $k = 1; $k <= $int_days; ++$k) {
      	++$IDATED;
      	if ($IDATED <= int($DAYPM[$IDATEM - 1] ) )  { goto L990; }
      	# If February
      	if (($IDATEM == 2)) { goto L910; }
L905: ++$IDATEM;
		$IDATED = 1;
      	if ($IDATEM <= 12) { goto L990; }
      	$IDATEM = 1;
      	++$NDATEY;
      	++$IDATEY;
        goto L990;
L910: if ($IDATED >= 30) { goto L905; }
      	if (($IDATEY / 4) << 2  == $IDATEY) { goto L990; }   
      	goto L905;   
L990: #$NMIN += 144;
  	    #$NMAX = $NMIN + 143;
	#for (my $z = $NMIN; $z <= $NMAX; ++$z ) {
		#printf "%s %.4f\n", $str, $G[$z-1];
  			#if (($z % 12) == 0) {print "\n";}
	#}
} # END for ( my $k = 1; $k <= $int_days); ++$k) { 
#########################
# FUNCTION sign()
# return ABS(X) if Y >= 0 and -ABS(X) if Y < 0
sub sign {
	my $ans = ($_[1] >= 0) ? abs($_[0]) : -abs($_[0]);
	#print "$_[0]  $_[1]  $ans\n";
	return $ans;
}
