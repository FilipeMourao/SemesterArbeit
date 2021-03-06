function [CausalRelation, DAG]= creatingDirectedAcyclicGraphMaxEdge(transferEntropyMatrix,occurencesMatrix,tripleOcurrences,...
    conditionalMatrixPP,conditionalMatrixPN,conditionalMatrixNP,conditionalMatrixNN,independentProbabilities)
limitOfCausalAndConsequenceRelation = 2;
transferEntropyMatrixCopy = transferEntropyMatrix;
CausalRelation = zeros(size(occurencesMatrix));
causeConsequenceArray = [];
nodesAddedToTheGraph = zeros(size(independentProbabilities,1),1);
maximumTransferEntropyValue = max(max(transferEntropyMatrixCopy));
[x,y]=find(transferEntropyMatrixCopy==maximumTransferEntropyValue);
causalNode = x(1);
consequenceNode = y(1);
transferEntropyMatrixCopy(causalNode ,consequenceNode) = -Inf;
nodesAddedToTheGraph(causalNode) = 1;
nodesAddedToTheGraph(consequenceNode) = 1;
causeConsequenceArray = [causeConsequenceArray;[causalNode,consequenceNode]];
while sum(nodesAddedToTheGraph) < size(independentProbabilities,1)
    %get causal nodes and consequence nodes
    causalNodes = causeConsequenceArray(:,1);
    consequenceNodes = causeConsequenceArray(:,2);
    %filter the nodes that already appear the total number of times  in causal or consequence array
    causalNodesUnique=unique(causalNodes);
    causalNodesOccurences=unique(causalNodes);
    for i = 1:length(causalNodesUnique)
        countingArray = causalNodes == causalNodesUnique(i);
        causalNodesOccurences(i) = sum(countingArray);
    end
    for i = 1:length(causalNodesUnique)
        if causalNodesOccurences(i) >= limitOfCausalAndConsequenceRelation
            causalNodes = causalNodes(find(causalNodes~=causalNodesUnique(i)));
            consequenceNodes = consequenceNodes (find(consequenceNodes ~=causalNodesUnique(i)));
        end
    end
    nodesReadyToExpand = unique([causalNodes;consequenceNodes]);
    %start to find next node to add an edge
    edgeWasAdded = false;
    while ~edgeWasAdded
        %get the maximum fractal entroy in the nodes
        globalMaximum = -inf;
        for i = 1:length(nodesReadyToExpand)
            localMaximum = max(transferEntropyMatrixCopy(nodesReadyToExpand(i),:));
            if localMaximum > globalMaximum
                globalMaximum = localMaximum;
            end
        end
        %get the coordinates of the next edge to be added
        [x,y]=find(transferEntropyMatrixCopy==globalMaximum);
        if globalMaximum > 0
            causalNode = x(1);
            consequenceNode = y(1);
            transferEntropyMatrixCopy(causalNode ,consequenceNode) = -Inf;
            if(length(find(causeConsequenceArray(:,1) == causalNode))< limitOfCausalAndConsequenceRelation &&... 
                length(find(causeConsequenceArray(:,2) == consequenceNode))< limitOfCausalAndConsequenceRelation &&... 
                transferEntropyMatrix(causalNode,consequenceNode) > transferEntropyMatrix(consequenceNode,causalNode))
                CausalRelation(causalNode,consequenceNode) = 1;
                CausalRelation(consequenceNode,causalNode) = -1;
                causeConsequenceArray = [causeConsequenceArray;[causalNode,consequenceNode]];
                if nodesAddedToTheGraph(causalNode) == 0
                    nodesAddedToTheGraph(causalNode) = 1;
                end
                if nodesAddedToTheGraph(consequenceNode) == 0
                    nodesAddedToTheGraph(consequenceNode) = 1;
                end
                edgeWasAdded = true;
            end
        else
            break;
        end
    end
    if globalMaximum <= 0 %if none of the nodes are consequence of another node take the most positive one
        maximumTransferEntropyValue = max(max(transferEntropyMatrixCopy));
        [x,y]=find(transferEntropyMatrixCopy==maximumTransferEntropyValue);
        if maximumTransferEntropyValue > 0
            causalNode = x(1);
            consequenceNode = y(1);
            transferEntropyMatrixCopy(causalNode ,consequenceNode) = -Inf;
            if(length(find(causeConsequenceArray(:,1) == causalNode))< limitOfCausalAndConsequenceRelation &&...
                    length(find(causeConsequenceArray(:,2) == consequenceNode))< limitOfCausalAndConsequenceRelation && ...
                transferEntropyMatrix(causalNode,consequenceNode) > transferEntropyMatrix(consequenceNode,causalNode))
                CausalRelation(causalNode,consequenceNode) = 1;
                CausalRelation(consequenceNode,causalNode) = -1;
                causeConsequenceArray = [causeConsequenceArray;[causalNode,consequenceNode]];
                if nodesAddedToTheGraph(causalNode) == 0
                    nodesAddedToTheGraph(causalNode) = 1;
                end
                if nodesAddedToTheGraph(consequenceNode) == 0
                    nodesAddedToTheGraph(consequenceNode) = 1;
                end
            end
        else
            break;
        end
        
    end
end
causeConsequenceArray = unique(causeConsequenceArray, 'rows', 'first');
DAG = sparse(causeConsequenceArray(:,1),causeConsequenceArray(:,2),true,size(independentProbabilities,1),size(independentProbabilities,1));
end

