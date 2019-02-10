% function [CausalRelation, DAG]= creatingDirectedAcyclicGraphMarkov(transferEntropyMatrix,occurencesMatrix,mapTriples,...
%     conditionalMatrixPP,conditionalMatrixPN,conditionalMatrixNP,conditionalMatrixNN,independentProbabilities)
% intializerConstant = 5;
% CausalRelation = ones(size(occurencesMatrix))*intializerConstant ;
% causeConsequenceArray = [];
% totalAlarmOccurences = sum(independentProbabilities(:,2));
% %computing the diferential direct transfer entropy DTE
% % D_x->y = sum (P(X,Y,Z)*log(P(X,Y,Z)/(P(X|Z)*(P(Y|Z)*P(Z)))) =
% %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z))) + p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z)))
% %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z))) + p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
% %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z))) + p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
% %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z))) + p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
% for i = 1:size(occurencesMatrix,1)
%     for j = 1:size(occurencesMatrix,1)
%         if(i ~=j)
%             if( CausalRelation(i,j) == intializerConstant && CausalRelation(j,i) == intializerConstant && transferEntropyMatrix(i,j) > 0 )
%                 %132
%                 %312
%                 %calculate the DET
%                 directPath = true;
%                 for k = 1:size(occurencesMatrix,1)
%                     if(k ~= i && k ~=j && transferEntropyMatrix(i,k) > 0 && transferEntropyMatrix(k,j) > 0)
%                         DETValue = 0;
%                         numberString = mappingNumbersIntoString(i,k,j);
%                         tripleOcurrence_X_Y_Z = mapTriples(numberString) ;
%                         if tripleOcurrence_X_Y_Z > 0
%                             p_X_Y_Z = tripleOcurrence_X_Y_Z/totalAlarmOccurences;
%                             p_NX_Y_Z = (occurencesMatrix(j,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
%                             p_X_NY_Z = (occurencesMatrix(k,i))/totalAlarmOccurences;
%                             %to hard to calculate
%                             %                             p_X_NY_Z = (occurencesMatrix(k,i) - (occurencesMatrix(j,k)...
%                             %                             - tripleOcurrence_X_Y_Z ))/totalAlarmOccurences;
%                             p_X_Y_NZ = (occurencesMatrix(j,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
%                             p_NX_Y_NZ = (occurencesMatrix(j,j) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,i)...
%                                 - occurencesMatrix(k,j) )/totalAlarmOccurences;
%                             p_NX_NY_Z = (occurencesMatrix(k,k) + tripleOcurrence_X_Y_Z - occurencesMatrix(k,i)...
%                                 - occurencesMatrix(k,j) )/totalAlarmOccurences;
%                             p_X_NY_NZ = (occurencesMatrix(i,i) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,i)...
%                                 - occurencesMatrix(k,i) )/totalAlarmOccurences;
%                             p_NX_NY_NZ = 1 - p_X_Y_Z - -p_NX_Y_Z - p_X_NY_Z -...
%                             p_X_Y_NZ - p_X_NY_NZ - p_NX_Y_NZ - p_NX_NY_Z;
%                         DETValue_X_Y_Z = 0;
%                         DETValue_NX_Y_Z = 0;
%                         DETValue_X_NY_Z = 0;
%                         DETValue_X_Y_NZ = 0;
%                         DETValue_NX_NY_Z = 0;
%                         DETValue_NX_Y_NZ = 0;
%                         DETValue_X_NY_NZ = 0;
%                         DETValue_NX_NY_NZ = 0;
%                             if(p_X_Y_Z ~= 0 && conditionalMatrixPP(i,k)~=0 && conditionalMatrixPP(j,k)~=0  )
%                                 %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z)))
%                                 DETValue_X_Y_Z =  p_X_Y_Z*real(log(p_X_Y_Z/...
%                                     (conditionalMatrixPP(i,k)*conditionalMatrixPP(j,k)*independentProbabilities(k))));
%                             end
%                             if(p_NX_Y_Z ~= 0 && conditionalMatrixNP(i,k)~=0 && conditionalMatrixPP(j,k)~=0)
%                                 %p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z)))
%                                 DETValue_NX_Y_Z =  p_NX_Y_Z*real(log(p_NX_Y_Z/...
%                                     (conditionalMatrixNP(i,k)*conditionalMatrixPP(j,k)*independentProbabilities(k))));
%                             end
%                             if(p_X_NY_Z ~= 0&& conditionalMatrixPP(i,k)~=0 && conditionalMatrixNP(j,k)~=0)
%                                 %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z)))
%                                 DETValue_X_NY_Z = p_X_NY_Z*real(log(p_X_NY_Z/...
%                                     (conditionalMatrixPP(i,k)*conditionalMatrixNP(j,k)*independentProbabilities(k))));
%                             end
%                             if(p_X_Y_NZ ~= 0 && conditionalMatrixPN(i,k)~=0 && conditionalMatrixPN(j,k)~=0)
%                                 % p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
%                                 DETValue_X_Y_NZ = p_X_Y_NZ*real(log(p_X_Y_NZ/...
%                                     (conditionalMatrixPN(i,k)*conditionalMatrixPN(j,k)*(1- independentProbabilities(k)))));
%                             end
%                             if(p_X_NY_NZ ~= 0 && conditionalMatrixPN(i,k)~=0 && conditionalMatrixNN(j,k)~=0)
%                                 %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z)))
%                                 DETValue_X_NY_NZ = p_X_NY_NZ*real(log(p_X_NY_NZ/...
%                                     (conditionalMatrixPN(i,k)*conditionalMatrixNN(j,k)*(1-independentProbabilities(k)))));
%                             end
%                             if(p_NX_Y_NZ ~= 0&& conditionalMatrixNN(i,k)~=0 && conditionalMatrixPN(j,k)~=0)
%                                 %p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
%                                 DETValue_NX_Y_NZ = p_NX_Y_NZ*real(log(p_NX_Y_NZ/...
%                                     (conditionalMatrixNN(i,k)*conditionalMatrixPN(j,k)*(1-independentProbabilities(k)))));
%                             end
%                             if(p_NX_NY_Z ~= 0 && conditionalMatrixNP(i,k)~=0 && conditionalMatrixNP(j,k)~=0)
%                                 %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z)))
%                                 DETValue_NX_NY_Z =  p_NX_NY_Z*real(log(p_NX_NY_Z/...
%                                     (conditionalMatrixNP(i,k)*conditionalMatrixNP(j,k)*independentProbabilities(k))));
%                             end
%                             if(p_NX_NY_NZ ~= 0 && conditionalMatrixNN(i,k)~=0 && conditionalMatrixNN(j,k)~=0)
%                                 % p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
%                                 DETValue_NX_NY_NZ = p_NX_NY_NZ*real(log(p_NX_NY_NZ/...
%                                     (conditionalMatrixNN(i,k)*conditionalMatrixNN(j,k)*(1-independentProbabilities(k)))));
%                             end
%                             DETValue = DETValue_X_Y_Z + DETValue_NX_Y_Z + DETValue_X_NY_Z +...
%                             DETValue_X_Y_NZ + DETValue_NX_NY_Z + DETValue_NX_Y_NZ + ...
%                             DETValue_X_NY_NZ + DETValue_NX_NY_NZ;
%                             if (DETValue < 0)
%                                 directPath = false;
%                                 break;
%                             else % check if there is a direct path between k -> j
%                                 DETValue = 0;
% %                                 numberString = mappingNumbersIntoString(k,i,j);
% %                                 tripleOcurrence_X_Y_Z = mapTriples(numberString) ;
%                                 if tripleOcurrence_X_Y_Z > 0
% %                                     p_X_Y_Z = tripleOcurrence_X_Y_Z/totalAlarmOccurences;
% %                                     p_NX_Y_Z = (occurencesMatrix(j,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
% %                                     p_X_NY_Z = (occurencesMatrix(i,k))/totalAlarmOccurences;
% %                                     %to hard to calculate
% %                                     %                             p_X_NY_Z = (occurencesMatrix(k,i) - (occurencesMatrix(j,k)...
% %                                     %                             - tripleOcurrence_X_Y_Z ))/totalAlarmOccurences;
% %                                     p_X_Y_NZ = (occurencesMatrix(j,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
% %                                     p_NX_Y_NZ = (occurencesMatrix(j,j) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,i)...
% %                                         - occurencesMatrix(k,j) )/totalAlarmOccurences;
% %                                     p_NX_NY_Z = (occurencesMatrix(i,i) + tripleOcurrence_X_Y_Z - occurencesMatrix(i,k)...
% %                                         - occurencesMatrix(i,j) )/totalAlarmOccurences;
% %                                     p_X_NY_NZ = (occurencesMatrix(k,k) + tripleOcurrence_X_Y_Z - occurencesMatrix(j,k)...
% %                                         - occurencesMatrix(i,k) )/totalAlarmOccurences;
%                                     if(p_X_Y_Z ~= 0&& conditionalMatrixPP(k,i)~=0 && conditionalMatrixPP(j,i)~=0)
%                                         %p(x,y,z)*log(p(x,y,z)/(p(z|x)*p(y|x)*p(x)))
%                                         DETValue_X_Y_Z =  p_X_Y_Z*real(log(p_X_Y_Z/...
%                                             (conditionalMatrixPP(k,i)*conditionalMatrixPP(j,i)*independentProbabilities(i))));
%                                     end
%                                     if(p_NX_Y_Z ~= 0&& conditionalMatrixPN(k,i)~=0 && conditionalMatrixPN(j,i)~=0)
%                                         %p(~x,y,z)*log(p(~x,y,z)/(p(z|~x)*p(y|~x)*p(~x)))
%                                         DETValue_NX_Y_Z =  p_NX_Y_Z*real(log(p_NX_Y_Z/...
%                                             (conditionalMatrixPN(k,i)*conditionalMatrixPN(j,i)*(1 - independentProbabilities(i)))));
%                                     end
%                                     if(p_X_NY_Z ~= 0&& conditionalMatrixPP(k,i)~=0 && conditionalMatrixNP(j,i)~=0)
%                                         %p(x,~y,z)*log(p(x,~y,z)/(p(z|x)*p(~y|x)*p(x)))
%                                         DETValue_X_NY_Z = p_X_NY_Z*real(log(p_X_NY_Z/...
%                                             (conditionalMatrixPP(k,i)*conditionalMatrixNP(j,i)*independentProbabilities(i))));
%                                     end
%                                     if(p_X_Y_NZ ~= 0&& conditionalMatrixNP(k,i)~=0 && conditionalMatrixPP(j,i)~=0)
%                                         % p(x,y,~z)*log(p(x,y,~z)/(p(~z|x)*p(y|x)*p(x)))
%                                         DETValue_X_Y_NZ =  p_X_Y_NZ*real(log(p_X_Y_NZ/...
%                                             (conditionalMatrixNP(k,i)*conditionalMatrixPP(j,i)*(independentProbabilities(i)))));
%                                     end
%                                     if(p_X_NY_NZ ~= 0 && conditionalMatrixNP(k,i)~=0 && conditionalMatrixNP(j,i)~=0)
%                                         %p(x,~y,~z)*log(p(x,~y,~z)/(p(~z|x)*p(~y|x)*p(x)))
%                                         DETValue_X_NY_NZ =  p_X_NY_NZ*real(log(p_X_NY_NZ/...
%                                             (conditionalMatrixNP(k,i)*conditionalMatrixNP(j,i)*(independentProbabilities(i)))));
%                                     end
%                                     if(p_NX_Y_NZ ~= 0&& conditionalMatrixNN(k,i)~=0 && conditionalMatrixPN(j,i)~=0)
%                                         %p(~x,y,~z)*log(p(~x,y,~z)/(p(~z|~x)*p(y|~x)*p(~x)))
%                                         DETValue_NX_Y_NZ =  p_NX_Y_NZ*real(log(p_NX_Y_NZ/...
%                                             (conditionalMatrixNN(k,i)*conditionalMatrixPN(j,i)*(1-independentProbabilities(i)))));
%                                     end
%                                     if(p_NX_NY_Z ~= 0&& conditionalMatrixPN(k,i)~=0 && conditionalMatrixNP(j,i)~=0)
%                                         %p(~x,~y,z)*log(p(~x,~y,z)/(p(z|~x)*p(~y|x)*p(~x)))
%                                         DETValue_NX_NY_Z =  p_NX_NY_Z*real(log(p_NX_NY_Z/...
%                                             (conditionalMatrixPN(k,i)*conditionalMatrixNP(j,i)*(1 - independentProbabilities(i)))));
%                                     end
%                                     if(p_NX_NY_NZ ~= 0&& conditionalMatrixNN(k,i)~=0 && conditionalMatrixNN(j,i)~=0)
%                                         % p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~z|~x)*p(~y|~x)*p(~x)))
%                                         DETValue_NX_NY_NZ = p_NX_NY_NZ*real(log(p_NX_NY_NZ/...
%                                             (conditionalMatrixNN(k,i)*conditionalMatrixNN(j,i)*(1-independentProbabilities(i)))));
%                                     end
%                                    DETValue = DETValue_X_Y_Z + DETValue_NX_Y_Z + DETValue_X_NY_Z +...
%                                    DETValue_X_Y_NZ + DETValue_NX_NY_Z + DETValue_NX_Y_NZ + ...
%                                    DETValue_X_NY_NZ + DETValue_NX_NY_NZ;
%                                     if DETValue > 0
%                                         CausalRelation(k,j) = 1;
%                                         CausalRelation(j,k) = -1;
%                                         causeConsequenceArray = [causeConsequenceArray;[k,j]];
%                                     else
%                                         CausalRelation(k,j) = 0;
%                                         CausalRelation(j,k) = 0;
%                                     end
%                                 end
%                             end
%                         end
%                     end
%                 end
%                 if directPath
%                     CausalRelation(i,j) = 1;
%                     CausalRelation(j,i) = -1;
%                     causeConsequenceArray = [causeConsequenceArray;[i,j]];
%                 end
%             end
%         end
%     end
% end
% for i=1:size(CausalRelation,1)
%     for j=1:size(CausalRelation,1)
%     if     CausalRelation(i,j) == intializerConstant
%         CausalRelation(i,j) = 0;
%     end
%     end
% end
% causeConsequenceArray = unique(causeConsequenceArray, 'rows', 'first');
% DAG = sparse(causeConsequenceArray(:,1),causeConsequenceArray(:,2),true);
% end
% function [numberString] = mappingNumbersIntoString(firstNumber,secondNumber,thirdNumber)
% numberString = string(firstNumber)+"-" + string(secondNumber)+ "-"+ string(thirdNumber);
% numberString = convertStringsToChars(numberString);
% end
%
function [CausalRelation, DAG]= creatingDirectedAcyclicGraphMarkov(transferEntropyMatrix,occurencesMatrix,mapTriples,...
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
                            numberString = mappingNumbersIntoString(i,k,j);
                            tripleOcurrence_X_Y_Z = mapTriples(numberString) ;
                            if tripleOcurrence_X_Y_Z > 0
                                p_X_Y_Z = tripleOcurrence_X_Y_Z/totalAlarmOccurences;
                                p_NX_Y_Z = (occurencesMatrix(j,k) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
                                %to hard to calculate
                                % p_X_NY_Z = (occurencesMatrix(k,i))/totalAlarmOccurences;
                                p_X_NY_Z = (occurencesMatrix(k,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;                                p_X_Y_NZ = (occurencesMatrix(j,i) - tripleOcurrence_X_Y_Z )/totalAlarmOccurences;
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
                                if(p_X_Y_Z ~= 0 && conditionalMatrixPP(k,i)~=0 && conditionalMatrixPP(j,i)~=0  )
                                    %p(x,y,z)*log(p(x,y,z)/(p(x|z)*p(y|z)*p(z)))
                                    DETValue_X_Y_Z =  p_X_Y_Z*real(log(p_X_Y_Z/...
                                        (conditionalMatrixPP(k,i)*conditionalMatrixPP(j,i)*independentProbabilities(i))));
                                end
                                if(p_NX_Y_Z ~= 0 && conditionalMatrixPN(k,i)~=0 && conditionalMatrixPN(j,i)~=0)
                                    %p(~x,y,z)*log(p(~x,y,z)/(p(~x|z)*p(y|z)*p(z)))
                                    DETValue_NX_Y_Z =  p_NX_Y_Z*real(log(p_NX_Y_Z/...
                                        (conditionalMatrixPN(k,i)*conditionalMatrixPN(j,i)*(1-independentProbabilities(i)))));
                                end
                                if(p_X_NY_Z ~= 0&& conditionalMatrixPP(k,i)~=0 && conditionalMatrixNP(j,i)~=0)
                                    %p(x,~y,z)*log(p(x,~y,z)/(p(x|z)*p(~y|z)*p(z)))
                                    DETValue_X_NY_Z = p_X_NY_Z*real(log(p_X_NY_Z/...
                                        (conditionalMatrixPP(k,i)*conditionalMatrixNP(j,i)*independentProbabilities(i))));
                                end
                                if(p_X_Y_NZ ~= 0 && conditionalMatrixNP(k,i)~=0 && conditionalMatrixPP(j,i)~=0)
                                    % p(x,y,~z)*log(p(x,y,~z)/(p(x|~z)*p(y|~z)*p(~z)))
                                    DETValue_X_Y_NZ = p_X_Y_NZ*real(log(p_X_Y_NZ/...
                                        (conditionalMatrixNP(k,i)*conditionalMatrixPP(j,i)*(independentProbabilities(i)))));
                                end
                                if(p_X_NY_NZ ~= 0 && conditionalMatrixPN(k,i)~=0 && conditionalMatrixNN(j,i)~=0)
                                    %p(x,~y,~z)*log(p(x,~y,~z)/(p(x|~z)*p(~y|~z)*p(~z)))
                                    DETValue_X_NY_NZ = p_X_NY_NZ*real(log(p_X_NY_NZ/...
                                        (conditionalMatrixNP(k,i)*conditionalMatrixNP(j,i)*(independentProbabilities(i)))));
                                end
                                if(p_NX_Y_NZ ~= 0&& conditionalMatrixNN(k,i)~=0 && conditionalMatrixPN(j,i)~=0)
                                    %p(~x,y,~z)*log(p(~x,y,~z)/(p(~x|~z)*p(y|~z)*p(~z)))
                                    DETValue_NX_Y_NZ = p_NX_Y_NZ*real(log(p_NX_Y_NZ/...
                                        (conditionalMatrixNN(k,i)*conditionalMatrixPN(j,i)*(1-independentProbabilities(i)))));
                                end
                                if(p_NX_NY_Z ~= 0 && conditionalMatrixPN(k,i)~=0 && conditionalMatrixNN(j,i)~=0)
                                    %p(~x,~y,z)*log(p(~x,~y,z)/(p(~x|z)*p(~y|z)*p(z)))
                                    DETValue_NX_NY_Z =  p_NX_NY_Z*real(log(p_NX_NY_Z/...
                                        (conditionalMatrixPN(k,i)*conditionalMatrixNN(j,i)*(1-independentProbabilities(i)))));
                                end
                                if(p_NX_NY_NZ ~= 0 && conditionalMatrixNN(k,i)~=0 && conditionalMatrixNN(j,i)~=0)
                                    % p(~x,~y,~z)*log(p(~x,~y,~z)/(p(~x|~z)*p(~y|~z)*p(~z)))
                                    DETValue_NX_NY_NZ = p_NX_NY_NZ*real(log(p_NX_NY_NZ/...
                                        (conditionalMatrixNN(k,i)*conditionalMatrixNN(j,i)*(1-independentProbabilities(i)))));
                                end
                                DETValue = DETValue_X_Y_Z + DETValue_NX_Y_Z + DETValue_X_NY_Z +...
                                    DETValue_X_Y_NZ + DETValue_NX_NY_Z + DETValue_NX_Y_NZ + ...
                                    DETValue_X_NY_NZ + DETValue_NX_NY_NZ;
                                if DETValue > 0
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

