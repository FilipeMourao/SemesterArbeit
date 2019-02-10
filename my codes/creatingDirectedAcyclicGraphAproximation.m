function [CausalRelation, DAG]= creatingDirectedAcyclicGraphAproximation(transferEntropyMatrix,occurencesMatrix,mapTriples,...
    conditionalMatrixPP,conditionalMatrixPN,conditionalMatrixNP,conditionalMatrixNN,independentProbabilities)
intializerConstant = 5;
CausalRelation = ones(size(occurencesMatrix))*intializerConstant ;
causeConsequenceArray = [];
totalAlarmOccurences = sum(independentProbabilities(:,2));
%computing the diferential direct transfer entropy DTE
% D_x->y = sum (P(X,Y,Z)*log(P(X,Y,Z)/(P(X|Z)*(P(Y|Z)*P(Z)))) =
%p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z))) + p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z)))
%p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z))) + p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
%p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z))) + p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
%p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z))) + p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
for i = 1:size(occurencesMatrix,1)
    for j = 1:size(occurencesMatrix,1)
        if(i ~=j)
            if( CausalRelation(i,j) == intializerConstant && CausalRelation(j,i) == intializerConstant && transferEntropyMatrix(i,j) > 0 )
                %132
                %312
                %calculate the DET
                directPath = true;
                for k = 1:size(occurencesMatrix,1)
                    if(k ~= i && k ~=j && transferEntropyMatrix(i,k) > 0 && transferEntropyMatrix(k,j) > 0)
                        numberString = mappingNumbersIntoString(i,k,j);
                        tripleOcurrence_X_Y_Z = mapTriples(numberString) ;
                        if tripleOcurrence_X_Y_Z > 0
                            p_X_Y_Z = tripleOcurrence_X_Y_Z/totalAlarmOccurences;
                            p_NX_Y_Z = (occurencesMatrix(j,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                            %to hard to calculate
                            % p_X_NY_Z = (occurencesMatrix(k,i))/totalAlarmOccurences;
                            p_X_NY_Z = (occurencesMatrix(k,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                            p_X_Y_NZ = (occurencesMatrix(j,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                            p_NX_Y_NZ = (occurencesMatrix(j,j) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,i)...
                                - occurencesMatrix(k,j) )/totalAlarmOccurences;
                            p_NX_NY_Z = (occurencesMatrix(k,k) + tripleOcurrence_X_Y_Z - occurencesMatrix(k,i)...
                                - occurencesMatrix(k,j) )/totalAlarmOccurences;
                            p_X_NY_NZ = (occurencesMatrix(i,i) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,i)...
                                - occurencesMatrix(k,i) )/totalAlarmOccurences;
                            p_NX_NY_NZ = 1 - p_X_Y_Z - -p_NX_Y_Z - p_X_NY_Z -...
                                p_X_Y_NZ - p_X_NY_NZ - p_NX_Y_NZ - p_NX_NY_Z;
                            DETValue_X_Y_Z = 0;
                            DETValue_NX_Y_Z = 0;
                            DETValue_X_NY_Z = 0;
                            DETValue_X_Y_NZ = 0;
                            DETValue_NX_NY_Z = 0;
                            DETValue_NX_Y_NZ = 0;
                            DETValue_X_NY_NZ = 0;
                            DETValue_NX_NY_NZ = 0;
                            if(p_X_Y_Z ~= 0 && conditionalMatrixPP(k,i)~=0 && conditionalMatrixPP(j,k)~=0  )
                                %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z)))
                                DETValue_X_Y_Z =  p_X_Y_Z*real(log(p_X_Y_Z/...
                                    (conditionalMatrixPP(k,i)*conditionalMatrixPP(j,k)*independentProbabilities(i))));
                            end
                            if(p_NX_Y_Z ~= 0 && conditionalMatrixPN(k,i)~=0 && conditionalMatrixPP(j,k)~=0)
                                %p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z)))
                                DETValue_NX_Y_Z =  p_NX_Y_Z*real(log(p_NX_Y_Z/...
                                    (conditionalMatrixPN(k,i)*conditionalMatrixPP(j,k)*(1-independentProbabilities(i)))));
                            end
                            if(p_X_NY_Z ~= 0&& conditionalMatrixPP(k,i)~=0 && conditionalMatrixNP(j,k)~=0)
                                %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z)))
                                DETValue_X_NY_Z = p_X_NY_Z*real(log(p_X_NY_Z/...
                                    (conditionalMatrixPP(k,i)*conditionalMatrixNP(j,k)*independentProbabilities(i))));
                            end
                            if(p_X_Y_NZ ~= 0 && conditionalMatrixNP(k,i)~=0 && conditionalMatrixPN(j,k)~=0)
                                % p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
                                DETValue_X_Y_NZ = p_X_Y_NZ*real(log(p_X_Y_NZ/...
                                    (conditionalMatrixNP(k,i)*conditionalMatrixPN(j,k)*(independentProbabilities(i)))));
                            end
                            if(p_X_NY_NZ ~= 0 && conditionalMatrixNP(k,i)~=0 && conditionalMatrixNN(j,k)~=0)
                                %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z)))
                                DETValue_X_NY_NZ = p_X_NY_NZ*real(log(p_X_NY_NZ/...
                                    (conditionalMatrixNP(k,i)*conditionalMatrixNN(j,k)*(independentProbabilities(i)))));
                            end
                            if(p_NX_Y_NZ ~= 0&& conditionalMatrixNN(k,i)~=0 && conditionalMatrixPN(j,k)~=0)
                                %p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
                                DETValue_NX_Y_NZ = p_NX_Y_NZ*real(log(p_NX_Y_NZ/...
                                    (conditionalMatrixNN(k,i)*conditionalMatrixPN(j,k)*(1-independentProbabilities(i)))));
                            end
                            if(p_NX_NY_Z ~= 0 && conditionalMatrixPN(k,i)~=0 && conditionalMatrixNP(j,k)~=0)
                                %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z)))
                                DETValue_NX_NY_Z =  p_NX_NY_Z*real(log(p_NX_NY_Z/...
                                    (conditionalMatrixPN(k,i)*conditionalMatrixNP(j,k)*(1-independentProbabilities(i)))));
                            end
                            if(p_NX_NY_NZ ~= 0 && conditionalMatrixNN(k,i)~=0 && conditionalMatrixNN(j,k)~=0)
                                % p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
                                DETValue_NX_NY_NZ = p_NX_NY_NZ*real(log(p_NX_NY_NZ/...
                                    (conditionalMatrixNN(k,i)*conditionalMatrixNN(j,k)*(1-independentProbabilities(i)))));
                            end
                            DETValue = DETValue_X_Y_Z + DETValue_NX_Y_Z + DETValue_X_NY_Z +...
                                DETValue_X_Y_NZ + DETValue_NX_NY_Z + DETValue_NX_Y_NZ + ...
                                DETValue_X_NY_NZ + DETValue_NX_NY_NZ;
                            if (DETValue < 0)
                                directPath = false;
                                break;
                            end
                        end
                    end
                end
                if directPath
                    CausalRelation(i,j) = 1;
                    CausalRelation(j,i) = -1;
                    causeConsequenceArray = [causeConsequenceArray;[i,j]];
                    for k = 1:size(occurencesMatrix,1) % check if there is a direct path between k -> j
                        if(k ~= i && k ~=j && transferEntropyMatrix(i,k) > 0 && transferEntropyMatrix(k,j) > 0) 
                            if transferEntropyMatrix(i,j) > transferEntropyMatrix(i,k)+ transferEntropyMatrix(k,j)
                                CausalRelation(k,j) = 1;
                                CausalRelation(j,k) = -1;
                                causeConsequenceArray = [causeConsequenceArray;[k,j]];
                            else
                                CausalRelation(k,j) = 0;
                                CausalRelation(j,k) = 0;
                            end
                            
                        end
                    end
                end
            end
        end
    end
end
for i=1:size(CausalRelation,1)
    for j=1:size(CausalRelation,1)
        if     CausalRelation(i,j) == intializerConstant
            CausalRelation(i,j) = 0;
        end
    end
end
causeConsequenceArray = unique(causeConsequenceArray, 'rows', 'first');
DAG = sparse(causeConsequenceArray(:,1),causeConsequenceArray(:,2),true);
end
function [numberString] = mappingNumbersIntoString(firstNumber,secondNumber,thirdNumber)
numberString = string(firstNumber)+"-" + string(secondNumber)+ "-"+ string(thirdNumber);
numberString = convertStringsToChars(numberString);
end

