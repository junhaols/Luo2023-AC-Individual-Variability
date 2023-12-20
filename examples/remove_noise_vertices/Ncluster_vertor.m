function [ peak, clus, clusid ] = Ncluster_vertor(texdata,mask,surfFile,thr)
slm.t=texdata';
gii=gifti(surfFile);
slm.tri=gii.faces;
%data=unique(texdata);
%[ peak, clus, clusid ] = SurfStatPeakClus(slm, mask, data(1));
[ peak, clus, clusid ] = SurfStatPeakClus(slm, mask, thr);
end

