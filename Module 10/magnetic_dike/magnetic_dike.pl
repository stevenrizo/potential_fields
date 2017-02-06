
use Math::Trig;

$inc = 69;
$dec = 90;
$J = 500;
$depth = 30;
$hw = 5;
$dip = 170;

$PI = 3.14159;
$N = 1024;
for ($x= -512; $x<512; $x++) {
$k++;
$noise = 6* cos(9*$k*$PI/$N) + 1 * sin(12*$k*$PI/$N) + 2* cos(15*$k*$PI/$N) + 4 * sin(32*$k*$PI/$N) + 1* cos(17*$k*$PI/$N) + 5* rand();
$anomaly= dike_anomaly($x, $inc, $dec, $depth, $hw, $dip, $J) + $noise;
print "$x $anomaly\n";
}

#/*******************************************************
#*  Calculates the magnetic anomaly expected from  *
#*  a magnetized dike                                   *
#*                                                      *
#* Abstract                                             *
#*     This code uses the method originally proposed    *
#*  by Talwani and Heirtzler (1964) and re-implmented   *
#*  by Ku and Sharp (1983, Geophysics vol 48, p 754-774)*
#*  to calculate the magnetic anomaly associated with a *
#*  thin dike, dipping, magnetized dike. The magnetic   *
#*  anomaly is calculated along a profile perpendicular *
#*  to the dike.                                        *
#*                                                      * 
#*  variables can be altered as described below         *
#*  including: dike strike relative to magnetic north   *
#*  dike dip, dike depth, dike half-width,              *
#*  inclination of vector of magnetization, and         *
#*  intensity of magnetization                          *
#*                                                      *  
#*  The code outputs x, total field magnetic anomaly,   *
#*  horizontal component of magnetic anomaly, and       *
#*  vertical component of magnetic anomaly.             *
#*                                                      *
#*  This code has been tested using data found in       *
#*  Gay (1961, Standard curves for interpreation        *
#*  of aeromagnetic anomalies over long tabluar bodies  *
#*  Geophysics 28(2), 512-548.)                         *
#*                                                      *
#*  Written by C.B. Connor in May, 1996                 *
#*              Div. 20                                 *
#*              Southwest Res. Inst.                    *
#*              6220 Culebra Rd                         *
#*              San Antonio, TX 78238                   *
#*              210-522-6649                            *
#*              cconnor@swri.edu                        *
#/******************************************************/

sub dike_anomaly ($$$$$$$)

#  
# 
#    // this function calculates the magnetic anomaly and returns
#    // the value of the total magnetic field for a passed value x


{
  
        my ($x, $inclvec, $decvec, $depth, $halfwidth, $dipangle, $Jintensity) = @_; 


    
#    /** where inclvec -  is the inclination of the vector of magnetization
#	in degrees, positive downward (degrees)
#
#	decvec =  is the strike of the dike wrt declination (degrees)
#	of the vector of magnetization
#
#	depth - depth to the top of the dike (meters)
#
#	halfwidth = 1/2 the thickness of the dike (meters)
#
#	dipangle = the dip of the dike (degrees) dip_angle
#	is the dip of the dike, dip_angle should vary from 0 to 180,
#	with values less than 90 in the direction of magnetization and
#	values greater than 90 dipping away from the 
#	direction of the magnetization vector, j, 90.0 is a vertical dike
#
#	Jintensity - intensity of magnetization of the dike (nt) divide
#	by 400 * pi to obtain amp/m.

	my $jx;
	my $jz,  $a,  $b;
	my $T, $vmag, $hmag, $radchange;
	my $ia, $theta, $kount;
	my $ivec,$dvec,$dipa;

	$radchange = 3.14159/180.0;

	#change degrees to radians
	$ivec = $inclvec * $radchange;
	$dvec = $decvec * $radchange;
	$dipa = $dipangle * $radchange;
	
	#alpha == 0 results in undefined angle ia 
	if ($dvec == 0.0) {$dvec = 0.001};
	
	# ia is the component of the inclination of the 
	#   vector of magnetization in the direction of x 
	$ia = atan2(tan($ivec), sin($dvec));
	
#	theta is the angle between the dipping 
#	   dike and the inclination of the vector of 
#	   magnetization projected in the x direction
	$theta = $dipa - $ia; 
	
#	compute the components of magnetization wrt theta
	$jx = $Jintensity*sin($theta);
 	$jz = $Jintensity*cos($theta);
	 
	 
#	/** calculate the total, horizontal, and vertical
#          magnetic field at points along the profile */

	$a = -2.0*$halfwidth*($jx*sin($ivec) + $jz*cos($ivec)*sin($dvec));
	$b = 2.0*$halfwidth*(-$jx*cos($ivec)*sin($dvec) + $jz*sin($ivec));
	
	$T  = ($a*$x + $b*$depth)/($x*$x + $depth*$depth);
	$hmag = -2*$halfwidth*($jx*$depth + $jz*$x)/($x*$x+$depth*$depth);
	$vmag = 2*$halfwidth*($jz*$depth - $jx*$x)/($x*$x+$depth*$depth);
	
	return $T;	
    
}
