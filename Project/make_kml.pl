# make_kml.pl
# This file makes a kml file (to upload to google earth)
# The input file should be a text file with data values separated by one or more spaces.
# This kml file requires longitude, latitude, elevation values
# To run the script type: perl <filename>.pl <datafile>
# The output kml file will have the same name as the datafile with a .kml extension
# The kml file requires an icon file (icon47.png) in the same directory as the script. 
# Another icon file could be used, Just change the icon file name in the script (below).
$output = "$ARGV[0].kml";
open (OUT, ">$output")  || die "Can't open $output: $!\n";

print OUT "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print OUT "<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n";
print OUT "<Document>\n";
# Notice that the icon file (icon47.png) should be in the same directory as the script.
print OUT "<Style id=\"circle\"><IconStyle><scale>0.5</scale><Icon><href>icon47.png</href></Icon></IconStyle></Style>\n";

while (<>) {
	#chomp();
	(@col) = split " ";
	if ($col[0] =~ m/^#/) {next;}
	# Make sure the column #'s reflect the columns with
	# Longitude, Latitude, Elevation data values.
	$lon = $col[0];
	$lat = $col[1];
	$elev = $col[3];
	print OUT "<Placemark>\n"; 
	print OUT "<styleUrl>#circle</styleUrl>\n";
	print OUT "<Point><coordinates>$lon,$lat,$elev</coordinates></Point>\n";
	print OUT "</Placemark>\n";
}
print OUT "</Document>\n";
print OUT "</kml>\n";

