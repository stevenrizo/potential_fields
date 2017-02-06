#Performs low-pass filter of a profile using 
#fast Fourier transform
#length of dataset, $N$, must be 2^N, where N is an integer
# 128, 512,1024, etc. 
use POSIX;
use Math::FFT;
  my $PI = 3.1415926539;
  my $sample_spacing = 1; #map distance between samples
  my $long_wave_cut=10000;  #long wavelength ramp filter bound
  my $short_wave_cut=200;  #short wavelength ramp filter bound
  my ($series);

   
open (IN, "<$ARGV[0]") || die ("Cannot open $ARGV[0]: $!");
@MyMagneticDATA = <IN>;

foreach $line (@MyMagneticDATA) {
$N++;
#this is the columns in the USGS NEIC datafile
($x, $series->[$N]) = split " ", $line;

  }
@out_data=low_pass_filter ($z, $N, $sample_spacing, $long_wave_cut, $short_wave_cut);
for ($i=0; $i<$N; $i++)
  { 
     $profile_distance = $i*$sample_spacing;
     print "$profile_distance $series->[$i] $out_data[$i]\n ";
  
  }


sub low_pass_filter ($$$$$)
{
  
  my( $z, $N, $sample_spacing, $long_wave, $short_wave) = @_; 
  my $i, $k, $k1, $k2, $filter;
  my $fft = new Math::FFT($series);
  my $coeff = $fft->rdft();

$k2 = floor(($N*$sample_spacing)/$long_wave);
$k1 = floor(($N*$sample_spacing)/$short_wave);


for ($k=1; $k<= $N/2; $k++)
  {
if ($k<$k2) {$filter = 1;}
elsif ($k>=$k1){$filter = 0;}
else {$filter = 1.0 - (($k)-($k2))/(($k1) - ($k2));}
#print "$k $k1 $k2 $filter\n";

    $i++;
   
    $C_[$i] = $filter;

    $i++;
   
    $C_[$i] = $filter;

  }

  for ($i=0; $i<$N; $i++)
  { 
       $$coeff[$i]=$$coeff[$i]*$C_[$i];
  }


  my $filtered= $fft->invrdft($coeff);    
 for ($i=0; $i<$N; $i++)
  { 
   $out[$i]=$$filtered[$i]; 
  }
  return @out;
}

