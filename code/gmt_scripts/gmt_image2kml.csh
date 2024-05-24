#!/bin/csh -f

if ($#argv < 6)then
  echo "USAGE: gmt_image2kml.csh imagefile kmlfile ll_north ll_south ll_east ll_west"
  echo " created by DJ 23 Dec, 2019  "
  exit
else 
  set imagefile = $1
  set kmlfile = $2
  set ll_north = $3
  set ll_south = $4
  set ll_east = $5
  set ll_west = $6
endif

if (-e $kmlfile) then
  rm -f $kmlfile
endif


# output kml file
echo '<?xml version="1.0" encoding="UTF-8"?>' > $kmlfile
echo '<kml xmlns="http://earth.google.com/kml/2.1">' >> $kmlfile
echo "  <Document>" >> $kmlfile
echo "    <name>$kmlfile</name>" >> $kmlfile
echo "    <GroundOverlay>" >> $kmlfile
echo "      <name>$imagefile</name>" >> $kmlfile
echo "      <Icon>" >> $kmlfile
echo "        <href>$imagefile</href>" >> $kmlfile
echo "      </Icon>" >> $kmlfile
echo "      <LatLonBox>" >> $kmlfile
echo "        <north> $ll_north </north>" >> $kmlfile
echo "        <south> $ll_south </south>" >> $kmlfile
echo "        <east>  $ll_east </east>" >> $kmlfile
echo "        <west>  $ll_west </west>" >> $kmlfile
echo "      </LatLonBox>" >> $kmlfile
echo "    </GroundOverlay>" >> $kmlfile
echo "  </Document>" >> $kmlfile
echo "</kml>" >> $kmlfile
