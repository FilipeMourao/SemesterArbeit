function [ conditionalFractalEntropyMatrix] = ...
calculatingFractalEntropyByTime(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities)

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
conditionalFractalEntropyMatrix= zeros(length(conditionalMatrixPP));
%H(X|Y) = P(X,Y)*log[P(X|Y)]      + P(~X,Y)*log[P(~X|Y)]      +  P(X,~Y)*log[P(X|~Y)]       + P(~X,~Y)*log[P(~X|~Y)]
%H(X|Y) = P(X|Y)*P(Y)*log[P(X|Y)] + P(~X|Y)*P(Y)*log[P(~X|Y)] +  P(X|~Y)*P(~Y)*log[P(X|~Y)] + P(~X|~Y)*P(~Y)*log[P(~X|~Y)]
for i=1:length(conditionalFractalEntropyMatrix)
    for j=1:length(conditionalFractalEntropyMatrix)
        % there are some alarms much more frequents than others so the independent probability of great part of the alarms is almost zero
        % P(X|Y)*P(Y)*log[P(X|Y)] 
        if (conditionalMatrixPP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixPP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixPP(i,j)));
        end
        
        % P(~X|Y)*P(Y)*log[P(~X|Y)] ->  P(~X|Y) almost 1
        if (conditionalMatrixNP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixNP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixNP(i,j)));
        end
        
        % P(X|~Y)*P(~Y)*log[P(X|~Y)] 
        if (conditionalMatrixPN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixPN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixPN(i,j)));
        end

        %  P(~X|~Y)*P(~Y)*log[P(~X|~Y)] -> log[P(~X|~Y) almost 1
        if (conditionalMatrixNN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixNN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixNN(i,j)));
        end
    conditionalFractalEntropyMatrix(i,j) = - conditionalFractalEntropyMatrix(i,j);
    end
end
end

