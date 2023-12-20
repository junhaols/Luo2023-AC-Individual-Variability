function [noise_vert, corrected_label] = correct_clus_base(noise_ind,c_label, c_info, clusters_vector, surf)


surf_info = gifti(surf);
faces = surf_info.faces;
%vertices = surf_info.vertices;
%disp('Process for removing outliers start...');
%noise_ind = 2;
noise_vert = find(c_info.clusid == noise_ind);

%% only one noise_vert (no border)
if length(noise_vert) == 1

    faces_tmp = faces;
    % mark edge_v1
    faces_tmp(faces_tmp == noise_vert) = -1; % mark as -1
    ps = find(faces_tmp==-1);
    
    % Take the remainder
    face_ind = rem(ps, length(faces_tmp));
    % select the  triangle

    for i = 1:length(face_ind)

        tri = faces_tmp(face_ind(i),:);
        % the remain 2 vertices
        ind_neighbors = find(tri ~= -1);
        vert_correct = tri(ind_neighbors(1));
        v3_label = clusters_vector(vert_correct);
        if v3_label == 0 % invalided, select the second vertex on the tri
            vert_correct = tri(ind_neighbors(2));
            v3_label = clusters_vector(vert_correct);
            if v3_label == 0 % drop the tri
                continue;
            else
                corrected_label = v3_label;
                break; % stop
            end
        else
            corrected_label = v3_label;
            break; % stop
        end
    end

else
   
    %% more than one noise_vert (border)
    
    % find the border of the noise clusters
    
    noise_vector = zeros(length(clusters_vector),1);
    noise_vector(noise_vert) = 1;
    
    noise_border = creat_border(surf, noise_vector);
    
    border_vert = find(noise_border==1);
    
    % select one of the edge in the noise_border
    edge_v1 = border_vert(1); % for conveninet, select first point.
    % find edge_v2 in the this noise_border connecting to edge_v1.
    
    faces_tmp = faces;
    % mark edge_v1
    faces_tmp(faces_tmp == edge_v1) = -1; % mark as -1
    ps = find(faces_tmp==-1);
    
    % Take the remainder
    face_ind = rem(ps, length(faces_tmp));
    % find edge_v2 in these faces, if do, break.
    faces_candi = faces_tmp(face_ind,:);
    %faces_candi_tmp = faces_candi;
    for i = 2:length(border_vert) % 1 is edge_v1
        edge_v2 = border_vert(i);
        v2_flag = find(faces_candi==edge_v2);
        if ~isempty(v2_flag)
            faces_candi(v2_flag) = -2; % mark as -2
            
            v2_face_ind = rem(v2_flag, size(faces_candi,1));
            %orig_face_ind = face_ind(v2_face_ind(1));
            tri_v12_tmp = faces_candi(v2_face_ind(1),:);
            %tri_v12 = faces(orig_face_ind,:);
            % the 3th vertex on the triangle
            tri_v3 = tri_v12_tmp(tri_v12_tmp>0); % this vertex for further judge;            
    
            break     
        else
            continue
        end
    end
    
    %% the neighbors of the tri_v123， read the cluster label of tri_v3 
    v3_label = clusters_vector(tri_v3);
    if clusters_vector(tri_v3) == c_label || clusters_vector(tri_v3) == 0 
        
       % find all tris including the edgev12
       face_tmp2 = faces;
       face_tmp2(face_tmp2 == edge_v1) = 0; % mark as 0
       face_tmp2(face_tmp2 == edge_v2) = 0; % mark as 0
       s_face_tmp2 = sum(face_tmp2,2); % sum
    
       flag2 = s_face_tmp2 == face_tmp2;
    
       face_ind2 = rem(find(flag2 ==1), length(faces));
    
       face_v3 = faces(face_ind2,:);
       face_v3(face_v3 == edge_v1) = 0;
       face_v3(face_v3 == edge_v2) = 0;
       all_v3 = sum(face_v3,2); % length 2, include the tri_v3
    
    
       % remove tri_v3, and update it.
       tri_v3_new = setdiff(all_v3, tri_v3);
       v3_label = clusters_vector(tri_v3_new);
       corrected_label = v3_label;
    
    else
        corrected_label = v3_label;
    end
end
