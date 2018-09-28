function [d] = som_distances(net)
%% Calculate distances between neurons
%
% Input:
% net = Neuronal Network
%
% Output:
% d = Distances

%% Number of Neurons, Neighbors and Weights
numNeurons = net.layers{1,1}.dimensions(1)*net.layers{1,1}.dimensions(2);
neighbors = sparse(tril(net.layers{1}.distances <= 1.001) - eye(numNeurons));
weights = net.IW{1,1};

%% Calculate distance based on weights
k = 1;
d = zeros(numNeurons,numNeurons);
for i=1:numNeurons
  for j=find(neighbors(i,:))
    d(i,j) = sqrt(sum((weights(i,:)-weights(j,:)).^2));
    k = k + 1;
  end
end

%% Normalize distance
mm = minmax(d(:)');
d = (d-mm(1)) ./ (mm(2)-mm(1));

if mm(1) == mm(2) 
    d = zeros(size(d)) + 0.5; 
end

end

