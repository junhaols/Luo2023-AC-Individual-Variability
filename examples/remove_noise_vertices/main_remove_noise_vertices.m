%% A demo for removing the noise vertices of the clustering

%% 0. set env
% download surfstat: https://www.math.mcgill.ca/keith/surfstat/
surf_stat_path = '';
addpath(genpath(surf_stat_path))
% 
addpath(genpath('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/AC_github/bin/scripts/spectral_clustering'))


%% surface base in the direction ~/surf
surfFile_l = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/Prediction/Article/View_gii/fsLR_32K/S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii'
surfFile_r = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/Prediction/Article/View_gii/fsLR_32K/S1200.R.inflated_MSMAll.32k_fs_LR.surf.gii'


%% ********************************************** robust analyses. ****************************************

%% *********************************** gamma=0.001, different rand seeds **********************************
%% 1. Auto  corrected
% left
files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/orig_clustering_32k/new/left/cluster_4_left_rand_seed_*.mat');
check_flags_l = ones(length(files),1);
for i=1:length(files)
    file = files{i};
    data = load(file);
    vector_in = data.lpac_data';
    surf = surfFile_l;
    [vector_correct, rc_flag] = corrected_cluster_outliers(vector_in, surf);
    save_path = replace(file,'orig_clustering_32k', 'orig_clustering_32k_corrected');
    clus = vector_correct;
    save(save_path, "clus")
    check_flags_l(i) = rc_flag;

end

% right

files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/orig_clustering_32k/new/right/cluster_4_right_rand_seed_*.mat');
check_flags_r = ones(length(files),1);
for i=1:length(files)
    file = files{i};
    data = load(file);
    vector_in = data.rpac_data';
    surf = surfFile_r;
    [vector_correct, rc_flag] = corrected_cluster_outliers(vector_in, surf);
    save_path = replace(file,'orig_clustering_32k', 'orig_clustering_32k_corrected');
    clus = vector_correct;
    save(save_path, "clus")
    check_flags_r(i) = rc_flag;

end


%% 2. rename cluster labels as rand seed 0 does. (For comparision)
% left
files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/orig_clustering_32k_corrected/new/left/cluster_4_left_rand_seed_*.mat');

ref_l = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/ref/cluster_4_left_rand_seed_0.mat'

ref_l_mat = load(ref_l);
ref_l_mat = ref_l_mat.clus;

for i=1:length(files)
    file = files{i}; 
    vect = load(file);
    vect = vect.clus;
    vect_tmp = vect * (-1);

    %dice_max = zeros(4, 1);

    for j = 1:4 % ref
        dice_max = zeros(4, 1);
        ref_vect = ref_l_mat;
        ref_vect(ref_vect ~= j) = 0;

        for k=1:4
            vect_in = vect;
            vect_in(vect_in ~= k) = 0;

            dice = dices(ref_vect, vect_in);
            dice_max(k) = dice;


        end

        % find the max dice
        max_ind = find(dice_max == max(dice_max));
        % change the label
        vect_tmp(vect_tmp == -max_ind) = j;

    end

    % save 
    clus = vect_tmp;
    save_file = replace(file,'orig_clustering_32k_corrected', 'gamma_e-3_ref_rand0_corrected');
    save(save_file, 'clus')


end


% right
files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/orig_clustering_32k_corrected/new/right/cluster_4_right_rand_seed_*.mat');

ref_r = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/ref/cluster_4_right_rand_seed_0.mat'

ref_r_mat = load(ref_r);
ref_r_mat = ref_r_mat.clus;

for i=1:length(files)
    file = files{i}; 
    vect = load(file);
    vect = vect.clus;
    vect_tmp = vect * (-1);

    %dice_max = zeros(4, 1);

    for j = 1:4 % ref
        dice_max = zeros(4, 1);
        ref_vect = ref_r_mat;
        ref_vect(ref_vect ~= j) = 0;

        for k=1:4
            vect_in = vect;
            vect_in(vect_in ~= k) = 0;

            dice = dices(ref_vect, vect_in);
            dice_max(k) = dice;


        end

        % find the max dice
        max_ind = find(dice_max == max(dice_max));
        % change the label
        vect_tmp(vect_tmp == -max_ind) = j;

    end

    % save 
    clus = vect_tmp;
    save_file = replace(file,'orig_clustering_32k_corrected', 'gamma_e-3_ref_rand0_corrected');
    save(save_file, 'clus')


end



%% 3. calculate the dice of the corrected clusters with rand-0.

% file1 = load('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/left/cluster_4_left_rand_seed_0.mat')
% file2 = load('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/left/cluster_4_left_rand_seed_5.mat')

%% ref
% left
ref_l = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/ref/cluster_4_left_rand_seed_0.mat'
ref_l_mat = load(ref_l);
ref_l_mat = ref_l_mat.clus;

files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/left/cluster_4_left_rand_seed_*.mat');

dices_all = zeros(4, length(files));

for i=1:length(files)
    file = files{i}; 
    vect = load(file);
    vect = vect.clus;

    dice_tmp = dice(ref_l_mat, vect);
    dices_all(:, i) = dice_tmp;

end

dics_all_mean_l = mean(dices_all,2)


% right
ref_r = '/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/ref/cluster_4_right_rand_seed_0.mat'
ref_r_mat = load(ref_r);
ref_r_mat = ref_r_mat.clus;

files = g_ls('/Users/fiona/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Project/PAC_Individual_difference/result/stats/clustering/c_vs_hcpmmp/robust/gamma_e-3_ref_rand0_corrected/new/right/cluster_4_right_rand_seed_*.mat');

dices_all = zeros(4, length(files));

for i=1:length(files)
    file = files{i}; 
    vect = load(file);
    vect = vect.clus;

    dice_tmp = dice(ref_r_mat, vect);
    dices_all(:, i) = dice_tmp;

end

dics_all_mean_r = mean(dices_all,2)


