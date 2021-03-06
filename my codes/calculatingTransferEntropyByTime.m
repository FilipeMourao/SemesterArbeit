function [ transferEntropyMatrix] = ...
calculatingTransferEntropyByTime(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities)

%% Create conditional matrix of alarms 
% Input
% Table T 
%Int numberOfPreviousAlarmConsidered: how many alarms should be considered in a sequnce 
%ex : if  numberOfPreviousAlarmConsidered = 1  in the sequence ABC we are
%just counting the combination AB and AC, if
%numberOfPreviousAlarmConsidered = 2 we will also count AC
%String nameOfIdColum: name of the id colum in the table 
%
% Output
% occurencesMatrix: Matrix with the occurences between 2 alarms
%conditionalMatrix: Matrix containing the conditional probabilities between
%alarms
%%
%Pre allocation of memory
conditionalEntropyMatrix= zeros(length(conditionalMatrixPP));
independentEntropyMatrix= zeros(length(independentProbabilities),1);
transferEntropyMatrix= zeros(length(conditionalMatrixPP));
roundNumber = 10;
%H(X) = P(X)*log[P(X)]  + P(~X)*log[P(~X)]
for i=1:length(independentProbabilities)
%     independentEntropyMatrix(i) = -( independentProbabilities(i)*real(log(independentProbabilities(i))) + ...
%     (1-independentProbabilities(i))*real(log(1-independentProbabilities(i)))); 
    independentEntropyMatrix(i) = -round( independentProbabilities(i)*real(log(independentProbabilities(i))) + ...
    (1-independentProbabilities(i))*real(log(1-independentProbabilities(i))),roundNumber); 
end
%H(X|Y) = P(X,Y)*log[P(X|Y)]      + P(~X,Y)*log[P(~X|Y)]      +  P(X,~Y)*log[P(X|~Y)]       + P(~X,~Y)*log[P(~X|~Y)]
%H(X|Y) = P(X|Y)*P(Y)*log[P(X|Y)] + P(~X|Y)*P(Y)*log[P(~X|Y)] +  P(X|~Y)*P(~Y)*log[P(X|~Y)] + P(~X|~Y)*P(~Y)*log[P(~X|~Y)]
for i=1:length(conditionalEntropyMatrix)
    for j=1:length(conditionalEntropyMatrix)
        % there are some alarms much more frequents than others so the independent probability of great part of the alarms is almost zero
        % P(X|Y)*P(Y)*log[P(X|Y)] 
        if (conditionalMatrixPP(i,j) ~= 0 )
        conditionalEntropyMatrix(i,j) = conditionalEntropyMatrix(i,j) + ...  
        conditionalMatrixPP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixPP(i,j)));
        end
        
        % P(~X|Y)*P(Y)*log[P(~X|Y)] ->  P(~X|Y) almost 1
        if (conditionalMatrixNP(i,j) ~= 0 )
        conditionalEntropyMatrix(i,j) = conditionalEntropyMatrix(i,j) + ...  
        conditionalMatrixNP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixNP(i,j)));
        end
        
        % P(X|~Y)*P(~Y)*log[P(X|~Y)] 
        if (conditionalMatrixPN(i,j) ~= 0 )
        conditionalEntropyMatrix(i,j) = conditionalEntropyMatrix(i,j) + ...  
        conditionalMatrixPN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixPN(i,j)));
        end

        %  P(~X|~Y)*P(~Y)*log[P(~X|~Y)] -> log[P(~X|~Y) almost 1
        if (conditionalMatrixNN(i,j) ~= 0 )
        conditionalEntropyMatrix(i,j) = conditionalEntropyMatrix(i,j) + ...  
        conditionalMatrixNN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixNN(i,j)));
        end
%     conditionalEntropyMatrix(i,j) = - conditionalEntropyMatrix(i,j);
    conditionalEntropyMatrix(i,j) = - round(conditionalEntropyMatrix(i,j),roundNumber);
    end
end
%T(X->Y) = H(Y) - H(Y|X)
%T(i->j) = H(j) - H(j|i)
for i=1:length(conditionalEntropyMatrix)
    for j=1:length(conditionalEntropyMatrix)
        if i ~= j
            transferEntropyMatrix(i,j) = independentEntropyMatrix(j) - conditionalEntropyMatrix(j,i);
        end
    end
end


end

