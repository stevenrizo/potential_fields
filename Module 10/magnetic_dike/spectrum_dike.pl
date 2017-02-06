#Performs upward continuation of a profile using 
#fast Fourier transform
#length of dataset, $N$, must be 2^N, where N is an integer
# 128, 512,1024, etc. 

use Math::FFT;
  
open (IN, "<$ARGV[0]") || die ("Cannot open $ARGV[0]: $!");
@MyMagneticDATA = <IN>;

foreach $line (@MyMagneticDATA) {
$N++;
#this is the columns in the USGS NEIC datafile
($x, $series->[$N]) = split " ", $line;

  }
 
  my $fft = new Math::FFT($series);
  my $spectrum = $fft->spctrm;
 
 for (my $k=0; $k<$N/2; $k++) {
print "$k $spectrum->[$k]\n";
}


