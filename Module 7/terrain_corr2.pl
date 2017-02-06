use strict;
use warnings;
use constant PI    => 4 * atan2(1, 1);
# Gravitational constant
# Units of Gravity: kg m^3 s^-1
use constant G => 6.67384e-11;
# Degrees to radians conversion factor
use constant DEG2RAD => 0.017453293;


my %Param;
my $args = @ARGV;
if ($args < 1) {
  print STDERR "USAGE:
    perl <filename>.pl <configuration file> > <output file>n\n";
  exit;
}
my $conf = $ARGV[0];
print STDERR "\nOpening configuration file: $conf\n\n";
open CONF, "< $conf" or die "Can't open $conf : $!";

while(<CONF>) {
  if (/^$/ or /^#/) { next; }
  (my $key, my $value) = split "=",$_;
  chomp($value);
  $Param{$key} = $value;
  print STDERR "$key=$Param{$key}\n";
}

#Units of Density: kg m^-3
our $D = $Param{DENSITY};

my $dem_file = $Param{DEM_FILE};
print STDERR "\nOpening DEM: $dem_file\n";
open DEM, "< $dem_file" or die "Can't open $dem_file : $!";
my @data;
my @Dem;
my $nrows = 0;
while (<DEM>) {
	if ($nrows > $Param{HEADER_LINES}) {
		@data = split " ", $_;
		push @Dem, [ @data ];
	}
	$nrows++;
}
close DEM;
my $ncols = @data;
print STDERR "Number of Columns: $ncols, Number of Rows: $nrows\n";
#$nrows -=1;
#$ncols -=1;
my $Dem_south = $Param{DEM_SOUTH};
my $Dem_north = $Param{DEM_NORTH};
my $Dem_east = $Param{DEM_EAST};
my $Dem_west = $Param{DEM_WEST};
print STDERR "NW Corner of DEM (x,y): $Dem_west, $Dem_north\n";
my $deg_int = $Param{DEGREE_INTERVAL};
my $Grid_spacing = $Param{GRID_SPACING};
our $dist_int = $Param{DISTANCE_INTERVAL};
my $skip = $Param{SKIP_INTERVAL};
my $theta_int = $deg_int * DEG2RAD;
my $row;
my $col;

my $data_file = $Param{GRAVITY_DATA_FILE};
print STDERR "Opening data file: $data_file\n\n";
open DATA, "< $data_file" or die "Can't open $data_file : $!";

while (<DATA>) { # Do for each gravity station
	(my $east, my $north, my $g, my $elev ) = split (" ");
	# example gravity location: 629554.30	4592415.53 -148.41 1378.11
	#my $east = $Grid_spacing * $ncols /2 + $Dem_west;
	#my $north = $Grid_spacing * $nrows/2 + $Dem_south;
	#my $east = 629554.30;
	#my $north = 4592415.53;
	#$my $elev = 1378.11;
	#print STDERR "East=$east, North=$north, Elev=$elev\n";
	
	# Find the row and column of the gravity station 
	$col = int(($east - $Dem_west)/$Grid_spacing);
	$row = $nrows - int(($north - $Dem_south)/$Grid_spacing) -1;
    # Get elevation of the gravity station
    if ($col < 0 || $col >= $ncols ) { last;} #print STDERR "Out of range0: Col =$col\n";
    if ($row < 0 || $row >= $nrows) { last;} #print STDERR "Out of range0: Row =$row\n";
    my $h0 = $Dem[$row][$col];
    
    print STDERR "Grid location of Gravity Station: East=$east(Col=$col) North=$north(Row=$row) ELEV(dem)/(stn) = $h0/$elev(m)\n";
    # Find inner and outer distance - from the gravity station - of radial sector
    # Skip over an area right around the station. The first inner starts here.
    #Calculate FIRST inner loop grid point
   
    my $inner_d = my $outer_d = $skip;
    my $total_tc = 0;
    my $total_tc2 = 0;
    my $ctr_end = 360/$deg_int;
    #print "$ctr_end\n";
    #print "$theta_int\n";
    
    my $nl = 0;
    # Do until the line extends beyond the bondary of the map
    # Loop starts with the inner distance
    LOOP: while ($col > 0 && $row > 0 && $col < $ncols && $row < $nrows && $inner_d < 167000) {
    	# my $terr_corr = 0;
    	my $terr_corr2 = 0;
    	my $theta = 0;
    	# Calculate the outer distance    	    	   	
    	$outer_d = $inner_d + $dist_int;
    	my $inner_x; my $outer_x; my $inner_y; my $outer_y; my $outer_h; my $inner_h;
    	# Loop starts with 
    	# For each prism around the gravity station
    	PRISM: for (my $ctr = 0; $ctr < $ctr_end; $ctr++, $theta += $theta_int) {
    		 
    		 # Calculate the x,y coordinate of the INNER ring around the gravity station 		
    		#print STDERR "Counter = $ctr (theta=$theta)\n";
    		my $d_x = $inner_d * sin($theta);
    		my $d_y = $inner_d * cos($theta);
    		$inner_x = $east + $d_x;
    		$inner_y = $north + $d_y;
    		# Find the row and column of the INNER grid point
			$col = int(($inner_x - $Dem_west)/$Grid_spacing);
			$row = $nrows - int(($inner_y - $Dem_south)/$Grid_spacing) -1;
			#print STDERR "Inner: [$row][$col]\n";
			# If prism falls off map, stop this ring of calculations
			if ($col < 0 || $col >= $ncols ) { last LOOP;} # print STDERR "Out of range1: Col =$col\n";
    		if ($row < 0 || $row >= $nrows ) { last LOOP;} # print STDERR "Out of range1: Row =$row\n";
    		# Get elevation of INNER grid point
    		$inner_h = $Dem[$row][$col];
    		#printf STDERR "INNER = %0.2f(m): x0=%.1f y0=%.1f  h0=%.1f\n",$inner_d, $inner_x,  $inner_y, $inner_h;
    		#my $x2k = $inner_x/1000;
    		#my $y2k = $inner_y/1000;
    		#print "$x2k $y2k\n";
    		
    		# Calculate the x,y coordinate of the OUTER ring around the gravity station
    		$d_x = $outer_d * sin($theta);
    		$d_y = $outer_d * cos($theta);
    		$outer_x = $inner_x + $d_x;
    		$outer_y = $inner_y + $d_y;  
    		# Find the row and column of the OUTER grid point
			$col = int(($outer_x - $Dem_west)/$Grid_spacing);
			$row = $nrows - int(($outer_y - $Dem_south)/$Grid_spacing)-1;
			#print STDERR "Outer: [$row][$col]\n";
    		# If prism falls off map, stop this ring of calculations
    		if ($col < 0 || $col >= $ncols) { last LOOP;} # print STDERR "Out of range2: Col =$col\n";
    		if ($row < 0 || $row >= $nrows ) { last LOOP;} # print STDERR "Out of range2: Row =$row\n";
    		# Get elevation of OUTER grid point
   			$outer_h = $Dem[$row][$col];
   			
   			#printf STDERR " OUTER: %0.2f(m): x1=%.1f; y1=%.1f h1=%.1f\n",$outer_d, $outer_x,  $outer_y, $outer_h;
    		#$x2k = $outer_x/1000;
    		#$y2k = $outer_y/1000;
    		#print "$x2k $y2k\n";
    		
    		#if (defined($outer_h) && defined($inner_h)  ) {
    		if ($outer_h != -9999 && $inner_h != -9999) {
    		#Calculate: Accumulate terrain correction for this ring
    		#(my $slope, my $profile) = &slope_profile($outer_h, $inner_h, $outer_d, $inner_d);
    		#if ($slope != 0 || $profile != 0) {
    			#print STDERR "slope = $slope; k=$profile\n";
    		#}
    		#(my $p, my $q2) = &p_q2($slope, $profile, $h0);
    		#$terr_corr += &tc($slope, $h0, $outer_d, $inner_d, $p, $q2, $theta_int);
    		my $h_avg = &avg_h($outer_h, $inner_h);
    		my $h_rel = &rel_h($h0, $h_avg);
    		$terr_corr2 += &tc2($inner_d, $outer_d, $h_rel, $theta_int);
    		}
    	}
    	#print STDERR "Correction = $terr_corr\n";
    	#print STDERR "Correction = $terr_corr2\n";
    	#print STDERR "$nl Loop(s) completed !\n\n";
    	# Ring complete, accumulate total terrain correction	
    	#$total_tc += 	$terr_corr;
    	$total_tc2 += 	$terr_corr2;
    	
    	# Set new inner loop to be the current outer loop
    	$inner_d = $outer_d;
    	$nl++;
	} # End of distance
	print STDERR "Last Loop (outer distance = $outer_d)!\n";
    
   	#$total_tc *= 1e5;
   	$total_tc2 *= 1e5;
	#print STDERR "$east\t$north\tTerrain Correction = $total_tc\n";
	print STDERR "$east\t$north\tTerrain Correction = $total_tc2\n\n";
	print "$east\t$north\t$g\t$h0\t$total_tc2\n";
} # End while more gravity stations
print STDERR "Finished!\n";

sub avg_h{
	my $outer = $_[0];
	my $inner = $_[1];
	my $avg = ($outer - $inner)/2 + $inner;
	return $avg;
}      
 
sub rel_h{
	my $h_meter = $_[0];
	my $avg = $_[1];
	my $h = $avg - $h_meter;
	return $h;
}
sub tc2{
	my $inner = $_[0];
	my $outer = $_[1];
	my $h = $_[2];
	my $theta = $_[3];
	my $h2 = $h**2;
	my $tc = ($theta/2*PI) * G *$D * ($outer - $inner + sqrt($inner**2 + $h2) - sqrt($outer**2 + $h2));
	return $tc;
}
       
sub slope_profile { #outer_h, inner_h, outer_d, inner_d
	my $h1 = $_[0];
	my $h0 = $_[1];
	my $a1 = $_[2];
	my $a0 = $_[3];
	my $slop = ($h1-$h0)/($a1-$a0);
	my $prof = ($a1*$h0 - $a0*$h1) / ($a1 - $a0);
	return ($slop, $prof);
}

sub p_q2 { # slope, profile, station_h
	my $slope = $_[0];
	my $prof = $_[1];
	my $h0 = $_[2];
	my $temp_p = ($slope * ($prof - $h0)) / ($slope**2 + 1);
	my $q_temp = ($prof - $h0)**2 / ($slope**2 + 1)**2;
	return ($temp_p, $q_temp);
}

sub tc { # slope, station_h, outer_d, inner_d, p, q2, theta
		my $slope = $_[0];
		my $h0 = $_[1];
		my $a1 = $_[2];
		my $a0 = $_[3];
		my $p_temp = $_[4];
		my $q_squared = $_[5];
		my $theta = $_[6];
		
		my $temp0 = $theta * G * $D;
		my $temp1 = ($a1 + $p_temp)**2;
		my $temp2 = ($a0 + $p_temp)**2;
		my $temp3 = $h0**2;
		my $temp4 =  $a1**2 + $temp3;
		my $temp5 = $a0**2 + $temp3;
		my $temp6 = (sqrt($temp1 + $q_squared) + $a1 + $p_temp ) / (sqrt($temp2 + $q_squared) + $a0 + $p_temp);
		
		my $terrCorr = ($temp0 / ( sqrt($slope**2 +1) ) ) *
								( (sqrt($temp1 + $q_squared) - sqrt($temp2 + $q_squared) ) - $p_temp * log($temp6) ) 
								- ($temp0 * ( sqrt($temp4) - sqrt($temp5) ) );
		
	return $terrCorr;
}
    	
