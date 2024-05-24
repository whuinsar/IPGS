function []=ipgs_gmt_patches(lon,lat,ph_grad,paz,prg,overlap_rg,overlap_az,savename_pre)
%%
% ipgs_gmt_patches: set patches for gmt mapping and kml
%
% ################### Input ###################
% lon:              the longitude corresponding to the SAR image 
% lat:              the lattitude corresponding to the SAR image
% ph_grad           ipgs result
% paz               number of patches in sar azimuth
% prg               number of patches in sar range
% overlap_rg        the overlap between patches in range
% overlap_az        the overlap between patches in azimuth
% savename_pre      give a name to save the patche results
% ################### Out ######################
% the output patches results are saved in form of .xyz 
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%%
disp('################################################');
disp('## set patches for gmt mapping and kml ##');
disp('################################################');

[m_az n_rg] = size(ph_grad);

patches=ipgs_setpatches(m_az,n_rg,paz,prg,overlap_rg,overlap_az);

llfile = 'phgrad_patches.ll';
if exist(llfile,'file')
    delete(llfile);
end
fid=fopen(llfile,'w');

for j = 1:length(patches) 
    
    disp(['running on patch_',num2str(j)]);
    
    savename1 = [savename_pre,'_patch_az',num2str(patches(j).iaz),'_rg',num2str(patches(j).irg)];
    savename2 = [savename1,'.xyz'];

    start_az = patches(j).az_rg_overlap(1);
    end_az = patches(j).az_rg_overlap(2);
    start_rg = patches(j).az_rg_overlap(3);
    end_rg = patches(j).az_rg_overlap(4);
    lat_grid_local = lat(start_az:end_az,start_rg:end_rg);
    lon_grid_local = lon(start_az:end_az,start_rg:end_rg);
    ph_grad_local = ph_grad(start_az:end_az,start_rg:end_rg);


    tmp=[num2str(min(lon_grid_local(:))),',',num2str(max(lon_grid_local(:))),',',...
        num2str(min(lat_grid_local(:))),',',num2str(max(lat_grid_local(:))),',',savename1]; 
    fprintf(fid,'%s\n',tmp);
        
    llph=[lon_grid_local(:),lat_grid_local(:),ph_grad_local(:)];
    ix = isnan(llph(:,3));
    llph=double(llph(~ix,:));
    save(savename2,'llph','-ascii');
    
end

fclose(fid);

end
