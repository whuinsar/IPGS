%%
%######################################################
% loading the parameters of phase gradient stacking 
%######################################################
%
%## copy 'ipgs_parms_set.m' into work directory and modify related parameter
if ~exist('ph_grad_parms.mat','file') 
    if exist('ipgs_parms_set.m','file') 
        ipgs_parms_set; 
    else
        error("no 'ph_grad_parms_set.m' in current dir");
    end
end
 
%## get related parameters 
ph_grad = load('ph_grad_parms.mat');
diff_list = ph_grad.diff_list;                 % interferogram list           
step = ph_grad.step;                           % set the step size on the gradient calculation        
dataformat = ph_grad.dataformat;               % format of interferogram data                   
m_az = ph_grad.m_az;                           % number of rows in azimuth (Interferogram)
n_rg = ph_grad.n_rg;                           % the number of interferogram data
filter_wins = ph_grad.filter_wins              % windows of median filte
scale = ph_grad.scale;                         % original phase/scale 
workdir = ph_grad.workdir;                     % the current working directory.
ph_grad_dir = ph_grad.ph_grad_dir;             % the file name to save the gradient results
savename =  ph_grad.savename;                  % the name of the final output ipgs results
savename2 = ph_grad.savename2;                 % the phase gradient stacking results of all direction
savename3 = ph_grad.savename3;                 % the phase gradient stacking results of all directions after filtering

%%
%## ipgs_phgrad_calculating: calculate the phase gradient for given directions and steps
%
if ~exist([savename2,'.mat'],'file')
    ifg_number = length(diff_list)
    ipgs_ph_grad_calculating(diff_list,dataformat,scale,step,m_az,n_rg,ifg_number,ph_grad_dir); 
    cd ..
end

%%
%## ipgs_filter: merging the gradient stacking results after filtering in each direction to obtain the phase gradient index  
%
if ~exist([savename3,'.mat'],'file')
    ph_grad_flt=ipgs_filter(step,filter_wins,ph_grad_dir,n_rg,m_az);
end
%## delete files generated during ipgs calculation
folder = ph_grad_dir;
rmdir(folder, 's');

%%
%## ipgs_map: mapping the phase gradient index to phase gradient metric ([0 1]),and enghance the deformation signals
%
choose_linear = ph_grad.choose_linear;
if ~exist([savename,'.mat'],'file')
    if choose_linear  == 'n'   
        ph_grad_map=ipgs_map(ph_grad_flt,in_low_high,out_low_high,gamma);
    elseif choose_linear == 'y'
        ph_grad_map=ipgs_map_linear(ph_grad_flt,out_low_high);
    end
    save(savename,'ph_grad_map');
    clear ph_grad_flt;      
end

%%
%## ipgs_get_lonlat: get lon and lat for sar image by using lookup table
%
disp('########get lonlat based on lookup table########');
demparfile = ph_grad.demparfile;          % dem parameter file
ltfile = ph_grad.ltfile;                  % geocoding lookup table
lat_ul = ph_grad.lat_ul;                  % the latitude of the upper left corner of the DEM corresponding to the SAR image
lon_ul = ph_grad.lon_ul;                  % the longitude of the upper left corner of the DEM corresponding to the SAR image
lat_post = ph_grad.lat_post;              % the resolution of the dem in the latitude direction （decimal degrees）
lon_post = ph_grad.lon_post;              % the resolution of the dem in the longitude direction （decimal degrees）
if ~exist(['lonlat.mat'],'file')
    lookup_table=freadbkj(ltfile,dem_len,'float32','b');
    [lon,lat]=ipgs_get_lonlat(n_rg,m_az,lookup_table,lat_ul,lon_ul,lat_post,lon_post);
    save lonlat lon lat;
end

%%
%## ipgs_gmt_patches: divide the mapped results into patches and save them in '.xyz' format
% 
paz = ph_grad.paz;                        % number of patches in sar azimuth
prg = ph_grad.prg;                        % number of patches in sar range
overlap_rg = ph_grad.overlap_rg;          % the overlap between patches in range
overlap_az = ph_grad.overlap_az;          % the overlap between patches in azimuth
load('lonlat.mat');

if ~exist('ph_grad_map','var')
    load(savename);
end

ph_grad_name = eval('ph_grad_map');

pdir1 = [workdir filesep 'patches_gmt_kml_ipgs'];
if ~exist(pdir1,'dir')
  mkdir(pdir1);
end
cd(pdir1);
ipgs_gmt_patches(lon,lat,ph_grad_name,paz,prg,overlap_rg,overlap_az,savename);
cd(workdir);

%%
%## copy related scripts for generating kml files
%
code_dir = ph_grad.code_dir;
copyfile([code_dir filesep 'gmt_phgrad_to_kml.csh'],pdir1);
copyfile([code_dir filesep 'gmt_image2kml.csh'],pdir1);
copyfile([code_dir filesep 'rainbow.cpt'],pdir1);

%%
%## display ipgs result (if the data is too large, show it carefully)
figure,
scatter(lon(:),lat(:),[],ph_grad_map(:),'.');colormap rainbow;colorbar,caxis([-1 1]);