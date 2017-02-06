$in = "san_raf_mag_filtered.dat";
$out = "san_raf_points_map_filtered.eps";

$plugL = "./geology/plug1.xyz";
$condL = "./geology/plug1_base.xyz";
$condS = "./geology/plug2_base.xyz";
$sill = "./geology/sill_contact.xyz";

#NLBM_conduit.F.wgs84z12.utm: N = 41165	<478881/481052>	<4264102/4266007>	<-1142.451/2470.655>	<1828/1872>
$west = 479500;
$east = 480900;
$south = 4264100;
$north = 4266000;

system "gmt psxy  $in -R$west/$east/$south/$north -Jx1:12000 -Sp -W0.5p,255 -Ba400f50:'':/a200f50:'':/WSne -V -K > $out";
system "gmt psxy  $condL -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $condS -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $plugL -R -Jx -N -Sc.02i -W1p -O -K -V >> $out";
system "gmt psxy  $sill -R -Jx -Sc.02i -W1p -O -V >> $out";

system "gmt ps2raster $out -A -P -Tg";
system "rm $out";
