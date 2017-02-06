#performs upward continuation of magnetic data

use Math::FFT;
  my $z = 100; #upward continuation height


open (IN, "dike.dat") || die "Can’t open dike.dat: $!\n";

$fileout = "upward.dat";

open (HANDOUT,">$fileout") || die "problems!: $!\n";

while (<IN>){ $line = $_;
@parse = split(" ", $line);

  my $fft = new Math::FFT($parse[2]);
  my $coeff = $fft->rdft();
  $upward = exp($coeff*$z);
  my $filtered= $fft->invrdft($upward);

print HANDOUT "$parse[1] $filtered";
}
