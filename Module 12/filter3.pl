open(MAG, $ARGV[0]) || die "Cannot open <$ARGV[0]> for input: [$@]";
@LINES = <MAG>;

$ct = 0;

foreach my $line (@LINES) {
  ($e, $n, $mag, $el ) = split " ", $line;
  if (($n > 4264550 && $n < 4264650) && ($e>480260 && $e <480480)) {
  	$ct++;
  	print stderr "$e $n $mag $el\n";
     
  }
  else {
  	 print "$e $n $mag $el\n";
  }
}
print stderr "Removed $ct lines\n";
