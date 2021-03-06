# histogram.pl
# This script plots a histogram using the gmt command pshistogram.
# The output plot fileplot file will be an image .png file having the same name 
# as the data file but with a .histogram.png extension 
# (also an .esp file that can be edited in adobe illustrator).
# Run this script twice. The first run will show the x,y plot boundaries for you. Edit the
# script as directed below.
# For example: pshistogram: min/max values for plot are :	-182.88	-62.97	0	1405

$xannot = 'a';
$yannot = 'a';

############################
#EDIT these VALUES to FIT your DATA
#minimum data value
$min = -261.83;
#maximum data value
$max = -155.31;
#maximum frequency of binned data values
$count = 720;
#measurement unit of data
$unit = qq(mGal);
#data column in input file (cols numbers start with 0)
$col = 2;
#histogram bin width
$bin_width = 10;
############################

$xannot .= $bin_width*2;
$yannot .= $count/10;
$xannot .= 'f';
$in = $ARGV[0];
print STDERR qq(Input File = $in\n);
$out = qq($in.histogram.eps);
print STDERR qq(Output File = $out\n);
`gmt pshistogram --ANNOT_FONT_SIZE_PRIMARY=12 --FONT_LABEL=14 $in -X1i -Y1i -R$min/$max/0/$count -JX4i -W10 -Lthinner -i$col -B$xannot$bin_width:'$unit':/$yannot:'Frequency':/WS -G200 -V -P > $out`;
`gmt ps2raster $out -A -P -Tg`;
`rm *.eps`;
