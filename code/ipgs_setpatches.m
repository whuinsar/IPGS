function [patch]=ipgs_setpatches(m_az,n_rg,paz,prg,overlap_rg,overlap_az)
%
% ipgs_setpath:  get the size of each patch matrix
%
% ################### Input ###################
% n_rg:          number of columns in range(interferogram) 
% m_az:          number of rows in azimuth (interferogram)
% paz:           number of patches in sar azimuth
% prg:           number of patches in sar range
% overlap_rg:    the overlap between patches in range
% overlap_az:    the overlap between patches in azimuth
% ################### Output ##################
% patches:       the size of each patch matrix
%
% created  by Dongxiao Zhang  20220521
% modified by Jie Dong        20220815
%%
patch_width = floor(n_rg/prg); 
patch_height = floor(m_az/paz);

irg = 0;iaz =0;
j=1;

 while(iaz < paz )     
     iaz = iaz +1;    
     while(irg < prg)
         
         irg = irg + 1;
%          ip = ip + 1;
         start_rg1 = patch_width*(irg-1) + 1;
         start_rg = start_rg1 - overlap_rg;
         if(start_rg < 1)
             start_rg = 1;
         end
         end_rg1 = patch_width*(irg);
         end_rg = end_rg1 + overlap_rg;
         if (end_rg > n_rg)
             end_rg = n_rg;
         end
         
         % 方位向
         start_az1 = patch_height*(iaz-1) + 1;
         start_az = start_az1 - overlap_az;
         if(start_az < 1)
             start_az = 1;
         end
         end_az1 = patch_height*(iaz);
         end_az = end_az1 + overlap_az;
         if (end_az > m_az)
             end_az = m_az;
         end
         irg_name = num2str(irg);
         iaz_name = num2str(iaz);
         phi = strcat('ph','_az',iaz_name,'_rg',irg_name);
         
         patch(j).iaz=iaz;
         patch(j).irg=irg;
         patch(j).az_rg = [start_az1 end_az1 start_rg1 end_rg1];
         patch(j).az_rg_overlap = [start_az end_az start_rg end_rg];
         
         j=j+1;
         
     end
     irg = 0;    
 end
end