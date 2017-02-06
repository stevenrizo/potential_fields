#Performs upward continuation of a profile using 
#fast Fourier transform
#length of dataset, $N$, must be 2^N, where N is an integer
# 128, 512,1024, etc. 

#Usage: perl spectrum.pl inputdatafilename > spectrum.out

#Note: you have to have the Math::FFT module for this
#program to work. Google Math::FFT and PERL
use Math::FFT;
 
#open the data file containing the magnetic profile
# 
open (IN, "<$ARGV[0]") || die ("Cannot open $ARGV[0]: $!");
@MyMagneticDATA = <IN>;

foreach $line (@MyMagneticDATA) {
$N++;
#the datafile contains the x coordinate (e.g., distance North)
# and the magnetic value, separated by white space
($x, $series->[$N]) = split " ", $line;

  }

#use the fft module to calculate the forward transform 
  my $fft = new Math::FFT($series);

#calculate the power spectrum
  my $spectrum = $fft->spctrm;

#print out the result
 for (my $k=0; $k<$N/2; $k++) {
print "$k $spectrum->[$k]\n";
}


