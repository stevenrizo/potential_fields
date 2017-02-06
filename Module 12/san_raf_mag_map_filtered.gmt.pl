

$in = "san_raf_mag_filtered.dat";
$out = "san_raf_mag_map_filtered.eps";

$plugL = "./geology/plug1.xyz";
$condL = "./geology/plug1_base.xyz";
$condS = "./geology/plug2_base.xyz";
$sill = "./geology/sill_contact.xyz";

$west = 479500;
$east = 480900;
$south = 4264100;
$north = 4266000;

$color_file = "haxby";
$min_value = -200;
$max_value = 600;
$cint = 20;

# grdcontour
$anot_int = 100;
$contours = 50;

# psscale
$xpos = 12.5;
$ypos = 8.4;
$len = 8;
$width = .25;
$orient = "v";
$scale_anot_int = 50;

system "gmt surface $in -I5 -Gsurf.grd -R$west/$east/$south/$north -V";
system "makecpt -C$color_file -T$min_value/$max_value/$cint -V > map.cpt";

system "grdimage surf.grd -Jx1:12000 -Cmap.cpt -Ba400f50:'':/a200f50:'':/WSne -K -V > $out";
system "grdcontour surf.grd -R -Jx -C$contours -W0.25p,100 -O -K >> $out";
system "gmt psxy  $in -R -Jx -Sp -W0.5p,255 -O -K -V >> $out";
system "gmt psxy  $condL -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $condS -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $plugL -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $sill -R -Jx -Sc.02i -W1p -O -K -V >> $out";

system "psscale -D$xpos/$ypos/$len/$width$orient -Cmap.cpt -B$scale_anot_int:'Magnetic Anomaly':/:nT: -O -V >> $out";

system "ps2raster $out -A -P -Tg";
system "rm $out";

