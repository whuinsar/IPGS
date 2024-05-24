# **Improved phase gradient stacking for landslide detection**

## **The IPGS method**

The improved phase gradient stacking (IPGS) first calculates the multi-directional phase gradients of the interferogram at certain step between pixels, then stacks these gradients in temporal dimension, and finally merges the stacked gradients from each direction to obtain complete deformation boundaries and improve the identification of deformation targets.

The spatial gradient of wrapped interferometric phases is sensitive to the local deformation signal. Stacking the phase gradient in time can not only weaken the random noise, especially the atmospheric delays but also enhance local deformation signals. It also avoids complicated unwrapping and massive time series analysis. It provides an effective tool for large-scale, rapid, and reliable detection of geological disasters.

## **The MATLAB programs**

The input data for the IPGS program are all generated from GAMMA software, and the program runs on MATLAB software under the Ubuntu environment.

### input files  

* ./diff/*.diff.ml.sm &nbsp;&nbsp;&nbsp;% interferogram file  
*  ./*.rmli.par &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp % parameter file of the intensity map        
*  ./EQA.dem &nbsp;&nbsp;&nbsp; % the dem file corresponding to the sar image  
*  ./EQA.dem_par &nbsp;&nbsp;&nbsp; % the parameter file of dem  
*  ./lt_fine &nbsp;&nbsp;&nbsp; % lookup table  
*  ./gmt_scripts &nbsp;&nbsp;&nbsp; % code file for getting kml results of phase phgrad stacking  

%### output files 
% patches_gmt_kml_ipgs        % store kml files about gradient result 
% ph_grad_map.mat           % matrix file containing latitude, longitude and gradient stacking result

%### process steps
Step1:  run MATLAB under Ubuntu and add the code files to the environment variable path and modify the parameters in “ipgs_parms_set.m” file to obtain the corresponding parameter information.
Step2:  run the main program (“ipgs_processing_main.m”) to get the IPGS result.
Step3:  run "csh ./gmt_phgrad_to_kml.csh" in terminal will generate the kml result.

The contributions

The IPGS MATLAB code was done by Dongxiao Zhang, with guidance and modifications by Dr. Jie Dong and Prof. Lu Zhang. Additionally, we would like to thank Yian Wang and Shaokun Guo for their valuable suggestions and feedback.

If you are interested in our IPGS method and codes, please cite following articles.
Dongxiao Zhang, Lu Zhang, Jie Dong, Yian Wang, Chengsheng Yang, Mingsheng Liao. Improved phase gradient stacking for landslide detection. Landslides (2024). https://doi.org/10.1007/s10346-024-02263-3.
Lv Fu, Qi Zhang, Teng Wang, Weile Li, Qiang Xu, Daqing Ge. Detecting slow-moving landslides using InSAR phase-gradient stacking and deep-learning network. Frontiers in Environmental Science (2022). http://doi.org/10.3389/fenvs.2022.963322. 

If you have any questions or suggestions, please contact us:
Dongxiao Zhang, 2020186190086@whu.edu.cn
Jie Dong, dongjie@whu.edu.cn
