function [ conditionalFractalEntropyMatrix_PP,conditionalFractalEntropyMatrix_NP,conditionalFractalEntropyMatrix_PN,conditionalFractalEntropyMatrix_NN] = ...
testingFractalEntropy(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities)

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
conditionalFractalEntropyMatrix_PP= zeros(length(conditionalMatrixPP));
conditionalFractalEntropyMatrix_NP= zeros(length(conditionalMatrixPP));
conditionalFractalEntropyMatrix_PN= zeros(length(conditionalMatrixPP));
conditionalFractalEntropyMatrix_NN= zeros(length(conditionalMatrixPP));
%H(X|Y) = P(X,Y)*log[P(X|Y)]      + P(~X,Y)*log[P(~X|Y)]      +  P(X,~Y)*log[P(X|~Y)]       + P(~X,~Y)*log[P(~X|~Y)]
%H(X|Y) = P(X|Y)*P(Y)*log[P(X|Y)] + P(~X|Y)*P(Y)*log[P(~X|Y)] +  P(X|~Y)*P(~Y)*log[P(X|~Y)] + P(~X|~Y)*P(~Y)*log[P(~X|~Y)]
for i=1:length(conditionalFractalEntropyMatrix_PP)
    for j=1:length(conditionalFractalEntropyMatrix_PP)
        % there are some alarms much more frequents than others so the independent probability of great part of the alarms is almost zero
        % P(X|Y)*P(Y)*log[P(X|Y)] 
        if (conditionalMatrixPP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix_PP(i,j) = conditionalFractalEntropyMatrix_PP(i,j) + ...  
        conditionalMatrixPP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixPP(i,j)));
        end
        
        % P(~X|Y)*P(Y)*log[P(~X|Y)] ->  P(~X|Y) almost 1
        if (conditionalMatrixNP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix_NP(i,j) = conditionalFractalEntropyMatrix_NP(i,j) + ...  
        conditionalMatrixNP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixNP(i,j)));
        end
        
        % P(X|~Y)*P(~Y)*log[P(X|~Y)] 
        if (conditionalMatrixPN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix_PN(i,j) = conditionalFractalEntropyMatrix_PN(i,j) + ...  
        conditionalMatrixPN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixPN(i,j)));
        end

        %  P(~X|~Y)*P(~Y)*log[P(~X|~Y)] -> log[P(~X|~Y) almost 1
        if (conditionalMatrixNN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix_NN(i,j) = conditionalFractalEntropyMatrix_NN(i,j) + ...  
        conditionalMatrixNN(i,j)*(1 - independentProbabilities(j))*real(log(conditionalMatrixNN(i,j)));
        end
        conditionalFractalEntropyMatrix_PP(i,j) = - conditionalFractalEntropyMatrix_PP(i,j);
            conditionalFractalEntropyMatrix_PN(i,j) = - conditionalFractalEntropyMatrix_PN(i,j);
                conditionalFractalEntropyMatrix_NP(i,j) = - conditionalFractalEntropyMatrix_NP(i,j);
                    conditionalFractalEntropyMatrix_NN(i,j) = - conditionalFractalEntropyMatrix_NN(i,j);
    end
end
end

