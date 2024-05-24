function diff_list_new= ipgs_choose_month(diff_list_raw,month1,month2)
%%
% ipgs_choose_month: discards part of the interferogram due to atmospheric and coherence effects
%
% ################### Input ###################
% diff_list_raw:   interferogram list
% month1:          "month1" represent the name of month
% month2:          "month2" represent the name of month
% ################### Output ##################
% diff_list_new:   interferogram list after removing interferograms from month1 to month2
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815

%%
j = 0;
for i= 1:length(diff_list_raw)
%     i;
    datestr_2 = diff_list_raw(i).name(10:17);
    datestr_1_month_str = diff_list_raw(i).name(5:6);
    
    datestr_1_month = str2num(datestr_1_month_str);
    datestr_2_month_str = diff_list_raw(i).name(14:15);
    datestr_2_month = str2num(datestr_2_month_str);
    datestr_1_ymd_str1 = diff_list_raw(i).name(1:8);
    ymd1 = datenum(datestr_1_ymd_str1,'yyyymmdd');
    
    datestr_1_ymd_str2 = diff_list_raw(i).name(10:17);
    ymd2 =datenum(datestr_1_ymd_str2,'yyyymmdd');
    
    
    if datestr_2_month < month1 || datestr_2_month > month2
        if datestr_1_month <= month1 || datestr_1_month >= month2 
           ymdd = abs(ymd2 -ymd1);
%            if ymdd > 12    
              j=j+1;
               diff_list1(j) = diff_list_raw(i);  
%            end
        end
    end
        
end

diff_list_new = diff_list1;

end
