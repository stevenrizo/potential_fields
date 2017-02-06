use Geo::Proj4;
#####################################################################
# START: EDIT Values for projection conversion (i.e. replace ? with value)
#####################################################################
# Datum of input file (eg: WGS84 or NAD83 or NAD27)
my $datum = qq(WGS84);
printf qq(Datum: $datum\n);

# Projection of input file (eg: latlon or utm)
my $from_proj = qq(utm);
printf qq(Original projection: $from_proj\n);

# Which hemisphere (eg: south or north)
my $hemi = qq(north);
printf qq(Hemisphere: $hemi\n);

# Which UTM zone (an integer between 1 and 60)
my $zone = qq(10);
printf qq(UTM zone: $zone\n);

#############################################
# Edit map values ///
##############################################
# West map boundary
my $west = 499920;
printf qq(West boundary (m): $west\n);

# East map boundary
my $east = 667730;
printf qq(East boundary (m): $east\n);

# South map boundary
my $south = 4538900;
printf qq(South boundary (m): $south\n);

# North map boundary
my $north = 4762170;
printf qq(North boundary (m): $north\n);
######################################################
# STOP EDITING HERE
######################################################


my $proj1 = Geo::Proj4->new(proj => "$from_proj", datum => "$datum", zone => "$zone" )
	or die qq(parameter error: ). Geo::Proj4->error .qq(\n);
	
# Convert long / lat to utm 
($lat, $lon) = $proj1->inverse($west, $south);
printf qq(West: $lon\nSouth: $lat\n);

($lat, $lon) = $proj1->inverse($east, $north);
printf qq(East: $lon\nNorth: $lat\n\n);


#############################################
# Edit map values ///
##############################################
# West map boundary
my $west = -123;
printf qq(West boundary (m): $west\n);

# East map boundary
my $east = -121;
printf qq(East boundary (m): $east\n);

# South map boundary
my $south = 41;
printf qq(South boundary (m): $south\n);

# North map boundary
my $north = 43;
printf qq(North boundary (m): $north\n\n);
######################################################
# STOP EDITING HERE
######################################################


my $proj2 = Geo::Proj4->new(proj => "$from_proj", datum => "$datum", zone => "$zone" )
	or die qq(parameter error: ). Geo::Proj4->error .qq(\n);
	
# Convert utm to long / lat 
($w, $s) = $proj2->forward($south,$west);
printf qq(West: $w\nSouth: $s\n);

($e, $n) = $proj2->forward($north, $east);
printf qq(East: $e\nNorth: $n\n);
