%%
%################################################
% parameters setting of ipgs processing
%################################################
%%
%## needed file of phase processing
% ./diff/*.diff.ml.sm              % interferogram file 
% ./*.rmli.par                     % parameter file of the intensity map      
% ./EQA.dem                        % the dem file corresponding to the sar image
% ./EQA.dem_par                    % the parameter file of dem
% ./lt_fine                        % lookup table
% ./gmt_scripts                    % code file for getting kml results of phase phgrad stacking

%## output files
% ph_grad_all                      % store the result of phase phase gradient stacking in every direction
% patches_gmt_kml_ipgs             % store kml files about gradient result 
% 'lonlat.mat'                     % longitude and latitude matrix corresponding to gradient result

code_dir= '/media/insar-320/Elements/zdx/IPGS_code_WHU-InSAR/code';   % the path of ipgs codes（select the code path according to your own situation）
workdir = pwd;                     % print the full filename of the current working directory.
cd(workdir);
mkdir ph_grad_all;                 % create a folder to place the result of gradient stacking in each direction
ph_grad_dir = [workdir filesep 'ph_grad_all'];  
code_dir = [code_dir filesep 'gmt_scripts'];             % the path of 'gmt_scripts' 

%%
savename = 'ph_grad_map';          % the name of the final output ipgs results
filter = 'sm';                     % filterring in gamma
ext = '.diff.ml.sm';               % interferogram suffix
dataformat = 'cpxfloat32';         % 'short/int16' or 'cpxfloat32' of interferogram
scale = 10000;                     % original phase/scale  
%{
When obtaining the interferogram, to save space, 
we multiply the interference phase value by 10000 and save it as a short integer. 
Therefore, divide the original phase by 10,000 and then perform the gradient calculation.
%}      

%## choose differential interferograms
diff_list1=dir([workdir filesep 'diff' filesep '*' ext]);    % interferogram list                     
%## choose temporal_baseline to get high coherence 
choose_month = 'y';
if choose_month == 'y'
    month1 = 6;                    % "month1" and "month2" represent the name of month (june and september)
    month2 = 9;
    diff_list= ipgs_choose_month(diff_list1,month1,month2);  % for example: interferograms from month1 to month2 will be discarded if the number of interferograms is enough (more than 400)
elseif choose_month == 'n'
    diff_list = diff_list1;
end

%% 
%################################################
% key parameters of ipgs method   
%################################################

step = 3;                          % step length for calculating spatial phase gradient,       
filter_wins=[7 7];                 % windows of median filter
directions={'grad_east','grad_north','grad_northeast','grad_southeast'};

%## mapping the phase gradient values after filtering
in_low_high=[0.14 0.8];            % mapping values between low_in and high_in map 
out_low_high=[0.001 1];            % to values between low_out and high_out, a small low value (e.g. 0.001) is required for 'ipgs_getlonlat2.m' 
gamma=0.8;                         % gamma specifies the shape of the curve 

%## choose a linear or nonlinear mapping mode
choose_linear = 'n';               % 'no_linear' or 'linear' of mapping,we recommend nonlinear mapping to further remove some noise 
%%   
% use patch strategy to output gradient results if the interferogram is too large
% The line and width of each patch should be less than 5000.        
paz=1; 
prg=1;
overlap_az=1;
overlap_rg=1;

%%
%################################################
% get the parameters of the dem 
%################################################
cmdstr = ['echo `ls  *.dem`'];  
[status,result] = system(cmdstr);
tmp=strsplit(result);
demfile=char(tmp(1));                    % dem data file

cmdstr = ['echo `ls  *.dem_par`'];  
[status,result] = system(cmdstr);
tmp=strsplit(result);
demparfile=char(tmp(1));                 % dem parameter file

cmdstr = ['echo `ls  *lt_fine`']; 
[status,result] = system(cmdstr);
tmp=strsplit(result);
ltfile=char(tmp(1));                     % geocoding lookup table

command_str = ['echo `grep width: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
dem_width=str2double(cell2mat(tmp(2)));  % the width of dem 

command_str = ['echo `grep nlines: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
dem_len=str2double(cell2mat(tmp(2)));    % the len of dem

command_str = ['echo `grep corner_lat: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
lat_ul=str2double(cell2mat(tmp(2)));     % the corner_lat of dem

command_str = ['echo `grep corner_lon: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
lon_ul=str2double(cell2mat(tmp(2)));     % the corner_lon of dem

command_str = ['echo `grep post_lat: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
lat_post=str2double(cell2mat(tmp(2)));   % the latitude of the upper left corner of the dem 

command_str = ['echo `grep post_lon: ',char(demparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
lon_post=str2double(cell2mat(tmp(2)));   % the longitude of the upper left corner of the dem

%%
%################################################
% get the parameters of the sar image
%################################################
cmdstr = ['echo `ls  *.rmli.par`'];  
[status,result] = system(cmdstr);
tmp=strsplit(result);
sarparfile=char(tmp(1));                   % the parameter file of *.rmli.par

command_str = ['echo `grep range_samples: ',char(sarparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
n_rg=str2double(cell2mat(tmp(2)));         % number of columns in range(interferogram) 

command_str = ['echo `grep azimuth_lines: ',char(sarparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
m_az=str2double(cell2mat(tmp(2)));         % number of rows in azimuth (interferogram)

command_str = ['echo `grep range_looks: ',char(sarparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
ml_rg=str2double(cell2mat(tmp(2)));        % range_looks(interferogram) 

command_str = ['echo `grep azimuth_looks: ',char(sarparfile),'`'];
[status,result] = system(command_str);
tmp=strsplit(result);
ml_az=str2double(cell2mat(tmp(2)));        % azimuth_looks(interferogram)
ml_look = [num2str(ml_rg) num2str(ml_az)]; % the multi_looking of interferogram

%%
%############################################################
% save all parameters as a matrix: ph_grad_parms
%############################################################

savename2 = [ph_grad_dir,'/','ph_grad_step_',num2str(step)];     % the phase gradient stacking results of all direction
savename3 = [ph_grad_dir,'/','ph_grad_step_med_',num2str(step)]; % the phase gradient stacking results of all directions after filtering

save ph_grad_parms filter ext dataformat scale step filter_wins directions ...
     in_low_high out_low_high gamma choose_linear n_rg m_az ml_rg ml_look dem_len ...
     lat_post lon_post lat_ul lon_ul paz prg overlap_rg overlap_az ...
     diff_list sarparfile demfile demparfile ltfile ...
     code_dir workdir ph_grad_dir savename savename2 savename3; 

