#!/bin/bash
# https://www.humanconnectome.org/software/workbench-command/-label-to-volume-mapping
## wb_command -label-to-volume-mapping

base_dir=/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/Prediction/Article/View_gii/fsLR_32K

file_in=/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/clusters_gifti_mask/right_c4_red.shape.gii

#surf_coord=${base_dir}/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii
surf_coord=${base_dir}/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii

vol_space=/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/Prediction/Article/View_gii/T1/MNI152_T1_2mm.nii.gz

vol_out=/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/clusters_gifti_mask/right_c4_red.nii.gz

inner_surf=${base_dir}/S1200.R.white_MSMAll.32k_fs_LR.surf.gii
out_surf=${base_dir}/S1200.R.pial_MSMAll.32k_fs_LR.surf.gii

wb_command -label-to-volume-mapping ${file_in} ${surf_coord} ${vol_space} ${vol_out} -ribbon-constrained ${inner_surf} ${out_surf}