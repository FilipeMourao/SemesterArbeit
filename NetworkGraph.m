


%% Mutual Information
% A = I;
% col = sum(isnan(A)|(A==0))~=size(A,1);
% A=A(col,col);
% 
% A(isnan(A))=0;
%A = ones(size(A)).*max(A(:))-A;

%% Jacob Factor
A = jF;
col = sum(isnan(A)|(A==0))~=size(A,1);
A=A(col,col);

A2 = A;

A(A==0) = 1e-20;
A(isnan(A))=0;
A = A - diag(diag(A));

A2(A2==0) = 1e-20;
A2(isnan(A2))= max(A2(:));
A2 = A2- diag(diag(A2));



C3 = mdscale(A,2,'Weights',A,'Start','random','criterion','metricstress','Options',statset('MaxIter',500));

%figure
%plot(graph(A), 'XData', C3(:,1), 'YData',C3(:,2),'LineStyle','none');



C2 = mdscale(A2,2,'Weights',A2,'Start','random','criterion','metricstress','Options',statset('MaxIter',500));
C = mdscale(A,2,'Weights',A,'Start',C2,'criterion','metricstress','Options',statset('MaxIter',500));

figure
subplot(1,2,1)
plot(graph(A), 'XData', C3(:,1), 'YData',C3(:,2),'LineStyle','none');
axis equal

subplot(1,2,2)
plot(graph(A), 'XData', C(:,1), 'YData',C(:,2),'LineStyle','none');

axis equal

%for i=1:size(A,1)
%text(C(i,1),C(i,2),num2str(i,'%d'))
%end

%% Gephi
A_gephi = A;
A_gephi=abs(A_gephi-(A_gephi>0).*max(A_gephi(:)));
adj2gephilab('A',A_gephi);