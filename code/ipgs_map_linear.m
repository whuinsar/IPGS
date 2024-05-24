function [ph_grad_map]=ipgs_map_linear(datain,out_low_high)
%%
% ipgs_map:  map the phase gradient values to enghance the deformation signals
%            and final phase gradient values are between 0 and 1
%
% ################### Input ###################
% datain:          gradient result after filtering
% out_low_high:    function parameters:  [low_out high_out]
%
% ################### Output ##################
% ph_grad_map:     gradient stacking result after mapping
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%%
ymin = out_low_high(1,1);
ymax = out_low_high(1,2);
xmin = min(datain(:));
xmax  = max(datain(:));
scale = (ymax - ymin)/(xmax - xmin);

ph_grad_map =  ymin + scale.*(datain-xmin);

end

