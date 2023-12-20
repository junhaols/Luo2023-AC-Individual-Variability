function [vector_correct, c_flag] = corrected_cluster_outliers(vector_in, surf)
%% output
% - vector_correct: the corrected vector
% - c_flag: corrected flag, 0 is ok and 1 is error.
%% auto  corrected

clusters_vector = vector_in;
%surf = surfFile_r;
cor1 = remove_cluster_outliers_base(1, clusters_vector, surf);
cor2 = remove_cluster_outliers_base(2, clusters_vector, surf);
cor3 = remove_cluster_outliers_base(3, clusters_vector, surf);
cor4 = remove_cluster_outliers_base(4, clusters_vector, surf);
% init

vector_correct = vector_in;
%
if ~isempty(cor1)
    [nr, nc] = size(cor1);
    
    for i=1:nc
        vector_correct(cor1{1,i}) = cor1{2,i};

    end

end
if ~isempty(cor2)
    [nr, nc] = size(cor2);
    
    for i=1:nc
        vector_correct(cor2{1,i}) = cor2{2,i};

    end

end
if ~isempty(cor3)
    [nr, nc] = size(cor3);
    
    for i=1:nc
        vector_correct(cor3{1,i}) = cor3{2,i};

    end

end
if ~isempty(cor4)
    [nr, nc] = size(cor4);
    
    for i=1:nc
        vector_correct(cor4{1,i}) = cor4{2,i};

    end
    
end

%% check the corrected results
%thr = 0.5;
vector_correct1 = vector_correct;
vector_correct1(vector_correct1 ~= 1) = 0;

vector_correct2 = vector_correct;
vector_correct2(vector_correct2 ~= 2) = 0;

vector_correct3 = vector_correct;
vector_correct3(vector_correct3 ~= 3) = 0;

vector_correct4 = vector_correct;
vector_correct4(vector_correct4 ~= 4) = 0;


c_info1 = LJH_NCluster_vector(vector_correct1,surf,1,0.5); % thr = 0.5 (Any positive value less than 1 is ok.)
n_clus1 = c_info1.Nclus;
c_info2 = LJH_NCluster_vector(vector_correct2,surf,2,0.5); % thr = 0.5 (Any positive value less than 1 is ok.)
n_clus2 = c_info2.Nclus;
c_info3 = LJH_NCluster_vector(vector_correct3,surf,3,0.5); % thr = 0.5 (Any positive value less than 1 is ok.)
n_clus3 = c_info3.Nclus;
c_info4 = LJH_NCluster_vector(vector_correct4,surf,4,0.5); % thr = 0.5 (Any positive value less than 1 is ok.)
n_clus4 = c_info4.Nclus;

NClus = n_clus1 + n_clus2 + n_clus3 + n_clus4;

if NClus == 4
    disp('All noise vertices have been corrected.')
    c_flag = 0;
else
    c_flag = 1;
end


