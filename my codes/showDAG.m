function showDAG(DAG,idMaps)
DAGbg = biograph(DAG);
DAGbg.Scale = 2.0;
DAGbg.LayoutScale = 0.005;
DAGbg.EdgeType = 'straight';
dolayout(DAGbg);
for i = 1:size(DAG,1)
DAGbg.nodes(i).Shape = 'circle';
DAGbg.nodes(i).Label = int2str(idMaps{i,2});
end
view(DAGbg)
end

