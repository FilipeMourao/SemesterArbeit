function [DAG]= creatingDirectedAcyclicGraph(transferEntropyMatrix,occurencesMatrix,tripleOcurrences,...
conditionalMatrixPP,conditionalMatrixPN,conditionalMatrixNP,conditionalMatrixNN,independentProbabilities)
    DAG = zeros(size(occurencesMatrix));
    totalAlarmOccurences = sum(independentProbabilities(:,2));
    DET = creatingTriplesMap(size(occurencesMatrix,1));
    %computing the diferential direct transfer entropy DTE
    % D_x->y = sum (P(X,Y,Z)*log(P(X,Y,Z)/(P(X|Z)*(P(Y|Z)*P(Z)))) =
    %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z))) + p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z))) 
    %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z))) + p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
    %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z))) + p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
    %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z))) + p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
    
    for i = 1:size(occurencesMatrix,1)
        for j = i+1:size(occurencesMatrix,1)
            % here we check if we dont have the relation between the 2 variables 
            %yet and if its a casuality relation between the variables
            if( (DAG(i,j) == 0 && DAG(j,i) == 0)&&(transferEntropyMatrix(i,j) > 0 || transferEntropyMatrix(j,i) > 0)) 
                    %calculate the DET
                    directPath = true;
                    for k = 1:size(occurencesMatrix,1)
                        if((k ~= i && k ~=j )&&((transferEntropyMatrix(i,j) > 0 &&...
                            transferEntropyMatrix(i,k) > 0 && transferEntropyMatrix(k,j) > 0)...
                            || (transferEntropyMatrix(j,i) > 0 &&...
                            transferEntropyMatrix(j,k) > 0 && transferEntropyMatrix(k,i) > 0)) )
                          DETValue = 0;
                          numberString = mappingNumbersIntoString(i,j,k);
                          tripleOcurrence_X_Y_Z = tripleOcurrences(numberString);  
                          %calculating triple probabilities
                          p_X_Y_Z = tripleOcurrence_X_Y_Z/totalAlarmOccurences; 
                          p_NX_Y_Z = (occurencesMatrix(j,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                          p_X_NY_Z = (occurencesMatrix(i,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                          p_X_Y_NZ = (occurencesMatrix(i,j) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                          p_NX_Y_NZ = (occurencesMatrix(j,j) + tripleOcurrence_X_Y_Z - occurencesMatrix(i,j)... 
                          - occurencesMatrix(j,k) )/totalAlarmOccurences;
                          p_NX_NY_Z = (occurencesMatrix(k,k) + tripleOcurrence_X_Y_Z - occurencesMatrix(i,k)... 
                          - occurencesMatrix(j,k) )/totalAlarmOccurences;
                          p_X_NY_NZ = (occurencesMatrix(i,i) + tripleOcurrence_X_Y_Z - occurencesMatrix(i,j)... 
                          - occurencesMatrix(i,k) )/totalAlarmOccurences;
                          p_NX_NY_NZ = 1 - p_X_Y_Z - -p_NX_Y_Z - p_X_NY_Z - p_X_Y_NZ - p_X_NY_NZ - p_NX_Y_NZ - p_NX_NY_Z;
                          if(p_X_Y_Z ~= 0)
                               %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z)))
                              DETValue = DETValue + p_X_Y_Z*real(log(p_X_Y_Z/...
                              (conditionalMatrixPP(i,k)*conditionalMatrixPP(j,k)*independentProbabilities(k))));
                          end
                          if(p_NX_Y_Z ~= 0)
                                 %p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z))) 
                                 DETValue = DETValue + p_NX_Y_Z*real(log(p_NX_Y_Z/...
                                 (conditionalMatrixNP(i,k)*conditionalMatrixPP(j,k)*independentProbabilities(k))));
                          end
                          if(p_X_NY_Z ~= 0)
                               %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z))) 
                                DETValue = DETValue + p_X_NY_Z*real(log(p_X_NY_Z/...
                                (conditionalMatrixPP(i,k)*conditionalMatrixNP(j,k)*independentProbabilities(k))));
                          end
                          if(p_X_Y_NZ ~= 0)
                            % p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
                          DETValue = DETValue + p_X_Y_NZ*real(log(p_X_Y_NZ/...
                          (conditionalMatrixPN(i,k)*conditionalMatrixPN(j,k)*(1- independentProbabilities(k)))));
                          end
                          if(p_X_NY_NZ ~= 0)
                          %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z)))
                           DETValue = DETValue + p_X_NY_NZ*real(log(p_X_NY_NZ/...
                          (conditionalMatrixPN(i,k)*conditionalMatrixNN(j,k)*(1-independentProbabilities(k)))));
                          end
                          if(p_NX_Y_NZ ~= 0)
                               %p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
                                DETValue = DETValue + p_NX_Y_NZ*real(log(p_NX_Y_NZ/...
                                (conditionalMatrixNN(i,k)*conditionalMatrixPN(j,k)*(1-independentProbabilities(k)))));
                          end
                          if(p_NX_NY_Z ~= 0)
                            %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z)))
                            DETValue = DETValue + p_NX_NY_Z*real(log(p_NX_NY_Z/...
                            (conditionalMatrixNP(i,k)*conditionalMatrixNP(j,k)*independentProbabilities(k))));
                          end
                          if(p_NX_NY_NZ ~= 0)
                            % p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
                            DETValue = DETValue + p_NX_NY_NZ*real(log(p_NX_NY_NZ/...
                            (conditionalMatrixNN(i,k)*conditionalMatrixNN(j,k)*(1-independentProbabilities(k)))));
                          end
                           if (DETValue < 0)
                            directPath = false;
                            break;
                           end
                        end
                    end
                    if directPath
                        if(transferEntropyMatrix(i,j) > transferEntropyMatrix(j,i))
                            DAG(i,j) = -1;
                            DAG(j,i) = 1;
                        else
                            DAG(i,j) = 1;
                            DAG(j,i) = -1;
                        end
                    end
           end
        
        end
    end
    
    
    
         
end
function [numberString] = mappingNumbersIntoString(firstNumber,sencodNumber,thirdNumber)
    numberArray = [firstNumber,sencodNumber,thirdNumber];
    smallestNumber = min(numberArray);
    medianNumber = median(numberArray); 
    biggestNumer = max(numberArray);
    numberString = string(smallestNumber )+"-" + string(medianNumber)+ "-"+ string(biggestNumer);
    numberString = convertStringsToChars(numberString);
end
function [mapTriples] = creatingTriplesMap(numberOfDifferentIds)
    mapTriples = containers.Map;
    for i=1:numberOfDifferentIds
        for j = i+1:numberOfDifferentIds
            for k = j+1:numberOfDifferentIds
                string = mappingNumbersIntoString(i,j,k);
                mapTriples(string) = 0;
            end
        end
    end
end

