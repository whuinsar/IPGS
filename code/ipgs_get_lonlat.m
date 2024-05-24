function [sar_lon,sar_lat]=ipgs_get_lonlat(sar_width,sar_len,lookup_table,lat_ul,lon_ul,lat_post,lon_post)
%%
% ipgs_getlonlat:  calculate lon and lat for sar image by using lookup table
%
% ################### Input ###################
% sar_width:       number of columns in range(Interferogram)
% sar_len:         number of rows in azimuth (Interferogram)
% lookup_table:    lookup_table matrix obtained by '*.lt_fine'
% lat_ul:          the latitude of the upper left corner of the DEM corresponding to the SAR image
% lon_ul:          the longitude of the upper left corner of the DEM corresponding to the SAR image
% lat_post:        the resolution of the dem in the latitude direction （decimal degrees） 
% lon_post:        the resolution of the dem in the longitude direction （decimal degrees）
% ################### Output ###################
% sar_lon:         longitude corresponding to gradient result
% sar_lat:         latitude corresponding to  gradient result
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%% ipgs_getlonlat
disp('################################################');
disp('######## get lonlat using lookup table #########');
disp('################################################');
%%
dem_col=lookup_table(:,1:2:end);
dem_row=lookup_table(:,2:2:end);

dem_len=size(dem_col,1);
dem_width=size(dem_col,2);

[sar_col,sar_row] = meshgrid(0:1:sar_width-1,0:1:sar_len-1);

%% get lat
disp('calculate lat:');
tic
row_tmp=[0:1:dem_len-1].';  
dem_lat=repmat(lat_ul,dem_len,1)+row_tmp.*lat_post;
dem_latgrid=repmat(dem_lat,1,dem_width);  

sar_lat = griddata(dem_col(:),dem_row(:),dem_latgrid(:),sar_col(:),sar_row(:),'linear');
sar_lat = reshape(sar_lat,sar_len,sar_width);
toc

clear row_tmp dem_lat dem_latgrid;

%% get lon
disp('calculate lon:');
tic
col_tmp=0:1:dem_width-1;  
dem_lon=repmat(lon_ul,1,dem_width)+col_tmp.*lon_post;
dem_longrid=repmat(dem_lon,dem_len,1);  

sar_lon = griddata(dem_col(:),dem_row(:),dem_longrid(:),sar_col(:),sar_row(:),'linear');
sar_lon = reshape(sar_lon,sar_len,sar_width);
toc

clear col_tmp dem_lon dem_longrid;

end
