function border = creat_border(surf_base,  atlas_roi)

%  atlas_roi: n*1 vector of the roi label info 
% surf_base = '/data/disk2/luojunhao/Common/View_gii/fsLR_32K/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii'
%% 
surf=gifti(surf_base);
% 
% parcels = load('/data/disk2/luojunhao/Common/HCP/HCP_individual_parcellation/parcels/HCP_1029sub_400Parcels_Kong2022_gMSHBM.mat')
% lh_1 = parcels.lh_labels_all(:,1);
% L_label = lh_1;
face=surf.faces;
new_face=zeros(length(face),3);

for i=0:max(atlas_roi)
    index=find(atlas_roi==i);
    for j=1:length(index)
    new_face(face==index(j))=i;
    end
end
    
border=zeros(length(atlas_roi),1); % fslr 32k, 
for i=1:length(new_face)
    k=unique(new_face(i,:));
    if length(k)==1 % no border in this tri
        continue;
    
    elseif length(k)==2 % 2 points as the border
  
        border_ind = extract_samevalue_ind_faces(new_face(i,:));
      
        border(face(i, border_ind(1)))=1;
        border(face(i, border_ind(2)))=1;
        
    else % 3 points are the border
        border(face(i,1)) = 1; %
        border(face(i,2)) = 1;
        border(face(i,3)) = 1;
    end
end

% border_label=gifti;
% border_label.cdata=border;
% 
% save_surf(border_label, save_path);
% 

