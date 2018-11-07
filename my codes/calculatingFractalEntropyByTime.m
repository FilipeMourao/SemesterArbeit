function [independentFractalEntropyMatrix, conditionalFractalEntropyMatrix] = ...
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
independentFractalEntropyMatrix= zeros(length(conditionalMatrixPP),1);
conditionalFractalEntropyMatrix= zeros(length(conditionalMatrixPP));
for i=1:length(conditionalFractalEntropyMatrix)
    if(independentFractalEntropyMatrix(i) ~= 1 && independentFractalEntropyMatrix(i) ~= 0)
            independentFractalEntropyMatrix(i) = -(...
        independentProbabilities(i)*real(log(independentProbabilities(i)))...
        + (1 - independentProbabilities(i))*real(log(1 - independentProbabilities(i)))...
);
    else
        independentFractalEntropyMatrix(i) = 0;
    end
    
 
    for j=1:length(conditionalFractalEntropyMatrix)
        if (conditionalMatrixPP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixPP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixPP(i,j)));
        end
        if (conditionalMatrixPN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixPN(i,j)*independentProbabilities(j)*real(log(conditionalMatrixPN(i,j)));
        end
        if (conditionalMatrixNP(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixNP(i,j)*independentProbabilities(j)*real(log(conditionalMatrixNP(i,j)));
        end
        if (conditionalMatrixNN(i,j) ~= 0 )
        conditionalFractalEntropyMatrix(i,j) = conditionalFractalEntropyMatrix(i,j) + ...  
        conditionalMatrixNN(i,j)*independentProbabilities(j)*real(log(conditionalMatrixNN(i,j)));
        end
    conditionalFractalEntropyMatrix(i,j) = - conditionalFractalEntropyMatrix(i,j);
    end
end
end

