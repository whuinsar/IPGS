#!/bin/csh -f
# 
# USAGE: generate image and link it to kml
# gmt-6.0.0
# 
# created by DJ 22 Dec, 2019


#######################################################################
#### basic parameters ####
# map info: name, format and width

set fileformat = PNG # must be PNG in upper case 
set mapwidth = 80c

set crange = "-1/1/0.1"
set post_lonlat = "0.7s+e/0.7s+e" # resolution

set cmap = rainbow1.cpt
gmt makecpt -C$cmap -Di -M --COLOR_BACKGROUND=105/0/0 --COLOR_FOREGROUND=126.08/0/0 -T$crange -Z > color2.cpt 

@ patches = 0
foreach line (`awk '{print $0}' phgrad_patches.ll`)
  @ patches = $patches + 1
  echo "processing patches:" $patches
  
  set west = `echo $line | awk -F"," '{print $1}'`
  set east = `echo $line | awk -F"," '{print $2}'`
  set south = `echo $line | awk -F"," '{print $3}'`
  set north = `echo $line | awk -F"," '{print $4}'`
  set filename = `echo $line | awk -F"," '{print $5}'`
  
  set mid_lon = `echo "scale=4; ($west + $east)/2" | bc `
  set mid_lat = `echo "scale=4; ($south + $north)/2" | bc `

  set J = "-JM$mid_lon/$mid_lat/$mapwidth"
  set R = "-R$west/$east/$south/$north"
  
#### map plot without annotion and ticks ####
  gmt begin $filename $fileformat
#    gmt makecpt -C$cmap -Di -Iz -M -T$crange -Z
#   gmt makecpt -Ccolor2.cpt  -Di -M -T$crange -Z
    gmt xyz2grd $filename.xyz -G$filename.nc $R -I$post_lonlat
    gmt grdimage $filename.nc $J $R -Q -Ccolor2.cpt # Q makes image trasparent
  gmt end

#### link image to kml ####
  set fileformat_low = `echo $fileformat | tr A-Z a-z`
  echo $fileformat_low
  gmt_image2kml.csh "$filename.$fileformat_low" "$filename.kml" $north $south $east $west

end

#rm *.xyz
#rm *.nc
#rm color2.cpt


