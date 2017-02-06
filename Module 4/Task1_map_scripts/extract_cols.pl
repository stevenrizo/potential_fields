# extract_cols.pl
# This file extracts columns of data from a .csv file. Please feel free to edit (see below)
# To run this script type: perl <filename> <datafile>
# The output file will have the same base name as the datafile with a .parse.ll extension

$in = $ARGV[0];
print "Input File = $in\n";
$out = "$in.parse.ll";
print "Output File = $out\n";

open (OUT, ">$out")  || die "Can't open $out: $!\n";
while (<>) {
	chomp;
	(@col) = split ",";
	if ($col[0] =~ m/^#/) {next;}
	# Make sure the column numbers reflect
	# the data columns you want to export.
	print OUT "$col[10] $col[9] $col[8] $col[11]\n";
}
print "Done\n";_	
