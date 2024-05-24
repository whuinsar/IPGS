function ph_grad_flt_all=ipgs_filter(step,filter_wins,phgrad_dir,n_rg,m_az) 
%%
% ipgs_filter: filter the phase stacking results in each direction
%
% ################### Input ###################
% step:            the step size on the gradient calculation
% filter_wins:     the window size of Median filter
% pdir_dir:        the file name to save the gradient results of medain filter 
% n_rg:            number of columns in range(interferogram) 
% m_az:            number of rows in azimuth (interferogram)
% ################### Output ##################
% ph_grad_flt_all: merging the gradient stacking results after filtering in each direction
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%% median filtering
disp('################################################');
disp('###Filtering phase gradients using Median Filter##');
disp('################################################');

allvar={'grad_east','grad_north','grad_northeast','grad_southeast'};
    
ph_grad_flt_all1 = zeros(size(m_az,n_rg));
ifg_number_dir = [phgrad_dir,'/'] 
savename1 = [ifg_number_dir ,'ph_grad_step_',num2str(step)];
savename3 = [ifg_number_dir ,'ph_grad_med_step_',num2str(step)];
for k = 1:length(allvar)
    var = cell2mat(allvar(k));
    tmp=load(savename1,var); 
    eval(['grad_tmp=tmp.',var,';']);
    grad_med_tmp = medfilt2(grad_tmp,filter_wins);
    eval([var,'_med=grad_med_tmp;']);
    ph_grad_flt_all1 = ph_grad_flt_all1 + grad_med_tmp.^2;
end
save(savename3,'grad_east_med','grad_north_med','grad_northeast_med','grad_southeast_med');
ph_grad_flt_all = sqrt(ph_grad_flt_all1/4);
%save('phgrad_flt_all','phgrad_flt_all');
end