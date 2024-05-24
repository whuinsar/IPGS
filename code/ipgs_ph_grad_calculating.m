function []=ipgs_ph_grad_calculating(diff_list,format,scale,step,m_az,n_rg,ifg_number,ph_grad_dir) 
%%
% ipgs_ph_grad_calculating: calculate the phase gradient for given directions and steps
%
% ################### Input ###################
% diff_list:         interferogram list
% format:            format of interferogram data
% scale:             multiplying scale when using gamma software to process phase, so divide by scale here
% directions:        direction required for gradient calculation
% step:              set the step size on the gradient calculation
% m_az:              number of rows in azimuth (Interferogram)      
% n_rg:              number of columns in range(Interferogram)  
% ifg_number:        the number of interferogram data
% ph_grad_dir:       the file name to save the gradient results
% 
% ################### Output ##################
% the output gradient stacking results in each direction are saved in ph_grad_dir
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%% calculate phase gradient
disp('################################################');
disp('########### Calculate phase gradient ###########');
disp('################################################');

grad_east = zeros(m_az,n_rg);
grad_north = zeros(m_az,n_rg);
grad_northeast = zeros(m_az,n_rg);
grad_southeast = zeros(m_az,n_rg);

for i = 1 : ifg_number
    tic;
    diff_info = diff_list(i).name(1:17);
    disp(['processing ifg_',num2str(i),': ',diff_info]);
    difffile = [diff_list(i).folder filesep diff_list(i).name];
    diff_tmp=freadbkj(difffile,m_az,format,'b');
    if  isreal(diff_tmp(1))
        diff_tmp = exp(1i.*diff_tmp./scale); % only for 'short'
    end
  
    grad_east_tmp = circshift(diff_tmp,-step,2).*conj(circshift(diff_tmp,step,2));
    grad_diff_east=angle(grad_east_tmp);
    clear grad_east_tmp;

    grad_north_tmp = circshift(diff_tmp,-step,1).*conj(circshift(diff_tmp,step,1));
    grad_diff_north=angle(grad_north_tmp);
    clear grad_north_tmp;

    grad_northeast_tmp = circshift(diff_tmp,[-step step]).*conj(circshift(diff_tmp,[step -step]));
    grad_diff_northeast=angle(grad_northeast_tmp);
    clear grad_northeast_tmp;

    grad_southeast_tmp = circshift(diff_tmp,[step step]).*conj(circshift(diff_tmp,[-step -step]));
    grad_diff_southeast=angle(grad_southeast_tmp);
    clear grad_southeast_tmp;

    grad_east = grad_east + grad_diff_east;
    grad_north = grad_north + grad_diff_north;
    grad_northeast = grad_northeast + grad_diff_northeast;
    grad_southeast = grad_southeast + grad_diff_southeast;
    clear diff_tmp diff_tmp_padded;
    clear grad_diff*;
    toc; 
end
 
mkdir(ph_grad_dir);
cd(ph_grad_dir);
savename = strcat('ph_grad_','step_',num2str(step));
save(savename,'grad_east','grad_north','grad_northeast','grad_southeast');

