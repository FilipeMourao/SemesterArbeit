function [clustLabel, varType] = dbscan(x, MinPts, Eps)
% DBSCAN computes the clustering for a dataset using the dbscan algorithm
%
% Input:
%       x - data matrix (rows observations, columns variables)
%       MinPts - minimum number of neighbors to define a core point
%       Eps - range of the neighborhood
%
% Output:
%       clustLabel - final label vector (0 is assigned to noise points)
%       varType - 1: core point, -1: noise point
%
% If Eps not provided, a k-dist plot is showed and the user can select the
% value of Eps by looking at the y value corresponding to the knee of the
% plot.
%
% Reference: Ester, Martin; Kriegel, Hans-Peter; Sander, Jörg;
% Xu, Xiaowei (1996). Simoudis, Evangelos; Han, Jiawei; Fayyad, Usama M.,
% eds. A density-based algorithm for discovering clusters in large spatial
% databases with noise. Proceedings of the Second International Conference
% on Knowledge Discovery and Data Mining (KDD-96). AAAI Press. pp. 226?231.
% ISBN 1-57735-004-9. CiteSeerX: 10.1.1.71.1980
%
% Author: Paolo Inglese, 2015


nobs = size(x,1);

classified = zeros(nobs,1); % state CLASSIFIED=1/NOT-CLASSIFIED=0
Neps       = zeros(nobs,1); % num neighbours in range <= Eps
varType    = nan(nobs,1);   % class (core=1, noise=-1);
clustLabel = nan(nobs,1);   % label
numClust   = 0;             % current label
D          = squareform(pdist(x, 'euclidean'));

if(nargin<3)
    plot_kdist(x, MinPts, D);
    drawnow;
    Eps = input('Insert Eps (knee point):');
end

for iobs = 1:nobs
    
    if(~classified(iobs))
        
        [~, neighIdx] = find(D(iobs, :) <= Eps);
        Neps(iobs)    = length(neighIdx);
        
        if(Neps(iobs) <= MinPts)
            % noise
            varType(iobs)    = -1;
            clustLabel(iobs) = 0;
            classified(iobs) = 1;
            continue;
        else
            % core
            numClust             = numClust + 1;
            varType(neighIdx)    = 1;
            clustLabel(neighIdx) = numClust;
            classified(neighIdx) = 1;
            
            % stack
            seedsIdx             = neighIdx(neighIdx ~= iobs);
            while(~isempty(seedsIdx))
                
                currSeedStackIdx  = 1;
                currSeedIdx       = seedsIdx(currSeedStackIdx);
                [~, neighIdx]     = find(D(currSeedIdx, :) <= Eps);
                Neps(currSeedIdx) = length(neighIdx);
                
                if(Neps(currSeedIdx)>=MinPts+1)
                    
                    % push the unclassified onto seeds
                    seedsIdx = [seedsIdx, neighIdx(classified(neighIdx) == 0)]; %#ok<AGROW>
                    
                    % and they are added to the current cluster
                    clustLabel(neighIdx(classified(neighIdx) == 0 | varType(neighIdx) == -1)) = numClust;
                    
                    % they are not noise anymore
                    varType(neighIdx) = 1;
                    
                    % they become classified
                    classified(neighIdx) = 1;
                    
                end
                
                % pop the seed from the stack
                seedsIdx(currSeedStackIdx) = [];
                
            end
            
        end
        
    end
    
end
end

function plot_kdist(x, MinPts, D)

nobs = size(x,1);

kdist = zeros(nobs, 1);
for i = 1:nobs
    
    dtmp     = D(i, :);
    dtmp(i)  = [];
    dtmp     = sort(dtmp, 'ascend');
    kdist(i) = dtmp(MinPts);
    
end

kdist = sort(kdist, 'descend');
figure;
plot(kdist);

end

% Copyright (c) 2015, Paolo Inglese
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.