function [ph_grad_map]=ipgs_map(datain,in_low_high,out_low_high,gamma)
%%
% ipgs_map: map the phase gradient values to enghance the deformation signals
%           and final phase gradient values are between 0 and 1
%
% ################### Input ###################
% datain:          gradient result after filtering
% in_low_high:     function (imadjust) parameters:  [low_in high_in] 
% out_low_high:    function (imadjust) parameters:  [low_out high_out]
% gamma:           function (imadjust) parameters:  gamma
% "help imadjust" to learn the function 
% ################### Output ##################
% ph_grad_map:     gradient stacking result after mapping
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%% mapping
%
disp('#########################################################');
disp('### map gradient result to enghance deformation signals###');
disp('#########################################################');

datain2=mat2gray(datain); % covert to [0 1]
ph_grad_map=imadjust(datain2,in_low_high,out_low_high,gamma); % adjust image intensity

end
