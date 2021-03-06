###################################################################################
# PERL script for calculating and plotting a gravity anomaly based on excess mass calculation
# Edit values between the START and STOP comment lines
#
##### README ########
# First: Edit values for projection conversion, 
# then run script, 
# this will transform your data file from lat/lon format to UTM format.

# Second: Edit values for map boundaries in UTM coordinates (see output from first run)
# then run script again,,
# this will produce a map in UTM coordinates.

# Third: edit your gravity threshhold value to map the selected gravity anomaly
# then run script again,
# this will produce a map of the selected anomaly
#
# Fourth: edit map annotations to reflect new map and gravity values
# then run script again,
# this will produce your final map
#
# This script outputs:
# 1) an annotated map and 
# 2) an overlay.png file, used by the overlay.kml file
#    which can be opened in google earth
################################################################################### 
use File::Basename;
 
# Check for data file on command line 
# and exit if not data file specified.
my $scriptname = $0;

if (($#ARGV +1) != 1) {
  my $Usage = qq(Usage: perl $scriptname <data file name>);
  print qq($Usage\n);
  exit;
}
printf qq(\n--INPUTS--\n);
# Input file name from command line
my $in = $ARGV[0];
printf qq(Input file: $in\n);
my ($filename, $directories, $suffix) = fileparse($in, qr/\.[^.]*/);
#print "$filename, $directories, $suffix\n";

# Output filename
my $out = qq($filename.utm);
printf qq(Output file: $out\n);

#####################################################################
# START: EDIT Values for projection conversion (i.e. replace ? with value)
#####################################################################
# Datum of input file (eg: WGS84 or NAD83 or NAD27)
my $datum = qq(WGS84);
printf qq(Datum: $datum\n);

# Projection for transformed data (eg: latlon or utm)
my $to_proj = qq(utm);
printf qq(Original projection: $to_proj\n);

# Projection of input file (eg: latlon or utm)
my $from_proj = qq(latlon);
printf qq(Final projection: $from_proj\n);

# Which hemisphere (eg: south or north)
my $hemi = qq(north);
printf qq(Hemisphere: $hemi\n);

# Which UTM zone (an integer between 1 and 60)
my $zone = qq(10);
printf qq(UTM zone: $zone\n);

#############################################
# Change map values to UTM meters
##############################################
# West map boundary
my $west = 599887.13;
printf qq(West boundary (m): $west\n);

# East map boundary
my $east = 625025.61;
printf qq(East boundary (m): $east\n);

# South map boundary
my $south = 4595441.54;
printf qq(South boundary (m): $south\n);

# North map boundary
my $north = 4616686.82;
printf qq(North boundary (m): $north\n);

##############################################
# Adjust gravity values
##############################################
# makecpt (color scale)
# Minimum gravity value 
$min = -175;
printf qq(MIN gravity value: $min\n);

# Maximum gravity value 
$max = -135;
printf qq(MAX gravity value: $max\n);

my $gravity_threshold = -162;
printf qq(Chosen gravity threshold: $gravity_threshold\n);

##############################################
# Adjust map annotations and scale
##############################################
# Tick interval
# Annotate tick markings.
$tick_int = 10000;
printf qq(Tick interval (m): $tick_int\n);

# Map scale = 1:2000000
$map_scale = 250000;
printf qq(Map scale: 1:$map_scale\n);

# Number of values per color interval (binned)
$cint = 1;
printf qq(Color interval: $cint\n);

# Scale bar annotation interval (10 x's the color interval)
# Increase if numbers overlap; decrease if too few labels 
$scale_anot_int = $cint*5;
printf qq(Scale bar annotation interval: $scale_anot_int\nNote: );
printf qq(Increase color interval if numbers overlap; decrease if too few labels\n\n);

# Grid spacing for the map data 
# Be careful, about units! Could be degrees or meters. 
# Now, Units = meters
my $spacing = "1000";
printf qq(Map grid spacing (m): $spacing\n\n);
######################################################
# STOP EDITING HERE
######################################################

printf qq(\nProcessing ....\n\n);
# Use proj4 (cs2cs) to change x,y,z coordinates from longitude, latitude to UTM
$hemi = ($hemi =~ m/south/) ? qq(+south) : "";  
my $params = qq(+proj=$from_proj +datum=$datum +to +proj=$to_proj +zone=$zone $hemi +datum=$datum);
print qq(cs2cs $params $in > $out\n);
`cs2cs $params $in > $out`;

# Use GMT to grid UTM data
print qq(\ngmtinfo:);
system qq(gmtinfo $out);

my $xyz_file = "$out.xyz";

# blockmedian - filter to block average (x,y,z) data by L1 norm
`gmt blockmean $out -R$west/$east/$south/$north -I$spacing >surf.in`;

# surface - adjustable tension continuous curvature surface gridding algorithm
`gmt surface surf.in -I$spacing -R -Gsurf.grd`;

# grd2xyz - Converting grid file(s) to ASCII XYZ format
`gmt grd2xyz surf.grd > $xyz_file`;

# Output file
my $map = qq($out.eps);
$overlay = qq(overlay.eps);

# Not necessary to edit. This generates the correct code for the tick placement.
$tick = qq(a).$tick_int.qq(f).$tick_int/2;

# Name of GMT color table
$color_file = qq(haxby);

# psscale
# X Position of scale bar (from left side) 
$xpos = 4.5;
# Y Position of scale bar (from bottom)
$ypos = -1.2;
# Length of scale bar
$len = 8;
# Width of scale bar
$width = .2;
# Orientation of scale bar (h = horizontal, v = verticle)
$orient = qq(h);
# Data units
$units = 'mGal';

# Not necessary to edit. This generates the correct code for the tick placement.
$scale_str = qq(a).qq($scale_anot_int);

`gmt makecpt -C$color_file -T$min/$max/$cint > map.cpt`;
`gmt psbasemap --MAP_FRAME_TYPE=plain --FONT_ANNOT_PRIMARY=8p -Jx1:$map_scale -R -X1i -Y1i -Bx$tick -By$tick -BWSne -K > $map`;
`gmt grdimage surf.grd -J -Cmap.cpt -E300  -K -O >> $map`;
`gmt grdimage surf.grd -J -Cmap.cpt -E300 -P > $overlay`;
`gmt grdcontour surf.grd -R -J -L$min/$max -A- -Cmap.cpt -Wthinnest,50 -O -K >> $map`;
`gmt psxy $in -R -J -Sp -Wthinnest,250 -O -K >> $map`;
`gmt psscale --FONT_TITLE=8p --FONT_LABEL=7p --FONT_ANNOT_PRIMARY=7p -D$xpos/$ypos/$len/$width$orient -Cmap.cpt -B$scale_str/:$units: -O >> $map`;
`gmt ps2raster $map -A -P -Tg`;
`gmt ps2raster $overlay -A -P -Tg`;
`rm *.eps surf.* *.cpt`;
################################

# Now calculate the excess mass
# Open the data file 
open IN, qq(<$xyz_file) or die qq(cannot open $xyz_file: $!\n);

my $total = 0;
my $count = 0;
my $anomaly = 0;

#Read in each line from input file
while (<IN>) {

  # Split line into values, split at space
  ($east, $north, $gravity, $elev) = split (" "); 
  
  #Subtract threshold from all gravity values
  $anomaly = $gravity - $gravity_threshold;
  
  # Screen new gravity values and sum those that are positive
   if ($anomaly > 0) {
    $total = $total + $anomaly;
    $count = $count + 1;
  }
  
}
# Convert to kg 
$total = $total/1e5;

#Calculate total excess mass
$xcess_mass = (1.0/(2.0 * 3.14159 * 6.67e-11)) * $total * $spacing * $spacing;
printf qq(\nExcess mass = %.2e kg (based on %d gravity values)\n\n), $xcess_mass, $count;
print qq(Finished!\n);
printf qq(IF ERRORS OCCUR: check the INPUTS at the top of the run for a list of your input values and modify input values in the excess_mass.pl file!\n);
