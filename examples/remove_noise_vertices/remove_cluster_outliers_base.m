function corrected_res = remove_cluster_outliers_base(c_label, clusters_vector, surf)

%% INIT
% c_info = info4;
% clusters_vector = lpac_data;
% surf = surfFile_l;
% c_label = 4

%% surface info
% surf_info = gifti(surf);
% faces = surf_info.faces;
% vertices = surf_info.vertices;

%% 1. calculate the number of the clusters for a given c_label.
% n = 1, no outliers
% n>1, outilers
thr = 0.5;
c_info = LJH_NCluster_vector(clusters_vector,surf,c_label,thr); % thr = 0.5 (Any positive value less than 1 is ok.)


n_clus = c_info.Nclus;

if n_clus ==1
    
    disp('No outliers')
    corrected_res = {};

elseif n_clus ==2

    corrected_res = cell(2,n_clus-1) % r1: vert; r2: the corrected label.

    disp('Process for removing outliers start...');
    noise_ind = 2;

    [noise_vert, corrected_label] = correct_clus_base(noise_ind,c_label, c_info, clusters_vector, surf);

    

    corrected_res{1, noise_ind-1} = noise_vert;
    corrected_res{2, noise_ind-1} = corrected_label;
 
    %% save results

else % n_clus > 2

    corrected_res = cell(2,n_clus-1)

    for i = 2:n_clus
        noise_ind = i;
        [noise_vert, corrected_label] = correct_clus_base(noise_ind,c_label, c_info, clusters_vector, surf);

        corrected_res{1, noise_ind-1} = noise_vert;
        corrected_res{2, noise_ind-1} = corrected_label;


    end


end




    



    


        



    


   











    


    



end
