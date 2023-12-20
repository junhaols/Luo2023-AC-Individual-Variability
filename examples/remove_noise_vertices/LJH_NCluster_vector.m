function CluInfo=LJH_NCluster_vector(clustering_labels,surfFile,cluster_label,thr)

%ClusteringMat='/data/disk2/luojunhao/Project/Clustering/Analysis/OptimalPara/REST1/FinalClusteringSort/100307_All_L-PT_L-HS_VertIndexFinal.mat'
% 
% VertIndexInfo=load(ClusteringMat)
% VertIndexInfo=VertIndexInfo.VertIndexInfo;
% vert_index=VertIndexInfo(:,1);
% clustering_label=VertIndexInfo(:,4);

%surfFile='/data/disk2/luojunhao/Common/Common_temp_view/surface_fsLR/32K/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii'
%surface2='/data/disk2/luojunhao/Common/Common_temp_view/surface_fsLR/32K/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii'
%thr=0.5;
%% cluster_label
% gii=gifti(surfFile);
% N=length(gii.vertices);
% 
% %% L or R
% if min(vert_index)>N % Rsurf 
%     vert_index=vert_index-N;
% end
% mask=zeros(N,1);
% mask(vert_index(find(clustering_labels==cluster_label)))=1;
% texdata=zeros(N,1);
% texdata(vert_index(find(clustering_labels==cluster_label)))=cluster_label;
% [ peak, clus, clusid] = Ncluster_vertor(texdata,mask,surfFile,thr);
% CluInfo.peak=peak;
% CluInfo.clus=clus;
% CluInfo.clusid=clusid;
% CluInfo.Nclus=length(clus.clusid);

gii=gifti(surfFile);
N=length(gii.vertices);

mask=zeros(N,1);
mask(find(clustering_labels==cluster_label))=1;
texdata=zeros(N,1);
texdata(find(clustering_labels==cluster_label))=cluster_label;
[ peak, clus, clusid] = Ncluster_vertor(texdata,mask,surfFile,thr);
CluInfo.peak=peak;
CluInfo.clus=clus;
CluInfo.clusid=clusid;
CluInfo.Nclus=length(clus.clusid);


%% 


